#!/bin/bash
# chkconfig: - 84 16
# description: JAR service script.
# Source function library.

SERVICE_NAME=<%= @name %>
PATH_TO_JAR=<%= @deploy_directory %>/$SERVICE_NAME.jar
PID_PATH_NAME=/tmp/$SERVICE_NAME
LOG=<%= @log_directory %>/$SERVICE_NAME.log

case $1 in
    start)
        echo "Starting $SERVICE_NAME ..."
        if [ ! -f $PID_PATH_NAME ]; then
            su $SERVICE_USER -c "nohup java -jar $PATH_TO_JAR \"$PATH_TO_JAR\"  >> \"$LOG\" 2>&1 &"
            ps aux | grep $SERVICE_NAME.jar | head -n 1 | awk '{print $2}' > $PID_PATH_NAME
            echo "$SERVICE_NAME started ..."
        else
            echo "$SERVICE_NAME is already running ..."
        fi
    ;;
    stop)
        if [ -f $PID_PATH_NAME ]; then
            PID=$(cat $PID_PATH_NAME);
            echo "$SERVICE_NAME stoping ..."
            kill -9 $PID 2>&1;
            echo "$SERVICE_NAME stopped ..."
            rm $PID_PATH_NAME
        else
            echo "$SERVICE_NAME is not running ..."
        fi
    ;;
    status)
        if [ -f $PID_PATH_NAME ]; then
            echo "$SERVICE_NAME is running ..."
            echo 1
        else
            echo "$SERVICE_NAME is not running ..."
            exit 0
        fi
    ;;
    restart)
        if [ -f $PID_PATH_NAME ]; then
            PID=$(cat $PID_PATH_NAME);
            echo "$SERVICE_NAME stopping ...";
            kill $PID;
            echo "$SERVICE_NAME stopped ...";
            rm $PID_PATH_NAME
            echo "$SERVICE_NAME starting ..."
            nohup java -jar $PATH_TO_JAR /tmp 2>> /dev/null >> /dev/null &
            ps aux | grep $SERVICE_NAME.jar | head -n 1 | awk '{print $2}' > $PID_PATH_NAME  
            echo "$SERVICE_NAME started ..."
        else
            echo "$SERVICE_NAME is not running ..."
        fi
    ;;
esac 