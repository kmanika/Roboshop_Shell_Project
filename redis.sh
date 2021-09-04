#!/bin/bash

source  common.sh
check_user
print_msg "Install Redis Repos"
yum install epel-release yum-utils https://ftp.igh.cnrs.fr/pub/remi/enterprise/remi-release-7.rpm  -y &>>Log_file
status_check $?

print_msg "Install Redis\t\t"
yum install redis -y --enablerepo=remi &>>Log_file
status_check $?

print_msg "Update Redis Listen Address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf
status_check $?

print_msg "Start Redis Service\t"
systemctl enable redis &>>Log_file && systemctl restart redis &>>Log_file
status_check $?