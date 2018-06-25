#TERM='vt100'
#-------------------------------------------------------------
# Greeting, motd etc. ...
#-------------------------------------------------------------

# Color definitions (taken from Color Bash Prompt HowTo).
# Some colors might look different of some terminals.
# For example, I see 'Bold Red' as 'orange' on my screen,
# hence the 'Green' 'BRed' 'Red' sequence I often use in my prompt.


# Normal Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White

# Background
On_Black='\e[40m'       # Black
On_Red='\e[41m'         # Red
On_Green='\e[42m'       # Green
On_Yellow='\e[43m'      # Yellow
On_Blue='\e[44m'        # Blue
On_Purple='\e[45m'      # Purple
On_Cyan='\e[46m'        # Cyan
On_White='\e[47m'       # White

NC="\e[m"               # Color Reset


ALERT=${BWhite}${On_Red} # Bold White on red background



echo -e "\x1B[0;36mThis is \x1B[0;31m BASH \x1B[0;36m${BASH_VERSION%.*} \x1B[m"
date

#-------------------------------------------------------------
# Shell Prompt - for many examples, see:
#       http://www.debian-administration.org/articles/205
#       http://www.askapache.com/linux/bash-power-prompt.html
#       http://tldp.org/HOWTO/Bash-Prompt-HOWTO
#       https://github.com/nojhan/liquidprompt
#-------------------------------------------------------------
# Current Format: [TIME USER@HOST PWD] >
# TIME:
#    Green     == machine load is low
#    Yello    == machine load is medium
#    Red       == machine load is high
#    ALERT     == machine load is very high
# USER:
#    Green      == normal user
#    Yello    == SU to user
#    Red       == root
# HOST:
#    Green      == local session
#    Yellow     == secured remote connection (via ssh)
#    Red       == unsecured remote connection
# PWD:
#    Green     == more than 10% free disk space
#    Yello    == less than 10% free disk space
#    ALERT     == less than 5% free disk space
#    Red       == current user does not have write privileges
#    Cyan      == current filesystem is size zero (like /proc)
# >:
#    Green     == no background or suspended jobs in this shell
#    Yellow      == at least one background job in this shell
#    Red    == at least one suspended job in this shell
#
#    Command is added to the history file each time you hit enter,
#    so it's available to all shells (using 'history -a').


# Test connection type: Show in hostname
if [ -n "${SSH_CONNECTION}" ]; then
    CNX=${Yellow}        # Connected on remote machine, via ssh (good).
else
    CNX=${Green}        # Connected on local machine.
fi

# Test user type:
if [[ ${USER} == ${SUDO_USER} ]]; then
    SU=${Yello}           # User is sudo.
elif [[ ${USER} != $(logname) ]]; then
    SU=${Cyan}          # User is not login user.
else
    SU=${Green}         # User is normal (well ... most of us are).
fi

LOADAVG=`sysctl -n vm.loadavg | sed 's/^{//g' | sed 's/}$//g' `
export LOADAVG

NCORES=`/usr/sbin/system_profiler -detailLevel full SPHardwareDataType | awk '/Total Number of Cores:/ {print $5};'`
export NCORES
#echo $NCORES

NCPU=`/usr/sbin/system_profiler -detailLevel full SPHardwareDataType | awk '/Number of Processors:/ {print $4};'`   # Number of CPUs
export NCPU
#echo $NCPU

SLOAD=$(( 100*${NCPU} ))        # Small load
MLOAD=$(( 200*${NCPU} ))        # Medium load
XLOAD=$(( 400*${NCPU} ))        # Xlarge load

# Returns system load as percentage, i.e., '40' rather than '0.40)'.
function load()
{
    local SYSLOAD=$(echo ${LOADAVG} | cut -d " " -f1 - | tr -d '.')
    # System load of the current host.
    echo $((100-10#$SYSLOAD))       # Convert to decimal.
}

# Returns a color indicating system load.
function load_color()
{
    local SYSLOAD=$(load)
    if [ ${SYSLOAD} -gt ${XLOAD} ]; then
        echo -en ${ALERT}
    elif [ ${SYSLOAD} -gt ${MLOAD} ]; then
        echo -en ${Red}
    elif [ ${SYSLOAD} -gt ${SLOAD} ]; then
        echo -en ${BRed}
    else
        echo -en ${Green}
    fi
}

# Returns a color according to free disk space in $PWD.
function disk_color()
{
    if [ ! -w "${PWD}" ];
    then
        echo -en ${Yello}
        # No 'write' privilege in the current directory.
    elif [ -s "${PWD}" ];
 then
        local used=$(command df -P "$PWD" | awk 'END {print $5}' | sed -e 's/%$//')
        if [ ${used} -gt 95 ]; then
            echo -en ${ALERT}           # Disk almost full (>95%).
        elif [ ${used} -gt 90 ]; then
            echo -en ${BRed}            # Free disk space almost gone.
        else
            echo -en ${Green}           # Free disk space is ok.
        fi
    else
        echo -en ${Cyan}
        # Current directory is size '0' (like /proc, /sys etc).
    fi
}

# Returns a color according to suspended/running jobs.
function job_color()
{
    SJOBS=`jobs -s | wc -l | sed -e 's/\s//g'`;
    RJOBS=`jobs -r | wc -l | sed -e 's/\s//g'`;
#	echo -n ${SJOBS}/${RJOBS}
    if [ ${SJOBS} -gt "0" ]; then
        echo -en ${Red}
    elif [ ${RJOBS} -gt "0" ] ; then
        echo -en ${Yello}
    else
	echo -en ${Green}
	fi
}

# Adds some text in the terminal frame (if applicable).


# Now we construct the prompt.
PROMPT_COMMAND="history -a"
#echo ${TERM}
case ${TERM} in
  *term | rxvt | linux | xterm-256color | vt100 )
	LC="$(load_color)"
	DC="$(disk_color)"
	JC="$(job_color)"
        # Time of day (with load info):
        PS1="\[${LC}\]\A\[${NC}\] "
        # User@Host (with connection type info):
        PS1=${PS1}"\[${SU}\]\u\[${NC}\]@\[${CNX}\]\h\[${NC}\] "
        # PWD (with 'disk space' info):
        PS1=${PS1}"\[${DC}\]\W\[${NC}\] "
        # Prompt (with 'job' info):
        PS1=${PS1}"\[${JC}\]>\[${NC}\] "
        # Set title of current xterm:
        PS1=${PS1}"\[\e]0;[\d \j jobs] \w\a\]"
        ;;
    *)
        PS1="(\A \u@\h \W) > " # --> PS1="(\A \u@\h \w) > "
                               # --> Shows full pathname of current dir.
        ;;
esac
