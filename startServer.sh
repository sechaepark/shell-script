#!/bin/bash

export APP_NAME=hello
export APP_HOME=.
export APP_ENV=development

export LOG_PATH=$APP_HOME/logs
export LOG_FILE=$LOG_PATH/$APP_NAME.$(date '+%Y%m%d').log

export PID_FILE=$APP_HOME/$APP_NAME.pid

mkdir -p $LOG_PATH

if [ -f $PID_FILE ]; then
    PID=`cat $PID_FILE`
fi

start_server() {
    if [ -f $PID_FILE ]; then
        echo "already started process id[$PID]"
        echo "$(date) : already started process id[$PID]" >> $LOG_FILE
    else
        # start command ----------------------------------------------------
        nohup sleep 60 1>/dev/null 2>&1 &
        # ------------------------------------------------------------------
        PID=`echo $!`
        echo $PID > $PID_FILE
        echo "started proccess id[$PID]"
        echo "$(date) : started proccess id[$PID]" >> $LOG_FILE
    fi
}

stop_server() {
    if [ -f $PID_FILE ]; then
        # stop command ----------------------------------------------------
        kill -9 $PID
        rm -f $PID_FILE
        # ------------------------------------------------------------------
        echo "stopped proccess id[$PID]"
        echo "$(date) : stopped proccess id[$PID]" >> $LOG_FILE
    else
        echo "not found pid File[$PID_FILE]"
        echo "$(date) : not found pid file[$PID_FILE]" >> $LOG_FILE
    fi
}

restart_server() {
    if [ -f $PID_FILE ]; then
        stop_server
        sleep 1;
        start_server
    else
        start_server
    fi
}

case "$1" in
    start)
        start_server
        ;;
    stop)
        stop_server
        ;;
    restart)
        restart_server
        ;;
    *)
        echo "Usage: $0 start|stop|restart" >&2
        exit 1
        ;;
esac

exit 0
