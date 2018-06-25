#!/bin/bash

_DEBUG=0
_SCRIPT="$0"
_DIRNAME="`dirname $0`"
_BASENAME="`basename $0`"
_BASENAME="${_BASENAME%%.sh}"
_PIDFILE="${_DIRNAME}/${_BASENAME}.pid"
_ERRFILE="${_DIRNAME}/${_BASENAME}.err"
_DATE="`/bin/date`"
_SVRPID=""
_SVRHOST=""
SG_HOME=/Users/woo
SG_BIN=$SG_HOME/bin
SG_TOOLS=$SG_HOME/Tools

pidexist() {
    _PID=${1-0}
    _RC=1

    _SVRPID=""
    _SVRHOST=""

    if [ $_PID -ne 0 ]; then
      /bin/ps -p $1 -o pid,tid,cmd > /dev/null 2>&1
      _RC=$?
    elif [ -e "$_PIDFILE" ]; then
      _SVRPID=`cat "$_PIDFILE" | awk '{print $1}'`
      _SVRHOST=`cat "$_PIDFILE" | awk '{print $2}'`
      /bin/ps -p "$_SVRPID" -o pid,tid,cmd > /dev/null 2>&1
      _RC=$?
    fi

    return $_RC
}

usage() {
  echo "Usage: $_BASENAME [options] {commands}"
  echo ""  
  echo "  Where"  
  echo "    options: (local when script run by non simgod user)"  
  echo "      -b addr     : jboss server bind address, default \"0.0.0.0\""
  if [ "$_IAM" != "simgod" ]; then
    echo "      -h hostname : target hostname to remote execute, default \"localhost\""
    echo "      -u user     : remote execute user, default \"simgod\""
    echo "      -c command  : remote execute command, default \"$_SCRIPT\""
    echo "      -p port     : remote ssh port, default 22"
  fi
  echo "      -?          : this help"
  echo "    commands:"
  echo "      status      : print status of jboss server, default command"
  echo "      start|1     : start jboss server in ~user/Tools/jboss-server"
  echo "      stop|0      : stop jboss server started by this script"
  echo "      logs        : list the log files of the running jboss server"
  echo "      tail        : tail -f server log"
  echo "      switch      : switch jboss-server link between jboss and jbpm"
  echo ""
}

_SSH="/usr/bin/ssh"
_HOST="`/bin/hostname -s`"
_REMHOST="localhost"
_USER="woo"
_CMD="$0"
_POPT=""
_MAXOPT=0
_IAM="$(whoami)"
_BIND="0.0.0.0"

if [ "$_IAM" != "woo" ]; then _GETOPT="b:h:l:c:p:d?"; else _GETOPT="b:d?"; fi

if [ $# -ne 0 ]; then
  while getopts $_GETOPT flag; do
    case "$flag" in
      b) _BIND="$OPTARG" ;;
      h) _REMHOST="$OPTARG" ;;
      l) _USER="$OPTARG" ;;
      c) _CMD="$OPTARG" ;;
      p) _POPT="-p $OPTARG" ;;
      d) _DEBUG=1 ;;
      ?) usage; exit 0 ;;
    esac
    if [ $OPTIND -gt $_MAXOPT ]; then _MAXOPT=$OPTIND; fi
  done

  if [ $_MAXOPT -gt 0 ]; then shift $(expr $_MAXOPT - 1); fi
fi

if [ $# -eq 0 ]; then
  _ACTION="status"
elif [ $# -eq 1 ]; then
  _ACTION="$1"
else
  usage
  exit 1
fi

ipaddr() {
     if [ -n "$_BIND" ]; then
          echo $_BIND
          return 0
     fi

     _itf=`ifconfig | grep -m 1 eth | awk '{print $1}'`
     if [ "$_itf" == "" ]; then
          echo "0.0.0.0"
          return 0
     fi

     ifconfig $_itf | grep inet | awk '{print $2}' | sed 's/addr://' | grep .
}

# Simgod's execution path
#
CDPATH=.:$HOME:$SG_HOME:$SG_TOOLS
ANT_HOME=$SG_TOOLS/apache-ant-1.7.0
#JAVA_HOME=$SG_TOOLS/JavaEE5/jdk
JAVA_HOME=$SG_TOOLS/jdk1.5.0_16
JBOSS_HOME=$SG_TOOLS/jboss-server
SERVER_TYPE=`ls -l $JBOSS_HOME | awk '{print $11}'`
if [ "$SERVER_TYPE" == "jboss-server-4.2.2.GA" ]; then
  OTHER_SERVER="jbpm-server-3.2.2"
else
  OTHER_SERVER="jboss-server-4.2.2.GA"
fi

if [ -e "$JBOSS_HOME/jbpm-jpdl.jar" ]; then
  JBOSS_HOME="$JBOSS_HOME/server"
  JBOSS_CFG="jbpm"
else
  JBOSS_CFG="default"
fi

JBH=$JBOSS_HOME
JBB=$JBOSS_HOME/bin
JBS=$JBOSS_HOME/server
JBC=$JBOSS_HOME/server/$JBOSS_CFG
JBOSS_SVR=$JBOSS_HOME/server/$JBOSS_CFG
PATH=$HOME/bin:$JAVA_HOME/bin:$ANT_HOME/bin:/usr/sbin:/sbin:$PATH
export SG_HOME SG_TOOLS CDPATH ANT_HOME JAVA_HOME JBOSS_HOME JBOSS_CFG JBOSS_SVR JBH JBB JBS JBC PATH SERVER_TYPE OTHER_SERVER


if [ "$_IAM" != 'simgod' -o "$_REMHOST" != "localhost" ]; then
  ##  We need to remote in as simgod to run the script.
  ##
  case "$_ACTION" in
    1|"start")
         if [ "$_REMHOST" == "localhost" ]; then
           pidexist
           _RC=$?
           if [ $_RC -eq 0 ]; then
             echo "$_DATE INFO:  $SERVER_TYPE server on $_SVRHOST[$_SVRPID] is already running!"
             exit 0
           fi
         fi
         $_SSH $_REMHOST -l $_USER "$_CMD -b $_BIND $_ACTION" $_POPT 
         _RC=$?
         exit $_RC
         ;;
    0|"stop")
         if [ "$_REMHOST" == "localhost" ]; then
           pidexist
           _RC=$?
           if [ $_RC -ne 0 ]; then
             echo "$_DATE INFO:  $SERVER_TYPE server is not running."
             exit 0
           fi
         fi
         $_SSH $_REMHOST -l $_USER "$_CMD $_ACTION" $_POPT
         _RC=$?
         exit $_RC
         ;;
    "status")
         if [ "$_REMHOST" != "localhost" ]; then
           $_SSH $_REMHOST -l $_USER "$_CMD $_ACTION" $_POPT
           _RC=$?
         else
           pidexist
           _RC=$?
           if [ $_RC -eq 0 ]; then
             echo "$_DATE INFO:  $SERVER_TYPE server on $_SVRHOST[$_SVRPID] is running."
           else
             echo "$_DATE INFO:  $SERVER_TYPE server is not running."
           fi
           _RC=0
         fi
         exit $_RC
         ;;
    "logs")
         if [ "$_REMHOST" != "localhost" ]; then
           $_SSH $_REMHOST -l $_USER "$_CMD $_ACTION" $_POPT
           _RC=$?
         else
           pidexist
           _RC=$?
           if [ $_RC -ne 0 ]; then echo "$_DATE INFO:  $SERVER_TYPE server is not currently running."; fi
           ls -alF $JBOSS_SVR/log
           _RC=$?
         fi
         exit $_RC
         ;;
    "tail")
         if [ "$_REMHOST" != "localhost" ]; then
           $_SSH $_REMHOST -l $_USER "$_CMD $_ACTION" $_POPT
           _RC=$?
         else
           pidexist
           _RC=$?
           if [ $_RC -ne 0 ]; then echo "$_DATE INFO:  $SERVER_TYPE server is not currently running."; fi
           if [ -e $JBOSS_SVR/log/server.log ]; then
             tail -f $JBOSS_SVR/log/server.log
             _RC=$?
           else
             echo "$_DATE ERROR:  $SERVER_TYPE server server.log is missing."
             _RC=1
           fi
         fi
         exit $_RC
         ;;
    "switch")
         if [ "$_REMHOST" == "localhost" ]; then
           pidexist
           _RC=$?
           if [ $_RC -eq 0 ]; then
             echo "$_DATE ERROR:  $SERVER_TYPE server on $_SVRHOST[$_SVRPID] is running, shutdown first!"
             exit 1
           fi
         fi
         $_SSH $_REMHOST -l $_USER "$_CMD $_ACTION" $_POPT
         _RC=$?
         exit $_RC
         ;;
    *)
         echo "$_DATE ERROR:  Invalid command parameter \"$_ACTION\"" 
         exit 1
         ;;
  esac

  exit 0
fi


pidexist
_RC=$?

case "$_ACTION" in
  1|"start")
    if [ $_RC -eq 0 ]; then
      echo "$_DATE INFO:  $SERVER_TYPE on $_SVRHOST[$_SVRPID] server is already running."
      exit 0
    fi
    /bin/rm -f "$JBOSS_SVR/log/*.log*"
    /bin/rm -f "$_PIDFILE"
    cd $JBOSS_HOME/bin
    nohup ./run.sh -c $JBOSS_CFG -b `ipaddr` > /dev/null 2>&1 &
    _JPID=${!}
    sleep 2
    /bin/ps -o pid,cmd -C java | grep run.sh | grep "$JBOSS_CFG" | awk '{print $1}' > /tmp/.pidfile 2> $_ERRFILE
    _RC=$?
    if [ $_RC -eq 0 ]; then
      _SVRPID=`cat /tmp/.pidfile | awk '{print $1}'`
      echo "$_SVRPID $_HOST" > $_PIDFILE
      echo "$_DATE INFO:  Started $SERVER_TYPE server on $_HOST[$_SVRPID]."
      /bin/rm -f "$_ERRFILE"
      exit 0
    else
      echo "$_DATE ERROR:  Problem starting $SERVER_TYPE server on $_HOST; check error file \"$_ERRFILE\"."
      exit 1
    fi
    ;;
  0|"stop")
    if [ $_RC -ne 0 ]; then
      echo "$_DATE INFO:  JBoss $SERVER_TYPE server on $_HOST is not currently running."
      exit 0
    fi
    cd $JBOSS_HOME/bin
    /usr/bin/kill -s 15 "$_SVRPID" > $_ERRFILE 2>&1
    _RC=$?
    if [ $_RC -eq 0 ]; then
      echo "$_DATE INFO:  Stopped $SERVER_TYPE server on $_HOST[$_SVRPID]."
      /bin/rm -f "$_ERRFILE"
      sleep 1
      exit 0
    else
      echo "$_DATE ERROR:  Problem stopping $SERVER_TYPE server on $_HOST[$_SVRPID]; check error file \"$_ERRFILE\"!"
      exit 1
    fi
    ;;
  "status")
    if [ $_RC -eq 0 ]; then
      echo "$_DATE INFO:  $SERVER_TYPE server on $_HOST[$_SVRPID] is running."
    else
      echo "$_DATE INFO:  $SERVER_TYPE server on $_HOST is not running."
    fi
    exit 0
    ;;
  "logs")
    if [ $_RC -ne 0 ]; then
      echo "$_DATE INFO:  $SERVER_TYPE server on $_HOST is not currently running."
    fi
    ls -alF $JBOSS_SVR/log
    _RC=$?
    exit $_RC
    ;;
  "tail")
    if [ $_RC -ne 0 ]; then
      echo "$_DATE INFO:  $SERVER_TYPE server on $_HOST is not currently running."
    fi
    if [ -e $JBOSS_SVR/log/server.log ]; then
      tail -f $JBOSS_SVR/log/server.log
      _RC=$?
    else
      echo "$_DATE ERROR:  $SERVER_TYPE server's server.log is missing on $_HOST."
      _RC=1
    fi 
    exit $_RC
    ;;
  "switch")
    if [ $_RC -eq 0 ]; then
      echo "$_DATE ERROR:  $SERVER_TYPE server on $_HOST[$_SVRPID] is running; must shutdown first!"
      exit 1
    fi
    cd $SG_TOOLS
    if [ -e $OTHER_SERVER ]; then
      rm -f jboss-server
      umask 0
      ln -sf $OTHER_SERVER jboss-server
      _RC=$?
      echo "$_DATE INFO:  Switched $SERVER_TYPE to $OTHER_SERVER on $_HOST."
      exit $_RC
    else
      echo "$_DATE ERROR:  Switch $SERVER_TYPE to $OTHER_SERVER failed, problem with the target on $_HOST."
      exit 1
    fi
    ;;
  "-?")
    usage
    exit 0
    ;;
  *)
    echo "$_DATE ERROR:  Invalid command parameter \"$_ACTION\"."
    exit 1;
    ;;
esac

exit 0
