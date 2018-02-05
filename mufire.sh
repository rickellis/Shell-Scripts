#!/bin/bash
#----------------------------------------------------------------------------------------
#
# mufire.sh
#
# Version 1.2
#
# Multi File Rename with Incrementing Number
#
# by Rick Ellis
# https://github.com/rickellis
#
# License: MIT
#
# Allows batch file renaming. This function is not recursive, so only the files in the
# parent directory get renamed (folders are skipped). You will be prompted to specify
# the name you would like the files to be renamed to, and the starting number of the 
# incrementing counter.
#
# Usage: 
#
#   cd /directory/with/files-to-be-renamed
#
#   /path/to/mufire.sh
#
#----------------------------------------------------------------------------------------
# DO NOT JUST RUN THIS SCRIPT. EXAMINE THE CODE. UNDERSTAND IT. RUN IT AT YOUR OWN RISK.
#----------------------------------------------------------------------------------------

# Exit on error
set -e

_currentdir=$(pwd)
echo -e "\nYou are in: ${_currentdir}\n\nAre you sure you want to rename the files in this directory? [y|n]"
read _consent

if [[ $_consent != "" ]] && [[ $_consent != "y" ]] && [[ $_consent != 'Y' ]]; then
    echo "Aborting..."
    exit 1
fi

echo -e "\nWhat would you like the new file name to be?"
read _newname

if [[ -z $_newname ]]; then
    echo "New name is required."
    exit 1
fi

echo -e "\nWhat should the starting number be?"
read _startn

if ! echo $_startn | egrep -q '^[0-9]+$'; then
    echo "Invalid number."
    exit 1
fi

# Performs the file renaming
function rename() {

    # $1 = the source directory
    # $2 = the new file name
    # $3 = the starting number
    if [ -z $1 ] ||[ -z $2 ] || [ -z $3 ]; then
        echo "The rename function requires three arguments: source dir, new filename, starting n."
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
    n=1

    # Here we go!...
    for filepath in "$sourcedir"/*
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

            # rename the file
            mv "$filename" "${newname}${i}.${ext}"

            ((i++))
            ((n++))
        fi
    done

    if [[ $result -eq "1" ]]; then
        echo -e "\n${n} files renamed!\n"
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
rename "$_currentdir" "TMP129384756XYZ" "1" "0"
rename "$_currentdir" "$_newname" "$_startn" "1"
