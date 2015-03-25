#!/bin/env bash

switch_state=0

function check_fn {
    type $1 &> /dev/null || {
	echo "$1 is undefined"
	exit 1
    }
}

source ~/.etherswitch

if [ -z "$device" ]
then
    echo "device is not set"
    exit 1
fi

# check if $device is a network device
ip link show $device > /dev/null
if [ $? -eq 1 ]; then exit 1; fi   

check_fn "on_switch_close"
check_fn "on_switch_open"

while :
do
    ip link show $device | grep -q "LOWER_UP" 
    if [ $? -eq 1 ]
    then
	if [ $switch_state -eq 1 ]
	then
	    switch_state=0
	    on_switch_open
	fi	    
    else
	if [ $switch_state -eq 0 ]
	then
	    switch_state=1
	    on_switch_close
	fi
    fi
    sleep 0.3
done
