#!/bin/bash

Log_file=/tmp/robosho_log.log
touch $Log_file

check_user() {
   user_id=$(id -u);
    if [ $user_id -ne 0 ]; then
      echo -n -e "Run the script as root user";
      exit 1
    fi
}

New_user_creation() {
  user_name=$(cat /etc/passwd |grep $1)
  if [ $? -ne 0 ]; then
      useradd $1
  fi
  }

Code_Download() {
  print_msg "Downloading the source code"
  curl -s -L -o /tmp/$1.zip "https://github.com/roboshop-devops-project/$1/archive/main.zip" &>> $Log_file
  status_check $?
}

Code_Install() {
  print_msg "Installing the code"
  cd /home/roboshop  &>> $Log_file && unzip -o -q /tmp/$1.zip  &>> $Log_file
  status_check $?
}

Folder_Rename() {
  print_msg "Rename the folder"
  if [ -d "./$1-main" ]; then
    rm -rf ./$1
    mv $1-main $1 &>> $Log_file && cd /home/roboshop/$1 &>> $Log_file
    status_check $?
fi
}
Install_dependecies() {
  print_msg "Installing Dependecies"
  pip3 install -r requirements.txt &>> $Log_file
  status_check $?

  print_msg "Updating ini file with user details"
  userID=$(id -u roboshop)
  groupID=$(id -g roboshop)
  sed -i -e "/uid/ c uid = ${userID}" -e "/gid/ c gid = ${groupID}" payment.ini &>> $Log_file
  status_check $?
}
Maven_package() {
  print_msg "Maven clean"
  mvn clean package &>> $Log_file
  mv target/$1-1.0.jar $1.jar
  status_check $?
}

Config_file_update() {
  print_msg "Updating the config files"
  mv /home/roboshop/$1/systemd.service /etc/systemd/system/$1.service &>> $Log_file
  status_check $?
}

Systemd_DNS_update() {
  print_msg "Updating DNS entry"
  sed -i -e "s/MONGO_DNSNAME/mongodb.roboshop.internal/" -e "s/REDIS_ENDPOINT/redis.roboshop.internal/" -e "s/MONGO_ENDPOINT/mongodb.roboshop.internal/" -e "s/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/" -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' -e 's/CARTHOST/cart.roboshop.internal/' -e 's/USERHOST/user.roboshop.internal/' -e 's/AMQPHOST/rabbitmq.roboshop.internal/'  /etc/systemd/system/$1.service &>> $Log_file
  status_check $?
}

Daemon_enable() {
  print_msg "Enabling daemon"
  systemctl daemon-reload &>> $Log_file
  status_check $?
}

Start_Service() {
  print_msg "Starting the service"
  systemctl start $1 &>> $Log_file &&  systemctl enable $1 &>> $Log_file
  status_check $?
}

SW_installed_check() {
  sudo yum list installed|grep $1 >> $Log_file
    if [ $? -eq 0 ]; then
        print_msg "Software already installed"
        status_check $?
    else
      print_msg "Installing $1"
      if [ $1 == "nodejs" ]; then
        yum install nodejs make gcc-c++ -y &>> $Log_file
        status_check $?
      elif [ $1 == "nginx" ]; then
        yum install nginx -y &>> $Log_file
        status_check $?
        elif [ $1 == "maven" ]; then
        yum install maven -y &>> $Log_file
        status_check $?
        elif [ $1 == "python" ]; then
        yum install python36 gcc python3-devel -y &>> $Log_file
        status_check $?
        elif [ $1 == "mysql" ]; then
        yum install mysql-community-server -y  &>> $Log_file
        status_check $?
        elif [ $1 == "mongodb" ]; then
        yum install -y mongodb-org  &>> $Log_file
        status_check $?
        elif [ $1 == "rabbitmq" ]; then
        yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y  &>> $Log_file
        status_check $?
      fi
    fi
}
status_check() {
  if [ $1 -eq 0 ];then
  echo -e "\e[32m done\e[0m"
else
  echo -e "\e[31m failed\e[0m"
  exit 1
fi
}


print_msg() {
echo -n -e "$1 \t\t...."
}

PERM_FIX() {
  print_msg "Fix Application Permissions"
  chown roboshop:roboshop /home/roboshop -R &>>$Log_file
  status_check $?
}
