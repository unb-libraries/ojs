#!/bin/bash

LOG=/var/log/ojs/crkn-ips.log
EC2BIN=/var/opt/ec2-sns-sender/sns_send
SUBJECT='CRKN IP Subscription Data'
TOPIC='arn:aws:sns:us-east-1:344420214229:unb_lib_crkn_subscriber_data'

RECENT=`find $LOG -mtime -1`
if [ $RECENT == '' ]
then
  OUT=`$EC2BIN -t $TOPIC -s "$SUBJECT" -m 'FAIL: Log file not updated'`
  exit
fi

COUNT=`grep Entries $LOG|awk '{print $NF}'`

if [ $COUNT == '' ] || [ $COUNT == 0 ]
then
  OUT=`$EC2BIN -t $TOPIC -s "$SUBJECT" -m 'FAIL: No entries synchronized'`
else
  OUT=`$EC2BIN -t $TOPIC -s "$SUBJECT" -m "SUCCESS: $COUNT entries synchronized"`
fi
