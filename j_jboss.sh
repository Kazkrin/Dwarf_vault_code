#!/bin/bash

alias=$1

declare -A array_host
declare -A array_user

array_host[dcsprd]=""
array_host[dcsprdb]=""
array_host[dcsprdc]=""
array_host[dcsprdd]=""
array_host[dcsprde]=""
array_host[dcsprdf]=""

array_user[dcsprd]=""
array_user[dcsprdb]=""
array_user[dcsprdc]=""
array_user[dcsprdd]=""
array_user[dcsprde]=""
array_user[dcsprdf]=""

command=""
host=${array_host[$1]}
user=${array_user[$1]}


check() {
result=$(ssh -i /home/nagios/ssh_priv_key -l $user $host "cd /")
status=$?

if [ $status -eq 0 ]
then
        echo "$result"     
else
        echo "$result"       
fi;
}

check
exit $status
