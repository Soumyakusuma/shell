#!/bin/bash

userid=$(id -u)

if [ $userid -ne 0 ]
then
echo "only root user have the permission"
exit 1
else
echo "you have root access"
dnf list installed nginx 
if [$? -eq 0]
then
echo "nginx already installed"
exit 1
else
dnf install nginx
if [ $? eq 0 ]
then 
echo "nginx install is success"
else
echo "nginx install is failure"
fi
fi
fi








if [ $? -ne 0 ]
dnf install nginx -y
if [ $? eq 0 ]
then 
echo "nginx install is success"
else
echo "nginx install is failure"

else
echo "nginx already installed"
fi
fi

if [ $? -eq 0 ]
then
echo "nginx already installed"
exit 1
else
dnf install nginx  -y
if [ $? -eq 0 ]
then
echo " install nginxl is succss"
else 
echo "install nginx failure"
exit 1
fi
fi