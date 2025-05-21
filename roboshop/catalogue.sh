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

dnf module disable nodejs -y &>>$LOG_FILE
VALIDATE $? "disable nodejs"

dnf module enable nodejs:20 -y &>>$LOG_FILE
VALIDATE $? "enable nodejs"

dnf install nodejs -y &>>$LOG_FILE
VALIDATE $? "install nodejs"

id roboshop
if [ $? -ne 0 ]
then
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
VALIDATE $? "create user roboshop"
else
echo "roboshop user aready exist"

mkdir -p /app 
VALIDATE $? "create app directory"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip &>>$LOG_FILE
VALIDATE $? "download file"

rm -rf /app/*

cd /app 
unzip /tmp/catalogue.zip
VALIDATE $? "unzipping file"

npm install &>>$LOG_FILE
VALIDATE $? "install packages"

cp /$Script_path/catalogue.service /etc/systemd/system/catalogue.service
VALIDATE $? "copying catalogue.service file"

systemctl daemon-reload
systemctl enable catalogue 
systemctl start catalogue
VALIDATE $? "load and start catalogue"

cp /$Script_path/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "copy mongo file"

dnf install mongodb-mongosh -y &>>$LOG_FILE
VALIDATE $? "install mongo client"

mongosh --host mongodb.pract.site </app/db/master-data.js
VALIDATE $? "load the data"