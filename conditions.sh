#!/bin/bash

userid=$(id -u)

if [ $userid -ne 0 ]
then
echo "only root user have the permission"
exit 1
else
echo "you have root access"
dnf list installed nginx 
if [ $? -eq 0 ]
then
echo "nginx already installed"
exit 1
else
dnf install nginx -y
if [ $? -eq 0 ]
then 
echo "nginx install is success"
else
echo "nginx install is failure"
fi
fi
fi







