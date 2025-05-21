#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/roboshop-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
mkdir -p $LOGS_FOLDER
Script_path=$PWD
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
 fi
}

dnf module disable redis -y &>>$LOG_FILE
VALIDATE $? "disable redis"

dnf module enable redis:7 -y &>>$LOG_FILE
VALIDATE $? "enable redis"

dnf install redis -y  &>>$LOG_FILE
VALIDATE $? "install redis"

sed -ie 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
VALIDATE $? "change ip and protected mode in redis conf file"

systemctl enable redis 
systemctl start redis &>>$LOG_FILE
VALIDATE $? "enable and start redis"