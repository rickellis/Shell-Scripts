#!/usr/bin/env bash
#------------------------------------------------------------------------------
#
# vpn-disconnect.sh
#
# Uses Network Manager Command Line Interface (nmcli) to disconnect from VPN
#
# by Rick Ellis
# https://github.com/rickellis/Shell-Scripts/
#
# License: MIT
#
#------------------------------------------------------------------------------
# DON'T JUST RUN THIS SCRIPT. EXAMINE IT. UNDERSTAND IT. RUN AT YOUR OWN RISK.
#------------------------------------------------------------------------------

nmcli -t con down id "fastVPN"