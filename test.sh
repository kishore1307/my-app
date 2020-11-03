#!/bin/bash
echo "currrent directory "
pwd
rm -f /tmp/SupportEC2Instances-294.csv
rm -f /tmp/SupportEC2Instances-294_tmp.csv
aws ec2 describe-instances --output text --query "Reservations[*].Instances[*].[ [Tags[?Key=='Name'].Value] [0][0] , InstanceId, InstanceType, State.Name, LaunchTime$, Placement.AvailabilityZone, PrivateIpAddress ]" --region=us-east-1 --profile=support  |grep -v  "^aws" > /tmp/SupportEC2Instances-294_tmp.csv 
cat /tmp/SupportEC2Instances-1.csv|sort -n >/tmp/SupportEC2Instances.csv
awk -vORS=, '{ print $1 }' /tmp/SupportEC2Instances.csv | sed 's/,$/\n/' >> /tmp/SupportEC2Instances-294_tmp.csv 
sed -i '1s/^/InstanceName=/' /tmp/SupportEC2Instances-294_tmp.csv	
cp /tmp/SupportEC2Instances-294_tmp.csv /var/lib/jenkins/workspace/EC2-Start-Stop-support-account/list.txt
cp /tmp/SupportEC2Instances-294_tmp.csv  /var/lib/jenkins/workspace/support_aws/aws_support_ec2_instance_dynamic_list/list.txt
cat /var/lib/jenkins/workspace/EC2-Start-Stop-support-account/list.txt
