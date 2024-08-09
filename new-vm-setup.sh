#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 [-h new_hostname] [-c] [-m]"
    echo "  -h new_hostname  Change the hostname to new_hostname"
    echo "  -c               Clear bash history"
    echo "  -m               Clear machine-id"
    exit 1
}

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root or with sudo."
    exit 1
fi

# Parse arguments
CLEAR_HISTORY=false
CLEAR_MACHINE_ID=false
while getopts "h:cm" opt; do
    case ${opt} in
        h )
            NEW_HOSTNAME=$OPTARG
            ;;
        c )
            CLEAR_HISTORY=true
            ;;
        m )
            CLEAR_MACHINE_ID=true
            ;;
        \? )
            usage
            ;;
    esac
done

# Change the hostname if provided
if [ ! -z "$NEW_HOSTNAME" ]; then
    echo "Changing hostname to $NEW_HOSTNAME"
    hostnamectl set-hostname "$NEW_HOSTNAME"
fi

# Clear machine-id if requested
if [ "$CLEAR_MACHINE_ID" = true ]; then
    echo "Clearing machine-id"
    if [ -f /etc/machine-id ]; then
        cat /dev/null > /etc/machine-id
    fi
    if [ -f /var/lib/dbus/machine-id ]; then
        rm -f /var/lib/dbus/machine-id
    fi
    ln -s /etc/machine-id /var/lib/dbus/machine-id
    echo "machine-id cleared"
fi

# Clear bash history if requested
if [ "$CLEAR_HISTORY" = true ]; then
    echo "Clearing bash history"
    history -c
    cat /dev/null > ~/.bash_history
    if [ -f /root/.bash_history ]; then
        cat /dev/null > /root/.bash_history
    fi
    echo "Bash history cleared"
fi
