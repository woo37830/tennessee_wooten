#!/bin/bash
VERSION=1.1.2
SCRIPTNAME=$(basename "$0")
MONGOHOME=/usr/local
MONGOBIN=$MONGOHOME/bin
MONGOD=$MONGOBIN/mongod
MONGODBPATH=
MONGODBCONFIG=/usr/local/etc/mongod.conf


if [ $# != 1 ]
then
    echo "Usage: $SCRIPTNAME [start|stop|restart]"
    exit
fi

pid() {
    pgrep mongod
}

stopServer() {
    PID=$(pid)
    if [ ! -z "$PID" ]; 
    then
        echo "... stopping mongodb-server with pid: $PID"
     kill -2 $PID
    else
        echo "... mongodb-server is not running!"
    fi
}

startServer() {
    PID=$(pid)
    if [ ! -z "$PID" ];
    then
        echo "... mongodb-server already running with pid: $PID"
    else
        /usr/local/bin/mongod --config /usr/local/etc/mongod.conf &
        sleep 1s
        echo "...mondodb-server started with pid: $(pid)"
    fi
}

restartServer() {
    stopServer
    sleep 1s
    startServer    
}

case "$1" in

    start) startServer
           ;;

    stop) stopServer
          ;;

    restart) restartServer
         ;;

    *) echo "unknown command"
       exit
       ;;
esac

