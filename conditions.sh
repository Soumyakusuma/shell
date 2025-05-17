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