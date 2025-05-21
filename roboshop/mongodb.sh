#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/roboshop-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
mkdir -p $LOGS_FOLDER
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

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "copying mongo repo" 

dnf install mongodb-org -y &>>$LOG_FILE
VALIDATE $? "installing mongodb" 

systemctl enable mongod 
systemctl start mongod 
VALIDATE $? "enabling and starting mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "replacing ip address in conf file"

systemctl restart mongod
VALIDATE $? "restart is done"


