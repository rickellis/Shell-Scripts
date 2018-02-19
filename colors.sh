#!/usr/bin/env bash
#-----------------------------------------------------------------------------------
#         _ 
#   __ ___| |___ _ _ ___
#  / _/ _ \ / _ \ '_(_-<
#  \__\___/_\___/_| /__/
#
#-----------------------------------------------------------------------------------
VERSION="1.1.0"
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

DFT="\033[39m" # Terminal default color
BLK="\033[30m" # Black
GRY="\033[37m" # Grey
RED="\033[91m" # Red
GRN="\033[92m" # Green
BLU="\033[94m" # Blue
YEL="\033[93m" # Yellow
MAG="\033[95m" # Magenta
CYN="\033[96m" # Cyan
WHT="\033[97m" # White

# BACKGROUND COLORS ----------------------------------------------------------------

BDFT="\033[49m" # Terminal default color
BBLK="\033[40m" # Black
BGRY="\033[47m" # Grey
BRED="\033[41m" # Red
BGRN="\033[42m" # Green
BBLU="\033[44m" # Blue
BYEL="\033[42m" # Yellow
BMAG="\033[45m" # Magenta
BCYN="\033[46m" # Cyan
BWHT="\033[107m" # White

# COLOR RESET ----------------------------------------------------------------------

RST="\033[0m"

# HEADING FUNCTION -----------------------------------------------------------------

# Generates heading with a background color and white text, centered.
function heading() {

    if [ -z "$1" ] || [ -z "$2" ]; then
        echo 'Usage: heading <color> "My cool heading"'
        exit 1
    fi

    color=${1}
    color=${color^^} # Uppercase the color
    text=${2}
    length=74 # Overal length of heading
    reset="\033[0m"
    
    case "$color" in
    BLACK)
        color="\033[40m\033[97m" # Black with white text
    ;;
    GREY)
        color="\033[47m\033[97m" # Grey with white text
    ;;
    RED)
        color="\033[41m\033[97m" # Red with white text
    ;;
    GREEN)
        color="\033[42m\033[97m" # Green with white text
    ;;
    BLUE)
        color="\033[44m\033[97m" # Blue with white text
    ;;
    YELLOW)
        color="\033[42m\033[97m" # Yellow with white text
    ;;
    MAGENTA)
        color="\033[45m\033[97m" # Magenta with white text
    ;;
    CYAN)
        color="\033[46m\033[97m" # Cyan with white text
    ;;
    *)
        color="\033[45m\033[97m" # Magenta with white text
    ;;
    esac
    

    # Get the lenghth of text string
    # Divide 74 by the length.
    # Divide it in half.
    n=${#text}
    l=$(( length - n  )) 
    d=$(( l / 2 ))

    declare padding
    for i in $(seq 1 ${d}); do padding+=" "; done;

    echo
    echo -e "${color}${padding}${text}${padding}${reset}"
    echo
}

# EXAMPLES -------------------------------------------------------------------------

# Heading example
heading green "A Green Heading"

# Just add the color variable in front of text you'd like colored, and the reset
# variable where you want the color to end. Make sure that echo statements are
# executable via the -e flag. Example:

echo -e "${RED}This is red text.${RST}...and...${YEL}this is yellow text.${RST}"
echo