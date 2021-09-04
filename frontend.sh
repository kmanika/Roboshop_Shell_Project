#!/bin/bash
source common.sh

# Function to check whether user is Sudo
check_user
# Verify the s/w install or not, If not installing it
SW_installed_check "nginx"

## Business logic code
print_msg "Downloading the source codes"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>> $Log_file
status_check $?

print_msg "Removing the old html docs"
cd /usr/share/nginx/html &>> $Log_file && rm -rf * &>> $Log_file
status_check $?

print_msg "Installing the code"
unzip /tmp/frontend.zip &>> $Log_file && mv frontend-main/* . &>> $Log_file && mv static/* . &>> $Log_file && rm -rf frontend-master static &>> $Log_file
status_check $?

print_msg "Updating the config files"
mv localhost.conf /etc/nginx/default.d/roboshop.conf &>> $Log_file
status_check $?

print_msg "Update RoboShop Config\t"
sed -i -e '/catalogue/ s/localhost/catalogue.roboshop.internal/' -e '/user/ s/localhost/user.roboshop.internal/'  -e '/cart/ s/localhost/cart.roboshop.internal/' -e '/shipping/ s/localhost/shipping.roboshop.internal/' -e '/payment/ s/localhost/payment.roboshop.internal/' /etc/nginx/default.d/roboshop.conf
status_check $?

print_msg "Enabling Nginx"
systemctl enable nginx &>> $Log_file
status_check $?

print_msg "Starting Nginx"
systemctl restart nginx &>> $Log_file
status_check $?