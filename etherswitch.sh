#!/bin/env bash

STATE=0

source ~/.etherswitch

if [ -z "$interface" ]
then
    echo "interface is not set"
    exit 1
fi

# check if $interface is a network device
ip link show $interface > /dev/null
if [ $? -eq 1 ]; then exit 1; fi   

while :
do
    ip link show $interface | grep -q "LOWER_UP" 
    if [ $? -eq 1 ]
    then
	if [ $STATE -eq 1 ]
	then
	    STATE=0
	    echo "not connected"
	fi	    
    else
	if [ $STATE -eq 0 ]
	then
	    STATE=1
	    echo "connected"
	fi
    fi
    sleep 0.3
done

