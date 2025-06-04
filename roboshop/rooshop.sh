#!/bin/bash

AMI_ID="ami-09c813fb71547fc4f"
SG_ID="sg-099e213b8903ae6d9"
#INSTANCES=("mongodb" "frontend" "catalogue" "redis" "mysql" "rabbitmq" "user" "cart" "shipping" "payment" "dispatch" )
ZONE_ID="Z03148573A2NAXD6GP1WZ"
DOMAIN_NAME="pract.site"

for instance in $@
do
INSTANCE_ID=$(aws ec2 run-instances --image-id ami-09c813fb71547fc4f --instance-type t3.micro --security-group-ids sg-099e213b8903ae6d9 --tag-specifications "ResourceType=instance,Tags=[{Key=Name, Value=$instance}]" --query "Instances[0].InstanceId" --output text)
if [ $instance != 'frontend' ]
then
 IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PrivateIpAddress" --output text)
 echo "ip address is $IP , $instance"
else
IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
echo "ip address is $IP , $instance"
fi


aws route53 change-resource-record-sets \
    --hosted-zone-id $ZONE_ID \
    --change-batch '
    {
        "Comment": "Creating or Updating a record set for cognito endpoint"
        ,"Changes": [{
        "Action"              : "UPSERT"
        ,"ResourceRecordSet"  : {
            "Name"              : "'$instance'.'$DOMAIN_NAME'"
            ,"Type"             : "A"
            ,"TTL"              : 1
            ,"ResourceRecords"  : [{
                "Value"         : "'$IP'"
            }]
        }
        }]
    }'
done
