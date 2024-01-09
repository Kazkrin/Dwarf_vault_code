#!/bin/bash

SERVICE="logstash.service"
STATUS="$(systemctl is-active $SERVICE)"


CHECK(){
if [ $STATUS = "inactive" ] 
then
    CHECK_RESULT=$(curl --location --globoff --request POST '')
    echo "Service $SERVICE is not running"
else
    CHECK_RESULT=$(curl --location --globoff --request POST '')
    echo "Service $SERVICE is running" 
fi;
}
CHECK
