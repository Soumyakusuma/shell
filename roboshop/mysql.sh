#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/roboshop-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
mkdir -p $LOGS_FOLDER
Script_DIR=$PWD
echo "Script started executing at: $(date)" | tee -a $LOG_FILE

if [ $USERID -ne 0 ]
then
echo "please run with root access" | tee -a $LOG_FILE
exit 1
else
echo "you are running with root access" | tee -a $LOG_FILE
fi 

VALIDATE(){
 if [ $1 -eq 0 ]
 then
 echo "$2 is success...." | tee -a $LOG_FILE
 else
 echo "$2 is failure..." | tee -a $LOG_FILE
 exit 1
 fi
}


dnf install mysql-server -y
VALIDATE $? "install mysql"

systemctl enable mysqld
systemctl start mysqld  
VALIDATE $? "enable and start mysql"

mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "set password for mysql"