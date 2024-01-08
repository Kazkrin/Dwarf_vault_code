#!/bin/bash

alias=$1

declare -A array_host
declare -A array_user

array_host[dcsprd]="dcsprdapp.cargowrite.dsv.com"
array_host[dcsprdb]="dcsprdappb.cargowrite.dsv.com"
array_host[dcsprdc]="dcsprdappc.cargowrite.dsv.com"
array_host[dcsprdd]="dcsprdappd.cargowrite.dsv.com"
array_host[dcsprde]="dcsprdappe.cargowrite.dsv.com"
array_host[dcsprdf]="dcsprdappf.cargowrite.dsv.com"

array_user[dcsprd]="dcsprd"
array_user[dcsprdb]="dcsprdb"
array_user[dcsprdc]="dcsprdc"
array_user[dcsprdd]="dcsprdd"
array_user[dcsprde]="dcsprde"
array_user[dcsprdf]="dcsprdf1"

command="cd /share/dcsprdb/scripts/ && ./Jboss_Monitor.sh"
host=${array_host[$1]}
user=${array_user[$1]}


check() {
result=$(ssh -i /home/nagios/ssh_priv_key -l $user $host "cd /share/$user/scripts/ && ./Jboss_Monitor.sh")
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
