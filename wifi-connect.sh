#!/usr/bin/env bash
#------------------------------------------------------------------------------
#
# wifi-connect.sh
#
# Connects to Wifi using Network Manager Command Line Interface (nmcli)
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

# If there are no active connections
if [ -z "${conn}" ]; then

    # Generate a list of all available hotspots
    echo
    nmcli dev wifi
    echo -e "\n"
    
    echo "Enter a network to connect to (or ENTER to exit):"
    read network

    if [ "$network" == "" ]; then
        echo "Goodbye..."
        exit 1
    fi

    # Before connecting we need to see if a profile
    # exists for the supplied network. If it exists
    # we use it. If it doesn't, we create it.

    # Get the names of all existing connection profiles
    profiles=$(nmcli con show)

    # Does a profile exist for the supplied network?
    if echo "$profiles" | grep -q "$network"; then

        echo
        echo $(nmcli -t con up id "$network")
        echo
    
    else
    
        echo
        echo "Enter the password for this network:"
        read password
        echo

        # Create a new profile
        nmcli -t dev wifi con "$network" password "$password" name "$network"
        echo
    fi

else

    # If we are connected to a VPN it will show multiple
    # connections, each one on its own line.
    # This lets us show them on one line
    conn=${conn//$'\n'/\ }

    # The connection is green colored
    echo -e "You are currently connected to: \033[92m${conn}\033[0m"
fi
