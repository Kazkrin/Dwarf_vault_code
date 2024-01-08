#!/bin/bash

service='logstore.service'
status="$(systemctl is-active $service)"

check(){
if [ $status = "inactive" ]
then
    check_result=$(curl --location --globoff --request POST 'http://nagios.dev.sit-automation.dsv.com/nrdp/?token=m0Bjbr9FL5gq&cmd=submitcheck&json={%0A%20%20%20%20%22checkresults%22%3A%20[%0A%20%20%20%20%20%20%20%20{%0A%20%20%20%20%20%20%20%20%20%20%20%20%22checkresult%22%3A%20{%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%22type%22%3A%20%22service%22%0A%20%20%20%20%20%20%20%20%20%20%20%20}%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%22hostname%22%3A%20%22logstash%22%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%22servicename%22%3A%20%22logstash%22%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%22state%22%3A%20%222%22%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%22output%22%3A%20%22Critical%3A%20logstore.service%20is%20not%20running%22%0A%20%20%20%20%20%20%20%20}%0A%20%20%20%20]%0A}')
    echo "Service $service is not running"
else
    check_result=$(curl --location --globoff --request POST 'http://nagios.dev.sit-automation.dsv.com/nrdp/?token=m0Bjbr9FL5gq&cmd=submitcheck&json={%0A%20%20%20%20%22checkresults%22%3A%20[%0A%20%20%20%20%20%20%20%20{%0A%20%20%20%20%20%20%20%20%20%20%20%20%22checkresult%22%3A%20{%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%22type%22%3A%20%22service%22%0A%20%20%20%20%20%20%20%20%20%20%20%20}%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%22hostname%22%3A%20%22logstash%22%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%22servicename%22%3A%20%22logstash%22%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%22state%22%3A%20%220%22%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%22output%22%3A%20%22All%20is%20OK%22%0A%20%20%20%20%20%20%20%20}%0A%20%20%20%20]%0A}')
    echo "Service $service is running"
fi;
}
check
