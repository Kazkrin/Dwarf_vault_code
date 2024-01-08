#!/bin/bash

SERVICE="logstash.service"
STATUS="$(systemctl is-active $SERVICE)"


CHECK(){
if [ $STATUS = "inactive" ] 
then
    CHECK_RESULT=$(curl --location --globoff --request POST 'http://nagios.dev.sit-automation.dsv.com:1337/nrdp/?token=m0Bjbr9FL5gq&cmd=submitcheck&json={%0A%20%20%20%20%22checkresults%22%3A%20[%0A%20%20%20%20%20%20%20%20{%0A%20%20%20%20%20%20%20%20%20%20%20%20%22checkresult%22%3A%20{%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%22type%22%3A%20%22service%22%0A%20%20%20%20%20%20%20%20%20%20%20%20}%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%22hostname%22%3A%20%22logstash%22%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%22servicename%22%3A%20%22logstash%22%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%22state%22%3A%20%222%22%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%22output%22%3A%20%22Critical%3A%20Found%20unprocessed%20transactions%22%0A%20%20%20%20%20%20%20%20}%0A%20%20%20%20]%0A}')
    echo "Service $SERVICE is not running"
else
    CHECK_RESULT=$(curl --location --globoff --request POST 'http://nagios.dev.sit-automation.dsv.com:1337/nrdp/?token=m0Bjbr9FL5gq&cmd=submitcheck&json={%0A%20%20%20%20%22checkresults%22%3A%20[%0A%20%20%20%20%20%20%20%20{%0A%20%20%20%20%20%20%20%20%20%20%20%20%22checkresult%22%3A%20{%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%22type%22%3A%20%22service%22%0A%20%20%20%20%20%20%20%20%20%20%20%20}%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%22hostname%22%3A%20%22logstash%22%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%22servicename%22%3A%20%22logstash%22%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%22state%22%3A%20%220%22%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%22output%22%3A%20%22200%3A%20All%20is%20OK%22%0A%20%20%20%20%20%20%20%20}%0A%20%20%20%20]%0A}')
    echo "Service $SERVICE is running" 
fi;
}
CHECK
