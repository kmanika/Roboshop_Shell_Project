#!/bin/bash

source  common.sh
# Function to check whether user is Sudo
check_user
# Verify the s/w install or not, If not installing it
SW_installed_check "nodejs"
New_user_creation "roboshop"
Code_Download "user"
Code_Install "user"
Folder_Rename "user"

print_msg "NPM install"
npm install &>> $Log_file
status_check $?

Config_file_update "user"
Systemd_DNS_update "user"
Daemon_enable
Start_Service "user"
