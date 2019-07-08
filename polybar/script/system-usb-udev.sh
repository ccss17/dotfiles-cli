#!/bin/sh

INTERVAL=3

usb_print() {
    devices=$(lsblk -Jplno NAME,TYPE,RM,SIZE,MOUNTPOINT,VENDOR)
    output=""
    counter=0

    for unmounted in $(echo "$devices" | jq -r '.blockdevices[] | select(.type == "part") | select(.rm == true) | select(.mountpoint == null) | .name'); do
        unmounted=$(echo "$unmounted" | tr -d "[:digit:]")
        unmounted=$(echo "$devices" | jq -r '.blockdevices[] | select(.name == "'"$unmounted"'") | .vendor')
        unmounted=$(echo "$unmounted" | tr -d ' ')

        if [ $counter -eq 0 ]; then
            space=""
        else
            space="   "
        fi
        counter=$((counter + 1))

        output="$output$space %{F#f00}$unmounted%{F-}"
    done

    for mounted in $(echo "$devices" | jq -r '.blockdevices[] | select(.type == "part") | select(.rm == true) | select(.mountpoint != null) | .size'); do
        if [ $counter -eq 0 ]; then
            space=""
        else
            space="   "
        fi
        counter=$((counter + 1))

        output="$output$space %{F#0f0}$mounted%{F-}"
    done

    if [ ! $counter -eq 0 ]; then
        prefix="%{F#30a9de}%{F-}"
        output="$prefix$output"
        echo "$output"
    #else
        #prefix="%{F#bb}%{F-}"
        #output="$prefix$output %{F#66}N/A%{F-}"
        #echo "$output"
    fi
}

usb_update() {
    pid=$(cat "$path_pid")

    if [ "$pid" != "" ]; then
        kill -10 "$pid"
    fi
}

path_pid="$HOME/.config/polybar/script/system-usb-udev.pid"

case "$1" in
    --update)
        usb_update
        ;;
    --mount)
        devices=$(lsblk -Jplno NAME,TYPE,RM,MOUNTPOINT)

        for mount in $(echo "$devices" | jq -r '.blockdevices[] | select(.type == "part") | select(.rm == true) | select(.mountpoint == null) | .name'); do
            # udisksctl mount --no-user-interaction -b "$mount"

            # mountpoint=$(udisksctl mount --no-user-interaction -b $mount)
            # mountpoint=$(echo $mountpoint | cut -d " " -f 4 | tr -d ".")
            # terminal -e "bash -lc 'filemanager $mountpoint'"

            mountpoint=$(udisksctl mount --no-user-interaction -b "$mount")
            mountpoint=$(echo "$mountpoint" | cut -d " " -f 4 | tr -d ".")
            termite -e "bash -lc 'mc $mountpoint'" &
        done

        usb_update
        ;;
    --unmount)
        devices=$(lsblk -Jplno NAME,TYPE,RM,MOUNTPOINT)

        for unmount in $(echo "$devices" | jq -r '.blockdevices[] | select(.type == "part") | select(.rm == true) | select(.mountpoint != null) | .name'); do
            udisksctl unmount --no-user-interaction -b "$unmount"
            udisksctl power-off --no-user-interaction -b "$unmount"
        done

        usb_update
        ;;
    *)
        echo $$ > $path_pid

        trap exit INT
        trap "echo" USR1 

        while true; do
            usb_print

            sleep $INTERVAL &
            wait
        done
        ;;
esac
