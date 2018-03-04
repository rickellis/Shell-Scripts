#!/usr/bin/env bash
#-----------------------------------------------------------------------------------
#              __ _         
#   _ __ _  _ / _(_)_ _ ___ 
#  | '  \ || |  _| | '_/ -_)
#  |_|_|_\_,_|_| |_|_| \___| 
#          Multifile Rename
#-----------------------------------------------------------------------------------
VERSION="1.2.4"
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

# Load colors script to display pretty headings and colored text
# This is an optional (but recommended) dependency
BASEPATH=$(dirname "$0")
if [ -f "${BASEPATH}/colors.sh" ]; then
    . "${BASEPATH}/colors.sh"
else
    heading() {
        echo " ----------------------------------------------------------------------"
        echo "  $2"
        echo " ----------------------------------------------------------------------"
        echo
    }
fi

clear
heading green "Multi-File Rename ${VERSION}"

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
