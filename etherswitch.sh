#!/bin/env bash

conf=~/.etherswitch
switch_state=0

function check_fn {
    type $1 &> /dev/null || {
	>&2 echo "$1 is undefined"
	exit 1
    }
}

function load_config {
    unset -f on_switch_close
    unset -f on_switch_open
    source $conf
    if [ -z "$device" ]
    then
	>&2 echo "device is not set"
	exit 1
    fi
    # check if $device is a network device
    ip link show $device > /dev/null
    if [ $? -eq 1 ]; then exit 1; fi

    check_fn "on_switch_close"
    check_fn "on_switch_open"
}

# handle SIGTERM
trap 'exit' 15

# handle SIGHUP (config reload)
trap 'load_config' 1

load_config

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
