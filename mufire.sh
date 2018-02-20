#!/usr/bin/env bash
#-----------------------------------------------------------------------------------
#              __ _         
#   _ __ _  _ / _(_)_ _ ___ 
#  | '  \ || |  _| | '_/ -_)
#  |_|_|_\_,_|_| |_|_| \___| 
#          Multifile Rename
#-----------------------------------------------------------------------------------
VERSION="1.2.3"
#-----------------------------------------------------------------------------------
#
# Allows batch file renaming. This function is not recursive, so only the files in the
# parent directory get renamed (folders are skipped). You will be prompted to specify
# the name you would like the files to be renamed to, and the starting number of the 
# incrementing counter.
# 
# Usage:
#
# cd into the directory containing files you want to rename, then execute mufire.sh
#
# /path/to/mufire.sh
#
#-----------------------------------------------------------------------------------
# Author:       Rick Ellis
# URL:          https://github.com/rickellis/Shell-Scripts
# License:      MIT
#-----------------------------------------------------------------------------------


_currentdir=$(pwd)
_tempname="TMP129384756XYZ"


# Colors
WHT="\033[97m"
BGRN="\033[42m"
RST="\033[0m"

# HEADING -------------------------------------------------------------------------------

# Generates heading with a background color and white text, centered.
function sheading() {
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

    # Depending on the length of the terminal relative to the length
    # of the heading text we might end up one character off in our length. 
    # To compensate we add a one space to the right padding.
    padl=$padding
    padr=$padding
    plen=${#padding}
    nlength=$(( plen * 2 + hlength ))
    if [ $twidth -ne $nlength ]; then
        padr+=" ";
    fi

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
    echo -e "${color}${padl}${text}${padr}${reset}"
    echo
}




clear
echo
sheading green "Multi-File Rename VERSION ${VERSION}"
echo
echo


echo " You are in the following directory:"
echo
echo " ${_currentdir}"
echo
read -p " Do you want to rename the files in this directory? [y|n] " _consent

if [[ $_consent != "" ]] && [[ $_consent != "y" ]] && [[ $_consent != 'Y' ]]; then
    echo
    echo " Goodbye..."
    echo
    exit 1
fi

if [ -z "$(ls -A ${_currentdir})" ]; then
    echo
    echo " The directory you have specified is empty. Aborting..."
    echo
    exit 1
fi

echo
read -p " What would you like the new file name to be? " _newname

if [[ -z $_newname ]]; then
    echo " New name is required. Aborting..."
    exit 1
fi

echo
read -p " What should the starting number be? " _startn

if ! echo $_startn | egrep -q '^[0-9]+$'; then
    echo " Invalid number. Aborting..."
    exit 1
fi

# Performs the file renaming
function rename() {

    # $1 = the source directory
    # $2 = the new file name
    # $3 = the starting number
    if [ -z $1 ] ||[ -z $2 ] || [ -z $3 ]; then
        echo " The rename function requires three arguments: source dir, new filename, starting n."
        exit 1
    fi

    # Set the result code. This determines whether we show a message at the end.
    result=1
    if [ -z $4 ]; then
        result=0
    elif [ $4 -eq "0" ] || [ $4 -eq "1" ]; then
        result=$4
    fi

    # set these for clarity
    sourcedir=$1
    newname=$2
    i=$3
    n=0

    # Here we go!...
    j="$_startn"
    for filepath in `ls -v` "$sourcedir"/*
        do

        # Is the current filename acutally a file?
        if [[ -f $filepath ]]; then

            # extract the filename from the path
            filename="${filepath##*/}"

            # skip dotfiles
            if echo $filename | egrep -q '^[.]'; then
                continue 2
            fi

            # extract the file extension    
            ext="${filename##*.}"

            # Show progress, but only on actual files, not temp ones
            if [ "${filename:0:15}" != "$_tempname" ]; then
                echo " ${filename} renamed to ${_newname}${j}.${ext}"
                ((j++))
            fi

            # rename the file
            mv "$filename" "${newname}${i}.${ext}"

            ((i++))
            ((n++))
        fi
    done

    if [[ $result -eq "1" ]]; then
        echo -e "\n ${n} files renamed!\n"
    fi
}

# Below we run the rename function twice.
# The first time sets the filename to a temporary string. The second time sets the new filename.
# Why do we do it in two passes? An earlier version of this script just skipped renaming any
# files that already had the new name. However, this created a couple problems. 1. the original
# sort order of the files wasn't retained. And 2. identically named files with different file
# extensions wouldn't get sequentially renamed. The simplest solution was to do it in two passes.
#
# Required arguments:
# $1 = the source directory
# $2 = the new file name
# $3 = the starting number
# $4 = whether to show renamed file count
rename "$_currentdir" "$_tempname" "1" "0"
rename "$_currentdir" "$_newname" "$_startn" "1"
