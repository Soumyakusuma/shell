#!/bin/bash

VALIDATE(){

if [ $? -eq 0 ]
then 
echo "$1 install is success"
else
echo "$1 install is failure"
}

userid=$(id -u)

if [ $userid -ne 0 ]
then
echo "only root user have the permission"
exit 1
else
echo "you have root access"
fi
dnf list installed $1 
if [ $? -ne 0 ]
dnf install $1 -y
VALIDATE $? $1
else
echo "$1 already installed"
exit 1
fi