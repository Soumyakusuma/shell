#!/bin/bash

userid=$(id -u)

if [ $userid -ne 0 ]
then
echo "only root user have the permission"
exit 1
else
echo "you have root access"
fi
dnf install nginx -y

if [ $? -eq 0 ]
then
echo " install mysqlddddd is succss"
else 
echo "install ysql failure"
exit 1
fi