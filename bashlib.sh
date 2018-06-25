#! /usr/bin/env bash
# ___________________________________________________________________________ #
#                                                                             #
#       BashLIB -- A library for Bash scripting convenience.                  #
#                                                                             #
#                                                                             #
#    Licensed under the Apache License, Version 2.0 (the "License");          #
#    you may not use this file except in compliance with the License.         #
#    You may obtain a copy of the License at                                  #
#                                                                             #
#        http://www.apache.org/licenses/LICENSE-2.0                           #
#                                                                             #
#    Unless required by applicable law or agreed to in writing, software      #
#    distributed under the License is distributed on an "AS IS" BASIS,        #
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. #
#    See the License for the specific language governing permissions and      #
#    limitations under the License.                                           #
# ___________________________________________________________________________ #
#                                                                             #
#                                                                             #
# Copyright 2007-2011, lhunath                                                #
#   * http://www.lhunath.com                                                  #
#   * Maarten Billemont                                                       #
#                                                                             #

set -x

#  ______________________________________________________________________ 
# |                                                                      |
# |                                         .:: GLOBAL CONFIGURATION ::. |
# |______________________________________________________________________|

# Unset all exported functions.  Exported functions are evil.
while read _ _ func; do
    command unset -f "$func"
done < <(command declare -Fx)

{
shopt -s extglob
shopt -s globstar
} 2>/dev/null ||:




#  ______________________________________________________________________ 
# |                                                                      |
# |                                          .:: GLOBAL DECLARATIONS ::. |
# |______________________________________________________________________|

# Variables for global internal operation.
bobber=(     '.' 'o' 'O' 'o' )
spinner=(    '-' \\  '|' '/' )
crosser=(    '+' 'x' '+' 'x' )
runner=(     '> >'           \
             '>> '           \
             '>>>'           \
             ' >>'           )

# Variables for terminal requests.
[[ -t 2 ]] && {
    alt=$(      tput smcup  || tput ti      ) # Start alt display
    ealt=$(     tput rmcup  || tput te      ) # End   alt display
    hide=$(     tput civis  || tput vi      ) # Hide cursor
    show=$(     tput cnorm  || tput ve      ) # Show cursor
    save=$(     tput sc                     ) # Save cursor
    load=$(     tput rc                     ) # Load cursor
    bold=$(     tput bold   || tput md      ) # Start bold
    stout=$(    tput smso   || tput so      ) # Start stand-out
    estout=$(   tput rmso   || tput se      ) # End stand-out
    under=$(    tput smul   || tput us      ) # Start underline
    eunder=$(   tput rmul   || tput ue      ) # End   underline
    reset=$(    tput sgr0   || tput me      ) # Reset cursor
    blink=$(    tput blink  || tput mb      ) # Start blinking
    italic=$(   tput sitm   || tput ZH      ) # Start italic
    eitalic=$(  tput ritm   || tput ZR      ) # End   italic


[[ $TERM != *-m ]] && {
    red=$(      tput setaf 1|| tput AF 1    )
    green=$(    tput setaf 2|| tput AF 2    )
    yellow=$(   tput setaf 3|| tput AF 3    )
    blue=$(     tput setaf 4|| tput AF 4    )
    magenta=$(  tput setaf 5|| tput AF 5    )
    cyan=$(     tput setaf 6|| tput AF 6    )
}
    white=$(    tput setaf 7|| tput AF 7    )
    default=$(  tput op                     )
    eed=$(      tput ed     || tput cd      )   # Erase to end of display
    eel=$(      tput el     || tput ce      )   # Erase to end of line
    ebl=$(      tput el1    || tput cb      )   # Erase to beginning of line
    ewl=$eel$ebl                                # Erase whole line
    draw=$(     tput -S <<< '   enacs
                                smacs
                                acsc
                                rmacs' || { \ 
                tput eA; tput as;
                tput ac; tput ae;         } )   # Drawing characters
    back=$'\b'
} 2>/dev/null ||:





#  ______________________________________________________________________ 
# |                                                                      |
# |                                        .:: FUNCTION DECLARATIONS ::. |
# |______________________________________________________________________|



#  ______________________________________________________________________
# |__ Chr _______________________________________________________________|
#
#       chr decimal
#
# Outputs the character that has the given decimal ASCII value.
#
chr() {
    printf \\"$(printf '%03o' "$1")"
} # _____________________________________________________________________



#  ______________________________________________________________________
# |__ Ord _______________________________________________________________|
#
#       ord character
#
# Outputs the decimal ASCII value of the given character.
#
ord() {
    printf %d "'$1"
} # _____________________________________________________________________



#  ______________________________________________________________________
# |__ Hex _______________________________________________________________|
#
#       hex character
#
# Outputs the hexadecimal ASCII value of the given character.
#
hex() { 
  printf '%x' "'$1"
} # _____________________________________________________________________



#  ______________________________________________________________________
# |__ Unhex _______________________________________________________________|
#
#       unhex character
#
# Outputs the character that has the given decimal ASCII value.
#
unhex() {
  printf \\x"$1"
} # _____________________________________________________________________



#  ______________________________________________________________________
# |__ max _______________________________________________________________|
#
#       max numbers...
#
# Outputs the highest of the given numbers.
#
max() {
  local max=$1 n
  for n
  do (( n > max )) && max=$n; done
  printf %d "$max"
} # _____________________________________________________________________



#  ______________________________________________________________________
# |__ min _______________________________________________________________|
#
#       min numbers...
#
# Outputs the lowest of the given numbers.
#
min() {
  local min=$1 n
  for n
  do (( n < min )) && min=$n; done
  printf %d "$min"
} # _____________________________________________________________________



#  ______________________________________________________________________
# |__ Exists ____________________________________________________________|
#
#       exists application
#
# Returns successfully if the application is in PATH and is executable
# by the current user.
#
exists() {
    [[ -x $(type -P "$1" 2>/dev/null) ]]
} # _____________________________________________________________________



#  ______________________________________________________________________
# |__ Eol _______________________________________________________________|
#
#       eol message
#
# Return termination punctuation for a message, if necessary.
#
eol() {
    : #[[ $1 && $1 != *[\!\?.,:\;\|] ]] && printf .. ||:
} # _____________________________________________________________________



#  ______________________________________________________________________
# |__ Hr _______________________________________________________________|
#
#       hr pattern [length]
#
# Outputs a horizontal ruler of the given length in characters or the terminal column length otherwise.
# The ruler is a repetition of the given pattern string.
#
hr() {
    local pattern=${1:--} length=${2:-$COLUMNS} ruler=
    (( length )) || length=$(tput cols)

    while (( ${#ruler} < length )); do
        ruler+=${pattern:0:length-${#ruler}}
    done

    printf %s "$ruler"
} # _____________________________________________________________________



#  ______________________________________________________________________
# |__ CLoc ______________________________________________________________|
#
#       cloc
#
# Outputs the current cursor location as two space-separated numbers: row column
#
cloc() {
    local old=$(stty -g)
    trap 'stty "$old"' RETURN
    stty raw

    # If the tty has input waiting then we can't read back its response.  We'd only break and pollute the tty input buffer.
    read -t 0 < /dev/tty 2>/dev/null && return 1

    printf '\e[6n' > /dev/tty
    IFS='[;' read -dR _ row col < /dev/tty
    printf '%d %d' "$row" "$col"
} # _____________________________________________________________________



#  ______________________________________________________________________
# |__ readwhile ______________________________________________________________|
#
#       readwhile command [args]
#
# Outputs the characters typed by the user into the terminal's input buffer while running the given command.
#
readwhile() {
    local old=$(stty -g) in result REPLY
    trap 'stty "$old"' RETURN
    stty raw

    "$@"
    result=$?

    while read -t 0; do
        IFS= read -rd '' -n1 && in+=$REPLY
    done
    printf %s "$in"

    return $result
} # _____________________________________________________________________



#  ___________________________________________________________________________
# |__ pushqueue ______________________________________________________________|
#
#       pushqueue element ...
#
# Pushes the given arguments as elements onto the queue.
#
pushqueue() {
    [[ $_queue ]] || {
        coproc _queue {
            while IFS= read -r -d ''; do
                printf '%s\0' "$REPLY"
            done
        }
    }

    printf '%s\0' "$@" >&"${_queue[1]}"
} # _____________________________________________________________________



#  __________________________________________________________________________
# |__ popqueue ______________________________________________________________|
#
#       popqueue
#
# Pops one element off the queue.
# If no elements are available on the queue, this command fails with exit code 1.
#
popqueue() {
    local REPLY
    [[ $_queue ]] && read -t0 <&"${_queue[0]}" || return
    IFS= read -r -d '' <&"${_queue[0]}"
    printf %s "$REPLY"
} # _____________________________________________________________________



#  ______________________________________________________________________
# |__ Latest ____________________________________________________________|
#
#       latest [file...]
#
# Output the argument that represents the file with the latest modification time.
#
latest() (
    shopt -s nullglob
    local file latest=$1
    for file; do
        [[ $file -nt $latest ]] && latest=$file
    done
    printf '%s\n' "$latest"
)


#  ______________________________________________________________________
# |__ Logging ___________________________________________________________|
#
#       log [format] [arguments...]
#
# Log an event at a certain importance level.  The event is expressed as a printf(1) format argument.
# The current exit code remains unaffected by the execution of this function.
#
log() {
    local exitcode=$? level=${level:-inf} supported=0 end=$'\n' type=msg conMsg= logMsg= format= colorFormat= date= info= arg= args=() colorArgs=() ruler=

    # Handle options.
    unset OPTIND
    while getopts :puPr arg; do
        case $arg in
            p)
                end='.. '
                type=startProgress ;;
            u)
                end='.. '
                type=updateProgress ;;
            P)
                type=stopProgress ;;
            r)
                ruler='____' ;;
        esac
    done
    shift "$((OPTIND-1))"
    format=$1 args=( "${@:2}" )

    # Level-specific settings.
    case $level in
        DBG)    (( supported = _logVerbosity >= 3 ))
                color=$_logDbgColor ;;
        INF)    (( supported = _logVerbosity >= 2 ))
                color=$_logInfColor ;;
        WRN)    (( supported = _logVerbosity >= 1 ))
                color=$_logWrnColor ;;
        ERR)    (( supported = _logVerbosity >= 0 ))
                color=$_logErrColor ;;
        FTL)    (( supported = 1 ))
                color=$_logFtlColor ;;
        *)
                log FTL "Log level %s does not exist" "$level"
                exit 1 ;;
    esac
    (( ! supported )) && return "$exitcode"

    # Generate the log message.
    date=$(date +"${_logDate:-%H:%M}")
    case $type in
        msg|startProgress)
            printf -v logMsg "[%s %-3s] $format$end" "$date" "$level" "${args[@]}"
            if (( _logColor )); then
                colorFormat=$(sed -e "s/$(requote "$reset")/$reset$color/g" -e "s/%[^a-z]*[a-z]/$reset$bold$color&$reset$color/g" <<< "$format")
                colorArgs=("${args[@]//$reset/$reset$bold$color}")
                printf -v conMsg "[%s %-3s] $color$colorFormat$reset$end$save" "$date" "$level" "${colorArgs[@]}"
            else
                conMsg=$logMsg
            fi
        ;;

        updateProgress)
            printf -v logMsg printf " [$format]" "${args[@]}"
            if (( _logColor )); then
                colorFormat=$(sed -e "s/$(requote "$reset")/$reset$color/g" -e "s/%[^a-z]*[a-z]/$reset$bold$color&$reset$color/g" <<< "$format")
                colorArgs=("${args[@]//$reset/$reset$bold$color}")
                printf -v conMsg "$load$eel$blue$bold[$reset$color$colorFormat$reset$blue$bold]$reset$end" "${colorArgs[@]}"
            else
                conMsg=$logMsg
            fi
        ;;

        stopProgress)
            case $exitcode in
                0)  printf -v logMsg "done${format:+ ($format)}.\n" "${args[@]}"
                    if (( _logColor )); then
                        colorFormat=$(sed -e "s/$(requote "$reset")/$reset$color/g" -e "s/%[^a-z]*[a-z]/$reset$bold$color&$reset$color/g" <<< "$format")
                        colorArgs=("${args[@]//$reset/$reset$bold$color}")
                        printf -v conMsg "$load$eel$green${bold}done${colorFormat:+ ($reset$color$colorFormat$reset$green$bold)}$reset.\n" "${colorArgs[@]}"
                    else
                        conMsg=$logMsg
                    fi
                ;;

                *)  info=${format:+$(printf ": $format" "${args[@]}")}
                    printf -v logMsg "error(%d%s).\n" "$exitcode" "$info"
                    if (( _logColor )); then
                        printf -v conMsg "${eel}${red}error${reset}(${bold}${red}%d${reset}%s).\n" "$exitcode" "$info"
                    else
                        conMsg=$logMsg
                    fi
                ;;
            esac
        ;;
    esac

    # Create the log file.
    if [[ $_logFile && ! -e $_logFile ]]; then
        [[ $_logFile = */* ]] || $_logFile=./$logFile
        mkdir -p "${_logFile%/*}" && touch "$_logFile"
    fi

    # Stop the spinner.
    if [[ $type = stopProgress && $_logSpinner ]]; then
        kill "$_logSpinner"
        wait "$_logSpinner" 2>/dev/null
        unset _logSpinner
    fi

    # Output the ruler.
    if [[ $ruler ]]; then
        printf >&2 '%s\n' "$(hr "$ruler")"
        [[ -w $_logFile ]] \
            && printf >> "$_logFile" '%s' "$ruler"
    fi

    # Output the log message.
    printf >&2 '%s' "$conMsg"
    [[ -w $_logFile ]] \
        && printf >> "$_logFile" '%s' "$logMsg"

    # Start the spinner.
    if [[ $type = startProgress && ! $_logSpinner ]]; then
        {
            set +m
            trap 'printf %s "$show"' EXIT
            printf %s "$hide"
            while printf "$eel$blue$bold[$reset%s$reset$blue$bold]$reset\b\b\b" "${spinner[s++ % ${#spinner[@]}]}" && sleep .1
            do :; done
        } & _logSpinner=$!
    fi 2>/dev/null

    return $exitcode
}
dbg() { level=DBG log "$@"; }
inf() { level=INF log "$@"; }
wrn() { level=WRN log "$@"; }
err() { level=ERR log "$@"; }
ftl() { level=FTL log "$@"; }
plog() { log -p "$@"; }
ulog() { log -u "$@"; }
golp() { log -P "$@"; }
pdbg() { level=DBG plog "$@"; }
pinf() { level=INF plog "$@"; }
pwrn() { level=WRN plog "$@"; }
perr() { level=ERR plog "$@"; }
pftl() { level=FTL plog "$@"; }
udbg() { level=DBG ulog "$@"; }
uinf() { level=INF ulog "$@"; }
uwrn() { level=WRN ulog "$@"; }
uerr() { level=ERR ulog "$@"; }
uftl() { level=FTL ulog "$@"; }
gbdp() { level=DBG golp "$@"; }
fnip() { level=INF golp "$@"; }
nrwp() { level=WRN golp "$@"; }
rrep() { level=ERR golp "$@"; }
ltfp() { level=FTL golp "$@"; }
_logColor=${_logColor:-$([[ -t 2 ]] && echo 1)} _logVerbosity=2
_logDbgColor=$blue _logInfColor=$white _logWrnColor=$yellow _logErrColor=$red _logFtlColor=$bold$red
# _______________________________________________________________________



#  ______________________________________________________________________
# |__ Emit ______________________________________________________________|
#
#       emit [options] message... [-- [command args...]]
#
# Display a message with contextual coloring.
#
# When a command is provided, a spinner will be activated in front of the
# message for as long as the command runs.  When the command ends, its
# exit status will result in a message 'done' or 'failed' to be displayed.
#
# It is possible to only specify -- as final argument.  This will prepare
# a spinner for you with the given message but leave it up to you to
# notify the spinner that it needs to stop.  See the documentation for
# 'spinner' to learn how to do this.
#
#   -n  Do not end the line with a newline.
#   -b  Activate bright (bold) mode.
#   -d  Activate half-bright (dim) mode.
#   -g  Display in green.
#   -y  Display in yellow.
#   -r  Display in red.
#   -w  Display in the default color.
#
#   -[code] A proxy-call to 'spinner -[code]'.
#
# Non-captialized versions of these options affect the * or the spinner
# in front of the message.  Capitalized options affect the message text
# displayed.
#
emit() {

    # Proxy call to spinner.
    [[ $# -eq 1 && $1 = -+([0-9]) ]] \
        && { spinner $1; return; }
 
    # Initialize the vars.
    local arg
    local style=
    local color=
    local textstyle=
    local textcolor=
    local noeol=0
    local cmd=0

    # Parse the options.
    spinArgs=()
    for arg in $(getArgs odbwgyrDBWGYRn "$@"); do
        case ${arg%% } in
            d) style=$dim           ;;
            b) style=$bold          ;;
            w) color=$white         ;;
            g) color=$green         ;;
            y) color=$yellow        ;;
            r) color=$red           ;;
            D) textstyle=$dim       ;;
            B) textstyle=$bold      ;;
            W) textcolor=$white     ;;
            G) textcolor=$green     ;;
            Y) textcolor=$yellow    ;;
            R) textcolor=$red       ;;
            n) noeol=1
               spinArgs+=(-n)       ;;
            o) spinArgs+=("-$arg")  ;;
        esac
    done
    shift $(getArgs -c odbwgyrDBWGYRn "$@")
    while [[ $1 = +* ]]; do
        spinArgs+=("-${1#+}")
        shift
    done

    # Defaults.
    color=${color:-$textcolor}
    color=${color:-$green}
    [[ $color = $textcolor && -z $style ]] && style=$bold

    # Get the text message.
    local text= origtext=
    for arg; do [[ $arg = -- ]] && break; origtext+="$arg "; done
    origtext=${origtext%% }
    (( noeol )) && text=$origtext || text=$origtext$reset$(eol "$origtext")$'\n'

    
    # Trim off everything up to --
    while [[ $# -gt 1 && $1 != -- ]]; do shift; done
    [[ $1 = -- ]] && { shift; cmd=1; }

    # Figure out what FD to use for our messages.
    [[ -t 1 ]]; local fd=$(( $? + 1 ))

    # Display the message or spinner.
    if (( cmd )); then
        # Don't let this Bash handle SIGINT.
        #trap : INT

        # Create the spinner in the background.
        spinPipe=${TMPDIR:-/tmp}/bashlib.$$
        { touch "$spinPipe" && rm -f "$spinPipe" && mkfifo "$spinPipe"; } 2>/dev/null \
            || unset spinPipe
        { spinner "${spinArgs[@]}" "$origtext" -- "$style" "$color" "$textstyle" "$textcolor" < "${spinPipe:-/dev/null}" & } 2>/dev/null
        [[ $spinPipe ]] && echo > "$spinPipe"
        spinPid=$!

        # Execute the command for the spinner if one is given.
        #fsleep 1 # Let the spinner initialize itself properly first. # Can probably remove this now that we echo > spinPipe?
        if   (( $# == 1 )); then command=$1
        elif (( $# >  1 )); then command=$(printf '%q ' "$@")
        else return 0; fi

        eval "$command" >/dev/null \
            && spinner -0 \
            || spinner -1
    else
        # Make reset codes restore the initial font.
        local font=$reset$textstyle$textcolor
        text=$font${text//$reset/$font}
        
        printf "\r$reset $style$color* %s$reset" "$text"            >&$fd
    fi
} # _____________________________________________________________________



#  ______________________________________________________________________
# |__ Spinner ___________________________________________________________|
#
#       spinner message... [-- style color textstyle textcolor]
#           or
#       spinner -[code]
#
# Displays a spinner on the screen that waits until a certain time.
# Best used through its interface provided by 'emit'.
#
#   style       A terminal control string that defines the style of the spinner.
#   color       A terminal control string that defines the color of the spinner.
#   textstyle   A terminal control string that defines the style of the message.
#   textcolor   A terminal control string that defines the color of the message.
#
#   -[code]     Shut down a previously activated spinner with the given exit
#               code.  If the exit code is 0, a green message 'done' will be
#               displayed.  Otherwise a red message 'failed' will appear.
#               The function will return with this exit code as result.
#
# You can manually specify a previously started spinner by putting its PID in
# the 'spinPid' variable.  If this variable is not defined, the PID of the most
# recently backgrounded process is used.  The 'spinPid' variable is unset upon
# each call to 'spinner' and reset to the PID of the spinner if one is created.
#
spinner() {

    # Check usage.
    (( ! $# )) || getArgs -q :h "$@" && {
        emit -y 'Please specify a message as argument or a status option.'
        return 1
    }

    # Initialize spinner vars.
    # Make sure monitor mode is off or we won't be able to trap INT properly.
    local monitor=0; [[ $- = *m* ]] && monitor=1
    local done=

    # Place the trap for interrupt signals.
    trap 'done="${red}failed"' USR2
    trap 'done="${green}done"' USR1

    # Initialize the vars.
    local pid=${spinPid:-$!}
    local graphics=( "${bobber[@]}" )
    local style=$bold
    local color=$green
    local textstyle=
    local textcolor=
    local output=
    local noeol=
    unset spinPid

    # Any remaining options are the exit status of an existing spinner or spinner type.
    while [[ $1 = -* ]]; do
        arg=${1#-}
        shift

        # Stop parsing when arg is --
        [[ $arg = - ]] && break

        # Process arg: Either a spinner type or result code.
        if [[ $arg = *[^0-9]* ]]; then
            case $arg in
                b) graphics=( "${bobber[@]}" )  ;;
                c) graphics=( "${crosser[@]}" ) ;;
                r) graphics=( "${runner[@]}" )  ;;
                s) graphics=( "${spinner[@]}" ) ;;
                o) output=1                     ;;
                n) noeol=1                      ;;
            esac
        elif [[ $pid ]]; then
            [[ $arg = 0 ]] \
                && kill -USR1 $pid 2>/dev/null \
                || kill -USR2 $pid 2>/dev/null
            
            trap - INT
            wait $pid 2>/dev/null

            return $arg
        fi
    done
 
    # Read arguments.
    local text= origtext=
    for arg; do [[ $arg = -- ]] && break; origtext+="$arg "; done
    origtext=${origtext% }
    local styles=$*; [[ $styles = *' -- '* ]] || styles=
    read -a styles <<< "${styles##* -- }"
    [[ ${styles[0]} ]] && style=${styles[0]}
    [[ ${styles[1]} ]] && color=${styles[1]}
    [[ ${styles[2]} ]] && textstyle=${styles[2]}
    [[ ${styles[3]} ]] && textcolor=${styles[3]}

    # Figure out what FD to use for our messages.
    [[ -t 1 ]]; local fd=$(( $? + 1 ))

    # Make reset codes restore the initial font.
    local font=$reset$textstyle$textcolor
    origtext=$font${origtext//$reset/$font}
    (( noeol )) && text=$origtext || text=$origtext$reset$(eol "$origtext")

    # Spinner initial status.
    printf "\r$save$eel$reset $style$color* %s$reset" "$text"       >&$fd
    (( output )) && printf "\n"                                     >&$fd

    # Render the spinner.
    set +m
    local i=0
    while [[ ! $done ]]; do
        IFS= read -r -d '' newtext || true
        newtext=${newtext%%$'\n'}; newtext=${newtext##*$'\n'}
        if [[ $newtext = +* ]]; then
            newtext="$origtext [${newtext#+}]"
        fi
        if [[ $newtext ]]; then
            newtext="$font${newtext//$reset/$font}"
            (( noeol )) && text=$newtext || text=$newtext$reset$(eol "$newtext")
        fi

        if (( output ))
        then printf "\r"                                            >&$fd
        else printf "$load$eel"                                     >&$fd
        fi

        if (( output ))
        then printf "$reset $style$color$blue%s %s$reset" \
                "${graphics[i++ % 4]}" "$text"                      >&$fd
        else printf "$reset $style$color%s %s$reset" \
                "${graphics[i++ % 4]}" "$text"                      >&$fd
        fi

        fsleep .25 # Four iterations make one second.

        # Cancel when calling script disappears.
        kill -0 $$ >/dev/null || done="${red}aborted"
    done

    # Get rid of the spinner traps.
    trap - USR1 USR2; (( monitor )) && set -m

    # Spinner final status.
    if (( output ))
    then text=; printf "\r"                                         >&$fd
    else printf "$load"                                             >&$fd
    fi

    printf "$eel$reset $style$color* %s${text:+ }$bold%s$font.$reset\n" \
            "$text" "$done"                                         >&$fd
} # _____________________________________________________________________



#  ______________________________________________________________________
# |__ report ___________________________________________________________|
#
#       report [-code] [-e] failure-message [success-message]
#
# This is a convenience function for replacement of spinner -code.
#
# It checks either the exit code of the previously completed command or
# the code provided as option to determine whether to display the success
# or failure message.  It calls spinner -code to complete an actively
# emitted message if there is one.  The success message is optional.
#
#   -[code] The exit code to use.
#   -e      Exit the script on failure.
#
report() {

    # Exit Status of previous command.
    local code=$?

    # Parse the options.
    while [[ $1 = -* && $2 ]]; do
        arg=${1#-}
        shift

        # Stop parsing when arg is --
        [[ $arg = - ]] && break

        # Process arg: Either a spinner type or result code.
        if [[ $arg = *[^0-9]* ]]; then
            case $arg in
            esac
        else code=$arg
        fi
    done

    # Initialize the vars.
    local failure=$1
    local success=$2

    # Check usage.
    (( ! $# )) || getArgs -q :h "$@" && {
        emit -y 'Please specify at least a failure message as argument.'
        return 1
    }

    # Proxy call to spinner.
    (( spinPid )) \
        && { spinner -$code; }
 
    # Success or failure message.
    if (( ! code ))
    then [[ $success ]] && emit     "  $success"
    else [[ $failure ]] && emit -R  "  $failure"
    fi

    # Pass on exit code.
    return $code
} # _____________________________________________________________________



#  ______________________________________________________________________
# |__ Ask _______________________________________________________________|
#
#       ask [-optionchars|+default] message...
#
# Ask a question and read the user's reply to it.
#
# By default, a reply is terminated by a newline.
#
# You may use the options to switch into key mode.  In key mode, only a
# single character is read.  The valid characters are specified in the
# optionchars.  A capital option character makes that option the default.
#
# If the reply character in key mode was not amoungst the provided options
# the default is assumed instead.  If no default was given, an exit code
# of 2 is returned.
#
# You may mark an optionchar as 'valid' by appending a '!' to it.  As a
# result, an exit code of 0 will only be returned if this valid option
# is replied.  If not, an exit code of 1 will be returned.
#
# If no option is marked as valid, the given reply is echoed and an exit
# code of 0 is returned.
#
# You can specify the -# option to make ask hide the user's input.
#
# If you prefix the first argument with a + instead of a -, the remaining
# argument is taken as the default string value and returned when no input
# was received.  In this case, the exit code is 0 either way.
#
ask() {
   
   # Check usage.
    (( ! $# )) || getArgs -q :h "$@" && {
        emit -y 'Please specify a question as argument.'
        return 1
    }
 
    # Initialize the vars.
    local arg
    local option=
    local options=
    local default=
    local silent=
    local valid=
    local muteChar=

    # Parse the options.
    if [[ $1 = +* ]]; then
        option=${1#+}
        default=$option

        shift
    else
        for arg in $(getArgs "$(printf "%s" {a..z} {A..Z})!#%" "$@"); do
            [[ $arg = [[:upper:]] ]] \
                && default=$arg
            [[ $arg = ! ]] \
                && { valid=${options: -1}; continue; }
            [[ $arg = '#' ]] \
                && { silent=1 arg=; }
            [[ $arg = '%' ]] \
                && { silent=1 muteChar='*' arg=; }

            options+=$arg
        done
    fi

    # Trim off the options.
    while [[ $1 = -* ]]; do shift; done

    # Figure out what FD to use for our messages.
    [[ -t 1 ]]; local fd=$(( $? + 1 ))

    # Ask the question.
    emit -yn "$*${option:+ [$option]}${options:+ [$options]} "

    # Read the reply.
    if [[ $muteChar ]]; then
        local reply
        while read -s -n1 && [[ $REPLY ]]; do
            reply+=$REPLY
            printf "%s" "$muteChar"                                 >&$fd
        done
        REPLY=$reply
    else
        read -e ${options:+-n1} ${silent:+-s}
    fi
    [[ $options && $REPLY ]] || (( silent )) && printf "\n"         >&$fd

    # Evaluate the reply.
    while true; do
        if [[ $REPLY && ( ! $options || $options = *$REPLY* ) ]]; then
            if [[ $valid ]]
            then [[ $REPLY = $valid ]]
            else printf "%s" "$REPLY"
            fi

            return
        fi

        [[ -z $default || $REPLY = $default ]] \
            && return 2
        
        REPLY=$default
    done
} # _____________________________________________________________________



#  ______________________________________________________________________
# |__ Trim ______________________________________________________________|
#
#       trim lines ...
#
# Trim the whitespace off of the beginning and end of the given lines.
# Each argument is considdered one line; is treated and printed out.
#
# When no arguments are given, lines will be read from standard input.
#
trim() {
   
    # Initialize the vars.
    local lines
    local line
    local oIFS

    # Get the lines.
    lines=( "$@" )
    if (( ! ${#lines[@]} )); then
        oIFS=$IFS; IFS=$'\n'
        lines=( $(cat) )
        IFS=$oIFS
    fi

    # Trim the lines
    for line in "${lines[@]}"; do
        line=${line##*([[:space:]])}; line=${line%%*([[:space:]])}
        printf "%s" "$line"
    done
} # _____________________________________________________________________



#  ______________________________________________________________________
# |__ Reverse ___________________________________________________________|
#
#       reverse [-0] [elements ...] [<<< elements]
#
# Reverse the order of the given elements.  Elements are read from command
# arguments or standard input if no element arguments are given.
# They are reversed and output on standard output.
#
# If the -0 option is given, input and output are delimited by NUL bytes.
# Otherwise, they are delimited by newlines.
#
reverse() {
   
    # Initialize the vars.
    local elements delimitor=$'\n'

    # Parse the options.
    while [[ $1 = -* ]]; do
        case $1 in
            -0) delimitor=$'\0' ;;
            --) shift; break ;;
        esac
        shift
    done

    # Get the elements.
    elements=( "$@" )
    if (( ! ${#elements[@]} )); then
        while IFS= read -r -d "$delimitor"; do
            elements+=("$REPLY")
        done
    fi

    # Iterate in reverse order.
    for (( i=${#elements[@]} - 1; i >=0; --i )); do
        printf '%s%s' "${elements[i]}" "$delimitor"
    done
} # _____________________________________________________________________



#  ______________________________________________________________________
# |__ Mutex _____________________________________________________________|
#
#       mutex file
#
# Open a mutual exclusion lock on the file, unless another process already owns one.
#
# If the file is already locked by another process, the operation fails.
# This function defines a lock on a file as having a file descriptor open to the file.
# This function uses FD 9 to open a lock on the file.  To release the lock, close FD 9:
# exec 9>&-
#
mutex() {
    local file=${1:-${BASH_SOURCE[-1]}} pid pids
    [[ -e $file ]] || err "No such file: $file" || return

    exec 9>>"$file"
    { pids=$(fuser -f "$file"); } 2>&- 9>&-
    for pid in $pids; do
        [[ $pid = $$ ]] && continue

        exec 9>&-
        return 1 # Locked by a pid.
    done
}



#  ______________________________________________________________________
# |__ FSleep _____________________________________________________________|
#
#       fsleep time
#
# Wait for the given amount of seconds.  The amount of seconds may be
# fractional.
#
# This implementation solves the problem portably, assuming that either
# bash 4.x or a fractional sleep(1) is available.
#
fsleep() {

    local fifo=${TMPDIR:-/tmp}/.fsleep.$$
    trap 'rm -f "$fifo"' RETURN
    mkfifo "$fifo" && { read -t "$1" <> "$fifo" 2>/dev/null || sleep "$1"; }
} # _____________________________________________________________________



#  ______________________________________________________________________
# |__ GetArgs ___________________________________________________________|
#
#       getArgs [options] optstring [args...]
#
# Retrieve all options present in the given arguments.
#
# This is a wrapper for getopts(P) which will safely work inside functions.
# It manages OPTIND for you and returns a list of options found in the
# provided arguments.
#
#   optstring   This is a string of characters in which each character
#               represents an option to look for in the arguments.
#               See getopts(P) for a description of the optstring syntax.
#
#   args        This is a list of arguments in which to look for options.
#               Most commonly, you will use "$@" to supply these arguments.
#
#   -c  Instead of output the arguments, output OPTARGS.
#   -q  Be quiet.  No arguments are displayed.  Only the exit code is set.
#   -n  Use newlines as a separator between the options that were found.
#   -0  Use NULL-bytes as a separator between the options that were found.
#
# If any given arguments are found, an exit code of 0 is returned.  If none
# are found, an exit code of 1 is returned.
#
# After the operation, OPTARGS is set the the index of the last argument
# that has been parsed by getArgs.  Ready for you to use shift $OPTARGS.
#
getArgs() {

    # Check usage.
    (( ! $# )) && {
        emit -y 'Please provide the arguments to search for in' \
                'getopts(P) format followed by the positional parameters.'
        return 1
    }

    # Initialize the defaults.
    local arg
    local found=0
    local quiet=0
    local count=0
    local delimitor=' '

    # Parse the options.
    while [[ $1 = -* ]]; do
        case $1 in
            -q) quiet=1         ;;
            -c) count=1         ;;
            -n) delimitor=$'\n' ;;
            -0) delimitor=$'\0' ;;
        esac
        shift
    done

    # Get the optstring.
    local optstring=$1; shift
    local oOPTIND=$OPTIND OPTIND=1

    # Enumerate the arguments.
    while getopts "$optstring" arg; do
        [[ $arg != '?' ]] && found=1

        (( quiet + count )) || \
            printf "%s${OPTARG:+ }%s%s" "$arg" "$OPTARG" "$delimitor"
    done
    OPTARGS=$(( OPTIND - 1 ))
    OPTIND=$oOPTIND

    # Any arguments found?
    (( count )) && printf "%s" "$OPTARGS"
    return $(( ! found ))
} # _____________________________________________________________________



# |__ ShowHelp __________________________________________________________|
#
#       showHelp name description author [option description]...
#
# Generate a prettily formatted usage description of the application.
#
#   name        Provide the name of the application.
#
#   description Provide a detailed description of the application's
#               purpose and usage.
#
#   option      An option the application can take as argument.
#
#   description A description of the effect of the preceding option.
#
showHelp() {

    # Check usage.
    (( $# < 3 )) || getArgs -q :h "$@" && {
        emit -y 'Please provide the name, description, author and options' \
                'of the application.'
        return 1
    }

    # Parse the options.
    local appName=$1; shift
    local appDesc=${1//+([[:space:]])/ }; shift
    local appAuthor=$1; shift
    local cols=$(tput cols)
    (( cols = ${cols:-80} - 10 ))

    # Figure out what FD to use for our messages.
    [[ -t 1 ]]; local fd=$(( $? + 1 ))

    # Print out the help header.
    printf "$reset$bold\n"                                          >&$fd
    printf "\t\t%s\n" "$appName"                                    >&$fd
    printf "$reset\n"                                               >&$fd
    printf "%s\n" "$appDesc" | fmt -w "$cols" | sed $'s/^/\t/'      >&$fd
    printf "\t   $reset$bold~ $reset$bold%s\n" "$appAuthor"         >&$fd
    printf "$reset\n"                                               >&$fd

    # Print out the application options and columnize them.
    while (( $# )); do
        local optName=$1; shift
        local optDesc=$1; shift
        printf "    %s\t" "$optName"
        printf "%s\n" "${optDesc//+( )/ }" | fmt -w "$cols" | sed $'1!s/^/ \t/'
        printf "\n"
    done | column -t -s $'\t' \
         | sed "s/^\(    [^ ]*\)/$bold$green\1$reset/"              >&$fd
    printf "\n"                                                     >&$fd
} # _____________________________________________________________________



#  ______________________________________________________________________
# |__ Quote _____________________________________________________________|
#
#       quote [-e] [argument...]
#
# Output a single string where all arguments are quoted
# such that the string is safe to be passed as shell
# command arguments as though given arguments had been
# passed.
#
# When no arguments are passed; no output is generated.
#
#   -e      Use backslashes rather than single quotes.
#
quote() {

    # Initialize the defaults.
    local arg escape=0 q="'\\''" quotedArgs=()

    # Parse the options.
    while [[ $1 = -* ]]; do
        case $1 in
            -e) escape=1    ;;
            --) shift; break ;;
        esac
        shift
    done

    # Print out each argument, quoting it properly.
    for arg; do
        if (( escape )); then
            quotedArgs+=("$(printf "%q"     "$arg")")
        else
            quotedArgs+=("$(printf "'%s'"   "${arg//"'"/$q}")")
        fi
    done

    printf '%s\n' "$(IFS=' '; echo "${quotedArgs[*]}")"
} # _____________________________________________________________________



#  ______________________________________________________________________
# |__ ReQuote __________________________________________________________|
#
#       requote [string]
#
# Output a single string where the first argument is escaped
# for safe usage as a literal in a regular expression.
#
requote() {

    # Initialize the defaults.
    local char

    printf '%s' "$1" | while IFS= read -r -d '' -n1 char; do
        printf '[%s]' "$char"
    done
} # _____________________________________________________________________



#  ______________________________________________________________________
# |__ Shorten ___________________________________________________________|
#
#       shorten [-p pwd] path [suffix]...
#
# Shorten an absolute path for pretty printing by cutting
# off PWD and replacing HOME by ~.
#
#   -p      Use the given pathname as the base for relative filenames instead of PWD.
#   path    The path string to shorten.
#   suffix  Suffix strings that must be cut off from the end.
#           Only the first suffix string matched will be cut off.
#
shorten() {

    # Check usage.
    (( $# < 1 )) || getArgs -q :h "$@" && {
        emit -y 'Please provide the path to shorten.'
        return 1
    }

    # Parse the options.
    local suffix path pwd=$PWD
    [[ $1 = -p ]] && { pwd=$2; shift 2; }
    path=$1; shift

    # Make path absolute.
    [[ $path = /* ]] || path=$PWD/$path

    # If the path denotes something that exists; it's easy.
    if [[ -d $path ]]
    then path=$(cd "$path"; printf "%s" "$PWD")
    elif [[ -d ${path%/*} ]]
    then path=$(cd "${path%/*}"; printf "%s" "$PWD/${path##*/}")

    # If not, we'll try readlink -m.
    elif readlink -m / >/dev/null 2>&1; then
        path=$(readlink -m "$path")

    # If we don't have that - unleash the sed(1) madness.
    else
        local oldpath=/
        while [[ $oldpath != $path ]]; do
            oldpath=$path
            path=$(sed -e 's,///*,/,g' -e 's,\(^\|/\)\./,\1,g' -e 's,\(^\|/\)[^/]*/\.\.\($\|/\),\1,g' <<< "$path")
        done
    fi

    # Replace special paths.
    path=${path#$pwd/}
    path=${path/#$HOME/'~'}

    # Cut off suffix.
    for suffix; do
        [[ $path = *$suffix ]] && {
            path=${path%$suffix}
            break
        }
    done

    printf "%s" "$path"
} # _____________________________________________________________________



#  ______________________________________________________________________
# |__ InArray ___________________________________________________________|
#
#       inArray element array
#
# Checks whether a certain element is in the given array.
#
#   element The element to search the array for.
#   array   This is a list of elements to search through.
#
inArray() {

    # Check usage.
    (( $# < 1 )) || getArgs -q :h "$@" && {
        emit -y 'Please provide the element to search for and the array' \
                'to search through.'
        return 1
    }

    # Parse the options.
    local element
    local search=$1; shift

    # Perform the search.
    for element
    do [[ $element = $search ]] && return 0; done
    return 1
} # _____________________________________________________________________



#  ______________________________________________________________________
# |__ xpathNodes ________________________________________________________|
#
#       xpathNodes query [files...]
#
# Outputs every xpath node that matches the query on a separate line.
# Leading and trailing whitespace is always stripped.
#
#   file        The path to the file that contains the document to run the query on.
#   query       The XPath query to run on the document.
#
xpathNodes() {
    local query=$1; shift
    [[ $1 ]] || set -- <(cat)

    for file; do
        {
            if xpath -e / <(echo '<a></a>') >/dev/null 2>&1; then
                xpath -e "$query" "$file" 2>&1
            else
                xpath "$file" "$query" 2>&1
            fi
        } | {
            read
            sed -ne $'s/-- NODE --/\\\n/g' -e 's/^[[:space:]]*\(.*[^[:space:]]\)[[:space:]]*$/\1/p'
        }
    done

    return "${PIPESTATUS[0]}"
}



#  ______________________________________________________________________
# |__ HideDebug _________________________________________________________|
#
#       hideDebug [ on | off ]
#
# Toggle Bash's debugging mode off temporarily.  To hide Bash's debugging
# output for a function, you should have a hideDebug on as its first line
# and hideDebug off as its last.
#
hideDebug() {

    if [[ $1 = on ]]; then
        : -- HIDING DEBUG OUTPUT ..
        [[ $- != *x* ]]; bashlib_debugWasOn=$?
        set +x
    elif [[ $1 = off ]]; then
        : -- SHOWING DEBUG OUTPUT ..
        (( bashlib_debugWasOn )) && \
        set -x
    fi
}

#  ______________________________________________________________________
# |__ StackTrace ________________________________________________________|
#
#       stackTrace
#
# Retrieve a mapping of a key from the given map or modify the given map by
# assigning a new value for the given key if stdin is not the terminal.
#
stackTrace() {

    # Some general debug information.
    printf "\t$bold%s$reset v$bold%s$reset" "$BASH" "$BASH_VERSION\n"
    printf "    Was running: $bold%s %s$reset" "$BASH_COMMAND" "$*\n"
    printf "\n"
    printf "    [Shell    : $bold%15s$reset]    [Subshells : $bold%5s$reset]\n" "$SHLVL" "$BASH_SUBSHELL"
    printf "    [Locale   : $bold%15s$reset]    [Runtime   : $bold%5s$reset]\n" "$LC_ALL" "${SECONDS}s"
    printf "\n"

    # Search through the map.
    local arg=0
    for i in ${!FUNCNAME[@]}; do
        #if (( i )); then

            # Print this execution stack's location.
            printf "$reset  $bold-$reset $green"
            [[ ${BASH_SOURCE[i+1]} ]] \
                && printf "%s$reset:$green$bold%s" "${BASH_SOURCE[i+1]}" "${BASH_LINENO[i]}" \
                || printf "${bold}Prompt"

            # Print this execution stack's function and positional parameters.
            printf "$reset :\t$bold%s(" "${FUNCNAME[i]}"
            [[ ${BASH_ARGC[i]} ]] && \
                for (( j = 0; j < ${BASH_ARGC[i]}; j++ )); do
                    (( j )) && printf ', '
                    printf "%s" "${BASH_ARGV[arg]}"
                    let arg++
                done

            # Print the end of this execution stack's line.
            printf ")$reset\n"
        #fi
    done
    printf "\n"

} # _____________________________________________________________________





#  ______________________________________________________________________ 
# |                                                                      |
# |                                                  .:: ENTRY POINT ::. |
# |______________________________________________________________________|

# Make sure this file is sourced and not executed.
(( ! BASH_LINENO )) && {
    emit -R "You should source this file, not execute it."
    exit 1
}

:
:                                                   .:: END SOURCING ::.  
:  ______________________________________________________________________ 
:
