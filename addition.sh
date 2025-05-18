#!/bin/bash
num=$1
cnt=0
val=$(($cnt+$num))
if [ $cnt -gt 0 ]
then
echo "$1 is positive number"
else
echo "$1 is negative number"
fi

