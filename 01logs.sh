#!/bin/bash

USERID=$(id -u)

logs_path=/var/log/shellscript
file_name=$(echo 01logs.sh | cut -d "." -f1 )
mkdir -p $logs_path
log=$logs_path/$file_name.log

echo "script started at $(date)" $>>log

if [ $USERID -ne 0 ]
then
    echo "ERROR:: Please run this script with root access" $>>log
    exit 1 #give other than 0 upto 127
else
    echo "You are running with root access" $>>log
fi

# validate functions takes input as exit status, what command they tried to install
VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo "Installing $2 is ... SUCCESS" $>>log
    else
        echo "Installing $2 is ... FAILURE" $>>log
        exit 1
    fi
}

dnf list installed mysql
if [ $? -ne 0 ]
then
    echo "MySQL is not installed... going to install it" $>>log
    dnf install mysql -y
    VALIDATE $? "MySQL"
else
    echo "MySQL is already installed...Nothing to do" $>>log
fi

dnf list installed python3
if [ $? -ne 0 ]
then
    echo "python3 is not installed... going to install it" $>>log
    dnf install python3 -y
    VALIDATE $? "python3"
else
    echo "python3 is already installed...Nothing to do" $>>log
fi

dnf list installed nginx
if [ $? -ne 0 ]
then
    echo "nginx is not installed... going to install it" $>>log
    dnf install nginx -y
    VALIDATE $? "nginx"
else
    echo "nginx is already installed...Nothing to do" $>>log
fi