#!/usr/bin/env bash
#-----------------------------------------------------------------------------------
#          _ 
#   __ ___| |___ _ _ ___
#  / _/ _ \ / _ \ '_(_-<
#  \__\___/_\___/_| /__/
#
#-----------------------------------------------------------------------------------
VERSION="1.1.5"
#-----------------------------------------------------------------------------------
#
# A set of color variables that allow text in shell scripts to be colored. While
# there are 256 avaialble colors, I picked only the 10 most common ones for both
# text and background colors.
#
#-----------------------------------------------------------------------------------
# Author:   Rick Ellis
# URL:      https://github.com/rickellis/Shell-Scripts
# License:  MIT
#-----------------------------------------------------------------------------------
#
# USAGE: Example at the bottom of this file. Execute this script to see it.
#
#-----------------------------------------------------------------------------------

# TEXT COLORS ----------------------------------------------------------------------

BLK="\033[30m" # Black
GRY="\033[37m" # Grey
RED="\033[91m" # Red
GRN="\033[92m" # Green
BLU="\033[94m" # Blue
YEL="\033[93m" # Yellow
ORG="\033[38;5;202m" # Orange
MAG="\033[95m" # Magenta
PUR="\033[38;5;53m" # Purple
CYN="\033[96m" # Cyan
WHT="\033[97m" # White

# BACKGROUND COLORS ----------------------------------------------------------------

BBLK="\033[40m" # Black
BGRY="\033[48;5;240m" # Grey
BCHR="\033[48;5;237m" # Charcoal
BRED="\033[48;5;1m" # Red
BGRN="\033[48;5;22m" # Green
BBLU="\033[44m" # Blue
BSKY="\033[48;5;25m" # Sky
BYEL="\033[42m" # Yellow
BCOR="\033[48;5;3m" # Coral
BPNK="\033[48;5;207m" # Pink
BMAG="\033[45m" # Magenta
BMAG="\033[48;5;53m" # Purple
BCYN="\033[46m" # Cyan
BWHT="\033[107m" # White

# COLOR RESET ----------------------------------------------------------------------

RST="\033[0m"

# EXAMPLE --------------------------------------------------------------------------

# Just add the color variable in front of text want colored, and the reset
# variable where you want the color to end. Make sure that echo statements are
# executable via the -e flag. Example:

echo -e "${RED}This is red text.${RST}...and...${YEL}this is yellow text.${RST}"