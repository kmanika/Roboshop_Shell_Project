#!/bin/bash

source  common.sh
# Function to check whether user is Sudo
check_user
# Verify the s/w install or not, If not installing it
SW_installed_check "nodejs"
New_user_creation "roboshop"
Code_Download "catalogue"
Code_Install "catalogue"
Folder_Rename "catalogue"
cd /home/roboshop/catalogue

print_msg "NPM install"
npm install --unsafe-perm  &>> $Log_file
status_check $?

Config_file_update "catalogue"
Systemd_DNS_update "catalogue"
Daemon_enable
Start_Service "catalogue"

