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

get_instances