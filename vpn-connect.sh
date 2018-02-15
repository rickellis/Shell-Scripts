#!/usr/bin/env bash
#------------------------------------------------------------------------------
#
# vpn-connect.sh
#
# Version 1.0.0
#
# Benchmarks the NordVPN servers and connects to the fastest one using
# Network Manager Command Line Interface (nmcli)
#
# by Rick Ellis
# https://github.com/rickellis/Shell-Scripts/
#
# License: MIT
#
#------------------------------------------------------------------------------
# DON'T JUST RUN THIS SCRIPT. EXAMINE IT. UNDERSTAND IT. RUN AT YOUR OWN RISK.
#------------------------------------------------------------------------------

# The name we're calling our new VPN profile
profile="fastVPN"

# Path to folder containing NordVPN TCP server config files
vpnpath="${HOME}/CodeLab/VPN"

# File containing my username. I don't want this on git so I include it.
source "${vpnpath}/credentials.sh"

# Get the name of the currently active wifi connection
echo "Verifying active WiFi connection..."
conn=$(nmcli -t -f name con show --active)

# We can't connect to a VPN unless there is an active connection
if [ -z "${conn}" ]; then
    echo
    echo "You must be connected to a WiFi network before connecting to a VPN."
fi

# Fetch the JSON server list from Nord
# Select only US servers with less than 5% load.
# Returns an array with filenames.
echo "Downloading the server data from nordvpn.com..."
fastest=$(curl -s 'https://nordvpn.com/api/server' | jq -r 'sort_by(.load) | .[] | select(.load < '5' and .flag == '\"US\"' and .features.openvpn_tcp == true ) | .domain')

server=""
for filename in $fastest; do
    server="$filename"
    break
done

# No server returned?
if [ "$server" == "" ]; then
    echo "Error: Unable to acquire the name of the fastest server. Aborting..."    
    exit 1
fi

# Does the local Nord VPN file exist?
if [ ! -f "${vpnpath}/ovpn_tcp/${server}.tcp.ovpn" ]; then
    echo "Unable to find the OVPN file: ${vpnpath}/ovpn_tcp/${server}.tcp.ovpn"
    exit 1
fi

# Delete the old VPN profile if it exists
echo "Deleting old VPN profile"
nmcli con delete id "${profile}" >/dev/null 2>&1 
sleep 2

# Make a copy of the VPN file. We do this becuasse NetworkManager
# names profiles with the filename, so giving the profile a fixed name
# allows us to delete the old profile everytime we run this script.
# There are over 1000 servers to choose from so we would need a
# tracking mechanism if we didn't use the same name.
cp "${vpnpath}/ovpn_tcp/${server}.tcp.ovpn" "${vpnpath}/${profile}.ovpn"

# Import the new profile
echo "Importing new VPN profile"
nmcli con import type openvpn file "${vpnpath}/${profile}.ovpn"
sleep 2

echo "Configuring profile"

# Insert username into config file
$(sudo nmcli connection modify ${profile} +vpn.data username=${username})

# Set the password flag
$(sudo nmcli connection modify ${profile} +vpn.data password-flags=0)

# Reload the config file
echo "Reloading config file"
sudo nmcli connection reload fastVPN

# Delete the temp file
rm "${vpnpath}/${profile}.ovpn"

echo "Connecting to ${server}..."
nmcli con up id "fastVPN"