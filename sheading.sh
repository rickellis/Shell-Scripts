#!/usr/bin/env bash
#-----------------------------------------------------------------------------------
#       _  _             _ _           
#    __| || |___ __ _ __| (_)_ _  __ _ 
#   (_-< __ / -_) _` / _` | | ' \/ _` |
#   /__/_||_\___\__,_\__,_|_|_||_\__, |
#  Shell Color Heading Generator |___/ 
#
#-----------------------------------------------------------------------------------
VERSION="1.2.0"
#-----------------------------------------------------------------------------------
#
# Generates a heading with the specified background color and white text. 
# The heading will span the entire width of the terminal regardless of size.
# The random version of the function will use a randomly selected color background
#
#-----------------------------------------------------------------------------------
# Author:   Rick Ellis
# URL:      https://github.com/rickellis/Shell-Scripts/sHeading.sh
# License:  MIT
#-----------------------------------------------------------------------------------
#
# USAGE: 
#
#       heading <color> "Heading Text"  # Color specified
#
#       rheading "Heading Text"  # Color selected at random
#
# Colors choices:
#
# grey charcoal red green olive blue sky yellow coral orange pink magenta purple cyan 
#
#-----------------------------------------------------------------------------------

# Generates a random background color heading
function rheading() {
    if [ -z "$1" ]; then
        echo 'Usage: rheading  "My great heading"'
        exit 1
    fi
    _colors=( grey charcoal red green olive blue sky yellow coral orange pink magenta purple cyan )
    color=${_colors[$RANDOM % ${#_colors[@]} ]}
    heading "$color" "$1"
}

#-----------------------------------------------------------------------------------

# Generates heading with a background color and white text, centered.
function heading() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo 'Usage: heading <color> "My cool heading"'
        exit 1
    fi

    color=${1}
    color=${color,,} # Lowercase the color
    text=${2}
    reset="\033[0m"

    # Width of the terminal
    twidth=$(tput cols) 
    # Length of the header string
    hlength=${#text}

    # Set a minimum with for the background
    if [ ! $twidth -gt $hlength ]; then
        twidth=$hlength
    fi

    # Subtract header string from terminal width
    # Divide that number in half. This becomes
    # the padding on either side of the header
    l=$(( twidth - hlength )) 
    d=$(( l / 2 ))

    declare padding
    for i in $(seq 1 ${d}); do padding+=" "; done;

    case "$color" in
    grey | gry)
        color="\033[48;5;240m\033[97m"
    ;;
    charcoal | chr)
        color="\033[48;5;237m\033[97m"
    ;;
    red)
        color="\033[48;5;1m\033[97m"
    ;;
    green | grn)
        color="\033[48;5;22m\033[97m"
    ;;
    olive | olv)
        color="\033[48;5;58m\033[97m"
    ;;
    blue | blu)
        color="\033[44m\033[97m"
    ;;
    sky)
        color="\033[48;5;25m\033[97m"
    ;;
    yellow | yel)
        color="\033[42m\033[97m"
    ;;
    coral| crl)
        color="\033[48;5;3m\033[97m"
    ;;
    orange | org)
        color="\033[48;5;202m\033[97m"
    ;;
    pink | pnk)
        color="\033[48;5;207m\033[97m"
    ;;
    magenta | mag)
        color="\033[45m\033[97m"
    ;;
    purple | pur)
        color="\033[48;5;53m"
    ;;
    cyan | cyn)
        color="\033[46m\033[97m"
    ;;
    *)
        color="\033[45m\033[97m"
    ;;
    esac
    echo
    echo -e "${color}${padding}${text}${padding}${reset}"
    echo
}

# EXAMPLE --------------------------------------------------------------------------

rheading "My Heading"