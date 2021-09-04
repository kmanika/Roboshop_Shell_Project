#!/bin/bash

source  common.sh
# Function to check whether user is Sudo
check_user
# Verify the s/w install or not, If not installing it
SW_installed_check "maven"
New_user_creation "roboshop"
Code_Download "shipping"
Code_Install "shipping"
Folder_Rename "shipping"

print_msg "mvn clean"
mvn clean package &>> $Log_file && mv target/shipping-1.0.jar shipping.jar >> $Log_file
status_check $?

Config_file_update "shipping"
Systemd_DNS_update "shipping"
Daemon_enable
Start_Service "shipping"
