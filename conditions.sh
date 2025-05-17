#!/bin/bash

userid=$(id- u)
if [ $userid -ne 0 ]
then
echo "only root user have the permission"
else
echo "you have root access"
fi