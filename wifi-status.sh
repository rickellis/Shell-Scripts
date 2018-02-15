#!/usr/bin/env bash
#------------------------------------------------------------------------------
#
# wifi-status.sh
#
# Uses Network Manager Command Line Interface (nmcli) to check the status of a connection
#
# by Rick Ellis
# https://github.com/rickellis/Shell-Scripts/
#
# License: MIT
#
#------------------------------------------------------------------------------
# DON'T JUST RUN THIS SCRIPT. EXAMINE IT. UNDERSTAND IT. RUN AT YOUR OWN RISK.
#------------------------------------------------------------------------------

# Get the name of the active wifi connection
conn=$(nmcli -t -f name con show --active)

# If we are connected to a VPN it will show multiple
# connections, each one on its own line.
# This lets us show them on one line
conn=${conn//$'\n'/\ }

if [ -z "${conn}" ]; then
    echo "You are not connected to a WiFi network."
else
    echo -e "You are currently connected to: \033[92m${conn}\033[0m"
fi