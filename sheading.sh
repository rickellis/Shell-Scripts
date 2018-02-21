#!/usr/bin/env bash
#-----------------------------------------------------------------------------------
#       _  _             _ _           
#    __| || |___ __ _ __| (_)_ _  __ _ 
#   (_-< __ / -_) _` / _` | | ' \/ _` |
#   /__/_||_\___\__,_\__,_|_|_||_\__, |
#      Shell Heading Generator   |___/ 
#
#-----------------------------------------------------------------------------------
VERSION="1.2.5"
#-----------------------------------------------------------------------------------
#
# Generates a heading with the specified background color. 
# The heading will span the entire width of the terminal regardless of size.
# Can also randomly selectcolor background
#
#-----------------------------------------------------------------------------------
# Author:   Rick Ellis
# URL:      https://github.com/rickellis/Shell-Scripts/sHeading.sh
# License:  MIT
#-----------------------------------------------------------------------------------
#
# USAGE:
#
#   sheading <color> "Heading Text"  # Specifig color
#   sheading random  "Heading Text"  # Random color
#
# COLORS:
#
# sheading rnd "Random"
# sheading gry "Grey"
# sheading chr "Charcoal"
# sheading red "Red"
# sheading grn "Green"
# sheading lim "Lime"
# sheading aqm "Aquamarine"
# sheading olv "Olive"
# sheading blu "Blue"
# sheading sky "Sky"
# sheading cyn "Cyan"
# sheading aqa "Aqua"
# sheading gdr "Goldenrod"
# sheading yel "Yellow"
# sheading crl "Coral"
# sheading org "Orange"
# sheading pnk "Pink"
# sheading lav "Lavender"
# sheading mag "Magenta"
# sheading pur "Purple"
#
#-----------------------------------------------------------------------------------

function sheading() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo 'Usage: heading <color> "Heading Text"'
        exit 1
    fi

    _color=${1,,} # lowercase
    _heading=${2}
    _h_length=${#_heading} # heading length
    _t_width=$(tput cols)  # terminal width

    # Set the minimum width the length of the header string
    if [ ! $_t_width -gt $_h_length ]; then
        _t_width=$_h_length
    fi

    # Calculate the padding necessary on either side of the heading
    l=$(( _t_width - _h_length )) 
    d=$(( l / 2 ))

    _padding=""
    for i in $(seq 1 ${d}); do 
        _padding+=" "
    done

    # Depending on the length of the terminal relative to the
    # length of the heading we might end up one character off.
    # To compensate we add one space to the right side
    _padextra=""
    _padlenth=${#_padding}
    _totlenth=$(( _padlenth * 2 + _h_length ))

    if [ $_t_width -ne $_totlenth ]; then
        _padextra=" ";
    fi

    if [ "$_color" == 'rnd' ] || [ "$_color" == "rand" ] || [ "$_color" == "random" ]; then
        _colors=( "gry" "chr" "red" "grn" "lim" "aqm" "olv" "blu" "sky" "cyn" "aqa" "gdr" "yel" "crl" "org" "pnk" "lav" "mag" "pur" )
        _color=${_colors[$RANDOM % ${#_colors[@]}]}
    fi

    # Bold: \e[1m
    # White text \e[97m
    # Black text: \e[38;5;232m

    case "$_color" in
        grey | gry)         _color="\e[48;5;240m\e[1m\e[97m"            ;;
        charcoal | chr)     _color="\e[48;5;237m\e[1m\e[97m"            ;;
        red)                _color="\e[48;5;1m\e[1m\e[97m"              ;;
        green | grn)        _color="\e[48;5;22m\e[1m\e[97m"             ;;
        lime | lim)         _color="\e[48;5;40m\e[1m\e[38;5;232m"       ;;
        aquamarine | aqm)   _color="\e[48;5;120m\e[1m\e[38;5;232m"      ;;
        olive | olv)        _color="\e[48;5;58m\e[1m\e[97m"             ;;
        blue | blu)         _color="\e[44m\e[1m\e[97m"                  ;;
        sky)                _color="\e[48;5;25m\e[1m\e[97m"             ;;
        cyan | cyn)         _color="\e[46m\e[1m\e[97m"                  ;;
        aqua | aqa)         _color="\e[48;5;87m\e[1m\e[38;5;232m"       ;;
        goldenrod | gdr)    _color="\e[48;5;220m\e[1m\e[38;5;232m"      ;;
        yellow | yel)       _color="\e[48;5;11m\e[1m\e[38;5;232m"       ;;
        coral| crl)         _color="\e[48;5;3m\e[1m\e[97m"              ;;
        orange | org)       _color="\e[48;5;202m\e[1m\e[97m"            ;;
        pink | pnk)         _color="\e[48;5;200m\e[1m\e[97m"            ;;
        lavender | lav)     _color="\e[48;5;141m\e[1m\e[38;5;232m"      ;;
        magenta | mag)      _color="\e[45m\e[1m\e[97m"                  ;;
        purple | pur)       _color="\e[48;5;53m\e[1m\e[97m"             ;;
        *)                  _color="\e[48;5;237m\e[1m\e[97m"            ;;
    esac

    echo
    echo -e "${_color}${_padding}${_heading}${_padding}${_padextra}\e[0m"
    echo
}

# EXAMPLES -------------------------------------------------------------------------

sheading rnd "Random"
sheading gry "Grey"
sheading chr "Charcoal"
sheading RED "Red"
sheading grn "Green"
sheading lim "Lime"
sheading aqm "Aquamarine"
sheading olv "Olive"
sheading blu "Blue"
sheading sky "Sky"
sheading cyn "Cyan"
sheading aqa "Aqua"
sheading gdr "Goldenrod"
sheading yel "Yellow"
sheading crl "Coral"
sheading org "Orange"
sheading pnk "Pink"
sheading lav "Lavender"
sheading mag "Magenta"
sheading pur "Purple"
