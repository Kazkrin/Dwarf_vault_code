#!/bin/bash

service='logstore.service'
status="$(systemctl is-active $service)"

check(){
if [ $status = "inactive" ]
then
    check_result=$(curl --location --globoff --request POST '')
    echo "Service $service is not running"
else
    check_result=$(curl --location --globoff --request POST '')
    echo "Service $service is running"
fi;
}
check
