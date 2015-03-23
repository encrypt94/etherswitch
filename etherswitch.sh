#!/bin/env bash

STATE=0

source ~/.etherswitch

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

