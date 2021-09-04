#!/bin/bash

source  common.sh
# Function to check whether user is Sudo
check_user

print_msg "Install Python3\t\t"
yum install python36 gcc python3-devel -y &>>$Log_file
status_check $?

New_user_creation "roboshop"
Code_Download "payment"
Code_Install "payment"
Folder_Rename "payment"

print_msg "Install pip3"
yum install python3-pip -y &>> $Log_file
status_check $?

print_msg "Install Python Dependencies"
cd /home/roboshop/payment && pip3 install -r requirements.txt &>>$Log_file
status_check $?

print_msg "Update Service Configuration"
userID=$(id -u roboshop)
groupID=$(id -g roboshop)
sed -i -e "/uid/ c uid = ${userID}" -e "/gid/ c gid = ${groupID}" payment.ini &>>$Log_file
status_check $?

PERM_FIX
Config_file_update "payment"
Systemd_DNS_update "payment"
Daemon_enable
Start_Service "payment"