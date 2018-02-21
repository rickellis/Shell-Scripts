#!/usr/bin/env bash
#-----------------------------------------------------------------------------------
#       _  _             _ _           
#    __| || |___ __ _ __| (_)_ _  __ _ 
#   (_-< __ / -_) _` / _` | | ' \/ _` |
#   /__/_||_\___\__,_\__,_|_|_||_\__, |
#      Shell Heading Generator   |___/ 
#
#-----------------------------------------------------------------------------------
VERSION="1.2.6"
#-----------------------------------------------------------------------------------
#
# Generates a heading with the specified background color. The heading will span the
# entire width of the terminal regardless of size.Can also randomly select BG color.
#
#-----------------------------------------------------------------------------------
# Author:   Rick Ellis
# URL:      https://github.com/rickellis/Shell-Scripts/sHeading.sh
# License:  MIT
#-----------------------------------------------------------------------------------
#
# USAGE:
#
#   sheading <color> "Heading Text"  # Specific color
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
# sheading mag "Magenta"3
# sheading pur "Purple"
#
#-----------------------------------------------------------------------------------

sheading() {

    if [ -z "$1" ] || [ -z "$2" ]; then
        echo 'Usage: heading <color> "Heading Text"'
        exit 1
    fi

    color=${1,,}        # lowercase
    hding=${2}          # Capture heading
    hdlen=${#hding}     # heading length
    twidt=$(tput cols)  # terminal width

    # Set the minimum width to match length of the heading
    if [ ! $twidt -gt $hdlen ]; then
        twidt=$hdlen
    fi

    # Calculate the padding necessary on either side of the heading
    l=$(( twidt - hdlen )) 
    d=$(( l / 2 ))

    padding=""
    for i in $(seq 1 ${d}); do 
        padding+=" "
    done

    # Thanks to Bash's auto-rounding, depending on the length of the
    # terminal relative to the length of the heading we might end up
    # one character off. To compensate we add one space if necessary
    padextra=""
    padlenth=${#padding}
    totlenth=$(( padlenth * 2 + hdlen ))
    if [ $twidt -ne $totlenth ]; then
        padextra=" ";
    fi

    # Random color generator
    if [ "$color" == 'rnd' ] || [ "$color" == "rand" ] || [ "$color" == "random" ]; then
        colors=(   
                    "gry" 
                    "chr"
                    "red"
                    "grn"
                    "lim"
                    "aqm"
                    "olv"
                    "blu"
                    "sky"
                    "cyn"
                    "aqa"
                    "gdr"
                    "yel"
                    "crl"
                    "org"
                    "pnk"
                    "lav"
                    "mag" 
                    "pur"
                )

        color=${colors[$RANDOM % ${#colors[@]}]}
    fi

    # White text: \e[97m
    # Black text: \e[38;5;232m

    case "$color" in
        grey | gry)         color="\e[48;5;240m\e[97m"            ;;
        charcoal | chr)     color="\e[48;5;237m\e[97m"            ;;
        red)                color="\e[48;5;1m\e[97m"              ;;
        green | grn)        color="\e[48;5;22m\e[97m"             ;;
        lime | lim)         color="\e[48;5;40m\e[38;5;232m"       ;;
        aquamarine | aqm)   color="\e[48;5;120m\e[38;5;232m"      ;;
        olive | olv)        color="\e[48;5;58m\e[97m"             ;;
        blue | blu)         color="\e[44m\e[97m"                  ;;
        sky)                color="\e[48;5;25m\e[97m"             ;;
        cyan | cyn)         color="\e[46m\e[97m"                  ;;
        aqua | aqa)         color="\e[48;5;87m\e[38;5;232m"       ;;
        goldenrod | gdr)    color="\e[48;5;220m\e[38;5;232m"      ;;
        yellow | yel)       color="\e[48;5;11m\e[38;5;232m"       ;;
        coral| crl)         color="\e[48;5;3m\e[97m"              ;;
        orange | org)       color="\e[48;5;202m\e[97m"            ;;
        pink | pnk)         color="\e[48;5;200m\e[97m"            ;;
        lavender | lav)     color="\e[48;5;141m\e[38;5;232m"      ;;
        magenta | mag)      color="\e[45m\e[97m"                  ;;
        purple | pur)       color="\e[48;5;53m\e[97m"             ;;
        *)                  color="\e[48;5;237m\e[97m"            ;;
    esac

    echo
    echo -e "${color}${padding}${hding}${padding}${padextra}\e[0m"
    echo
}

# EXAMPLES -------------------------------------------------------------------------

sheading rnd "Random"
sheading gry "Grey"
sheading chr "Charcoal"
sheading red "Red"
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
