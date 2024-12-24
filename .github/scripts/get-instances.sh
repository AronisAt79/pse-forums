#!/bin/bash

set -ex

projectname=$1
instancename=$2

get_instances() {
    instances=`aws ec2 describe-instances \
        --filters "Name=tag:ProjectName,Values=$projectname" \
        --filters "Name=tag:Name,Values=$instancename" \
        --query "Reservations[].Instances[].{ID:InstanceId, NAME:Tags[?Key=='Name']|[0].Value,STATE:State}" \
        --output json `
    
    echo $instances   
}

instances=`get_instances`

# Check how many ec2 hosts match the filter criteria. There should be only one

instances_length=`echo $instances | jq '. | length'

if [ $instances_length -neq 1];then
    echo "Found more than one ec2 hosts matching the filter definition. Please check the environment or filter syntax. EXITING"
    exit 1
fi

instance_id=`jq -r .[0].ID <<< $instances`

echo $instance_id