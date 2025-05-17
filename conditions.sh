#!/bin/bash

userid=$(id -u)

if [ $userid -ne 0 ]
then
echo "only root user have the permission"
exit 1
else
echo "you have root access"
fi
dnf install mysqkgcxvxmysql -y

if [ $? -eq 0 ]
then
echo " install mysql is succss"
else 
echo "install ysql failure"
exit 1
fi