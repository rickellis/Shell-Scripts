#!/usr/bin/env bash
#-----------------------------------------------------------------------------------
#      _               _    _        _ 
#   __| |___ __ _ _ _ | |__(_)_ _ __| |
#  / _| / -_) _` | ' \| '_ \ | '_/ _` |
#  \__|_\___\__,_|_||_|_.__/_|_| \__,_|
#  recursive directory git pull
#-----------------------------------------------------------------------------------
VERSION="1.0.0"
#-----------------------------------------------------------------------------------
#
# This script will recursively traverse all directories under a specified folder 
# and do git pull
#
# Usage: cleanbird.sh /path/to/folder
#
#-----------------------------------------------------------------------------------
# Author        :  Rick Ellis          https://github.com/rickellis
#               :
# Source URL    :  https://github.com/rickellis/Shell-Scripts/dirtybird.sh
# License       :  MIT
#-----------------------------------------------------------------------------------

# Path you want checked if script is called with no path argument.
# If this is left blank then the present working directory will be used.
SEARCHPATH=""

# Put directories you want ignored by this script into this array. Can be a
# name or a path. Paths are relative to the parent directory.
# Do not use a full path or a leading or trailing slash
# 
# EXAMPLE:  IGNORE=('Third-Party' 'Utilites/Server/Setup')
#
# NOTE: Only directories are ignored, not paths to individual files.
#
IGNORE=('Third-Party')

# Load colors.sh script to display pretty headings and colored text
# This is an optional (but recommended) dependency
BASEPATH=$(dirname "$0")
if [[ -f "${BASEPATH}/colors.sh" ]]; then
    . "${BASEPATH}/colors.sh"
else
    heading() {
        echo "---------------------------------------------------------------------"
        echo "  $2"
        echo "---------------------------------------------------------------------"
        echo
    }
fi

clear
heading green "CleanBird ${VERSION}"

# Set the search path
if [[ -z "$1" ]]; then
    if [[ -z $SEARCHPATH ]]; then
        SEARCHPATH=$PWD
    fi
else
    if [[ $1 == '-p' ]]; then
        SEARCHPATH=$PWD
    else
        SEARCHPATH="$1"
    fi
fi

if [[ ! -d "$SEARCHPATH" ]]; then
    echo " The supplied path does not resolve to a valid directory"
    echo
    echo " Aborting..."
    echo
    exit 1
fi

cd "$SEARCHPATH"

# Preserve the old input field separator
OLDIFS=$IFS
# Change the input field separator from a space to a null
IFS=$'\n'

# Find all directories that have a .git directory in them
found_dirty=0
dir_count=0
for gitprojpath in `find . -type d -name .git | sort | sed "s/\/\.git//"`; do

    # Are there any directories that need to be ignored?
    if [ "${#IGNORE}" -gt 0 ]; then
        
        # Remove leading dot-slash from path
        localpath=${gitprojpath:2}

        # Extract the first segment
        pathseg1=$(echo "$localpath" | sed "s/[\/].*//")

        # Do we have a match?
        for dir in ${IGNORE[@]}; do
            if [ "$localpath" == "$dir" ] || [ "$pathseg1" == "$dir" ]; then
                continue 2
            fi
        done
    fi

    (( dir_count++))

    # Save the current working directory before CDing
    pushd . >/dev/null
    cd $gitprojpath

        # Print the  directory name
    if [[ $gitprojpath == '.' ]]; then
        echo -e "${yellow}${PWD##*/}${reset}"
    else
        echo -e "${yellow}${gitprojpath:2}${reset}"
    fi

    # git pull >/dev/null 2>&1
    git pull

    echo

    # Return to the starting directory
    popd >/dev/null
done

echo "DIRECTORIES CHECKED: $dir_count"
echo

# Restore original state
IFS=$OLDIFS
