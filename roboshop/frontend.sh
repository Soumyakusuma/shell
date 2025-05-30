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
 fi
}

 dnf module disable nginx -y &>>$LOG_FILE
 VALIDATE $? "disable nginx"

dnf module enable nginx:1.24 -y &>>$LOG_FILE
VALIDATE $? "enable nginx"

dnf install nginx -y &>>$LOG_FILE
VALIDATE $? "install nginx"

systemctl enable nginx 
systemctl start nginx &>>$LOG_FILE
VALIDATE $? "enable and start nginx" 

rm -rf /usr/share/nginx/html/*  
VALIDATE $? "remove older content from html file "

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$LOG_FILE
VALIDATE $? "download file"

cd /usr/share/nginx/html 

unzip /tmp/frontend.zip &>>$LOG_FILE
VALIDATE $? "unzipping the file"

rm -rf /etc/nginx/nginx.conf &>>$LOG_FILE
VALIDATE $? "Remove default nginx conf"

cp $Script_DIR/nginx.conf /etc/nginx/nginx.conf
VALIDATE $? "copying conf file"

systemctl restart nginx 
VALIDATE $? "restart nginx"
