#!/bin/bash
alert=$1
target=$2
loss=$3
rtt=$4
host=$5

echo "$(date) alertname: $1 target: $2 losspattern: $3 rtt: $4 hostname: $5" >> /opt/smokeping/alert_smokeping.log
