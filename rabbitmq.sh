#!/bin/bash

source common.sh

print_msg "Install ERLang"
yum list installed | grep erlang &>>$Log_file
if [ $? -ne 0 ]; then
  yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y  &>>$Log_file
fi
status_check $?

print_msg "Setup RabbitMQ repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>$Log_file
status_check $?

print_msg "Install RabbitMQ Server"
yum install rabbitmq-server -y &>>$Log_file
status_check $?

print_msg "Start RabbitMQ Service"
systemctl enable rabbitmq-server &>>$Log_file && systemctl start rabbitmq-server &>>$Log_file
status_check $?

print_msg "Create App User in RabbitMQ"
rabbitmqctl  list_users | grep roboshop &>>$Log_file
if [ $? -ne 0 ]; then
  rabbitmqctl add_user roboshop roboshop123 &>>$Log_file
fi
rabbitmqctl set_user_tags roboshop administrator &>>$Log_file  && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$Log_file
status_check $?
