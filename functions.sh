#!/bin/bash
VALIDATE(){
if [ $? -eq 0 ]
then 
echo "$2 install is success"
else
echo "$2 install is failure"
fi
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
then
dnf install $1 -y
VALIDATE $1 $2
else
echo "$1 already installed"
fi