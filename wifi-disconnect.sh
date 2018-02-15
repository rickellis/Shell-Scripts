#!/usr/bin/env bash
#------------------------------------------------------------------------------
#
# wifi-disconnect.sh
#
# Uses Network Manager Command Line Interface (nmcli) to disconnect from WiFi
#
# by Rick Ellis
# https://github.com/rickellis/Shell-Scripts/
#
# License: MIT
#
#------------------------------------------------------------------------------
# DON'T JUST RUN THIS SCRIPT. EXAMINE IT. UNDERSTAND IT. RUN AT YOUR OWN RISK.
#------------------------------------------------------------------------------

# Get the name of the currently active wifi connection
conn=$(nmcli -t -f name con show --active)

# If a VPN connection is active, $conn will contain
# multiple connections separated by newlines.
# We only want the first connection
IFS='\n' read -r -a conn <<< "$conn"

if [ -z "${conn}" ]; then
    echo 
    echo "You are not connected to a WiFi network."
    echo
    exit 1
fi

echo
nmcli -t con down id "$conn"
echo