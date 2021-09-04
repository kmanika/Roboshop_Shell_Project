#!/bin/bash

source  common.sh

print_msg "Mysql repo"
echo '[mysql57-community]
name=MySQL 5.7 Community Server
baseurl=http://repo.mysql.com/yum/mysql-5.7-community/el/7/$basearch/
enabled=1
gpgcheck=0' > /etc/yum.repos.d/mysql.repo
status_check $?

SW_installed_check "mysql"

print_msg "Start MYsql"
systemctl enable mysqld
systemctl start mysqld
status_check $?

print_msg "Reset MySQL Root Password"
DEFAULT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log  | awk '{print $NF}')
echo "show databases;" | mysql -uroot -pRoboShop@1 &>>Log_file
if [ $? -ne 0 ]; then
  echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1';" | mysql --connect-expired-password -uroot -p${DEFAULT_PASSWORD} &>>Log_file
fi
status_check $?

print_msg "Uninstall MySQL Password Policy"
echo SHOW PLUGINS | mysql -uroot -pRoboShop@1 2>>Log_file | grep -i validate_password &>>Log_file
if [ $? -eq 0 ]; then
  echo "uninstall plugin validate_password;" | mysql -uroot -pRoboShop@1 &>>Log_file
fi
status_check $?

print_msg "Download Schema\t\t"
curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip" &>>Log_file
status_check $?

print_msg "Load Schema\t\t"
cd /tmp && unzip -o mysql.zip &>>Log_file && cd mysql-main && mysql -uroot -pRoboShop@1 <shipping.sql &>>Log_file
status_check $?