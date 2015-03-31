#!/bin/sh

conf=/etc/etherswitch.rc
switch_state=-1

check_fn() {
    type $1 &> /dev/null || {
	>&2 echo "$1 is undefined"
	exit 1
    }
}

load_config() {
    unset -f on_switch_close
    unset -f on_switch_open
    unset -f on_switch_toggle

    source $conf

    if [ -z "$device" ]
    then
	>&2 echo "device is not set"
	exit 1
    fi

    if [ -z "$port" ]
    then
	>&2 echo "port is not set"
	exit 1
    fi

    # check if $device is a network device
    swconfig dev $device show > /dev/null
    if [ $? -eq 1 ]; then exit 1; fi

    check_fn "on_switch_close"
    check_fn "on_switch_open"
    check_fn "on_switch_toggle"
}

# handle SIGTERM
trap 'exit' 15

# handle SIGHUP (config reload)
trap 'load_config' 1

load_config

while :
do
    swconfig dev $device port $port show | grep -q "up"
    current_state=$?
    if [ $current_state -ne $switch_state ]
    then
	switch_state=$current_state
	on_switch_toggle
	if [ $switch_state -eq 1 ]
	then
	    on_switch_open
	else
	    on_switch_close
	fi
    fi
    sleep 1
done
