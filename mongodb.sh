#!/bin/bash

source  common.sh
# Function to check whether user is Sudo
check_user
print_msg "Mongo DB repo setup"
echo '[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc' >/etc/yum.repos.d/mongodb.repo
status_check $?
# Verify the s/w install or not, If not installing it
SW_installed_check "mongodb"

print_msg "Update MongoDB Listen Address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
status_check $?

Start_Service "mongod"

Code_Download "mongodb"
print_msg "Schema Load"
cd /tmp && unzip -o -q mongodb.zip &>> $Log_file && cd mongodb-main && mongo < catalogue.js &>> $Log_file && mongo < users.js &>> $Log_file
status_check $?