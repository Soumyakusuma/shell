#!/bin/bash

AMI_ID="ami-09c813fb71547fc4f"
SG_ID="sg-06dc2b0cd3ece8e62"
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "user" "catalogue" "cart" "shipping" "payment" "dispatch" "frontend")4
ZONE_ID="Z0349103U6EUQ8TEV3VX"
DOMAIN_NAME="pract.site"

for instance in ${instance[@]}
do
INSTANCE_ID=$(aws ec2 run-instances --image-id ami-09c813fb71547fc4f --instance-type t3.micro --security-group-ids sg-06dc2b0cd3ece8e62 --tag-specifications "ResourceType=instance,Tags=[{Key=Name, Value=$instance}]" --query "Instances[0].InstanceId" --output text)
if [ $instance != 'frontend']
then
 IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PrivateIpAddress" --output text)
 echo "ip address is $IP , $INSTANCE_ID"
else
IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
echo "ip address is $IP , $INSTANCE_ID"
fi
done
