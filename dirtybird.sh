#!/usr/bin/env bash
#-----------------------------------------------------------------------------------
#      _ _     _        _    _        _ 
#   __| (_)_ _| |_ _  _| |__(_)_ _ __| |
#  / _` | | '_|  _| || | '_ \ | '_/ _` |
#  \__,_|_|_|  \__|\_, |_.__/_|_| \__,_|
#                  |__/ 
#  recursive directory git status check
#-----------------------------------------------------------------------------------
VERSION="1.0.0"
#-----------------------------------------------------------------------------------
#
# This script will recursively traverse all directories under a specified folder 
# and display the names of any dirty files under git control.
#
# Usage: dirtybird.sh /path/to/root/directory
#
#-----------------------------------------------------------------------------------
# Author        :  Rick Ellis          https://github.com/rickellis
#               :  Matthew McCullough  https://github.com/matthewmccullough
#               :
# Source URL    :  https://github.com/rickellis/Shell-Scripts/dirtybird.sh
# License       :  MIT
#-----------------------------------------------------------------------------------

# Basepath to the directory containing the various assets.
# This allows the basepath to be correct if this script gets aliased in .bashrc
BASEPATH=$(dirname -- $(readlink -fn -- "$0"))

# Load colors script to display pretty headings and colored text
# This is an optional (but recommended) dependency
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
heading green "dirtybird ${VERSION}"

# Define the search path. If a path was passed via an argument
# to the script we use it. Otherwise, we use the user's home folder
searchpath="$HOME"
if [ ! -z "$1" ]; then
    searchpath="$1"
    if [ ! -d "$searchpath" ]; then
        echo " The supplied path does not resolve to a valid directory"
        echo
        echo " Aborting..."
        echo
        exit 1
    fi
    cd "$searchpath"
fi

# Preserve the old input field separator
OLDIFS=$IFS
# Change the input field separator from a space to a null
IFS=$'\n'

# Find all directories that have a .git directory in them
found_dirty=0
for gitprojpath in `find . -type d -name .git | sort | sed "s/\/\.git//"`; do

    # Save the current working directory before CDing
    pushd . >/dev/null
    cd $gitprojpath
  
  # Are there any changed files in the status output?
  isdirty=$(git status -s )
  
    if [ -n "$isdirty" ]; then
        found_dirty=1

        gitstatus=$(git status -s | grep "^.*")

        # Print the dirty directory name
        echo "${gitprojpath:2}"

        # Cycle through all files, align and colorize them
        for stati in ${gitstatus[@]}; do

            status=${stati:0:2}
            status=${status// /}
            filename=${stati:3}
            filename=${filename// /}

            case $status in 
                M)      color="${yellow}"   ;;
                A)      color="${green}"    ;;
                D)      color="${red}"      ;;
                R)      color="${cyan}"     ;;
                C)      color="${mag}"      ;;
                U)      color="${blue}"     ;;
                \?*)    color="${grey}"     ;;
                *)      color="${orange}"   ;;
            esac

            if [ "${#status}" == 1 ]; then padding=" "; else padding=""; fi

            echo -e " ${color}${status}${padding} ${filename}${r}"

        done
        echo
    fi

    # Return to the starting directory
    popd >/dev/null
done

if [ "$found_dirty" == 0 ]; then
    echo -e " All repositories are clean!"
    echo
else
    heading sky "CODES"
    echo -e " ${yellow}M${r}  = Modified"
    echo -e " ${green}A${r}  = Added"
    echo -e " ${red}D${r}  = Deleted"
    echo -e " ${cyan}R${r}  = Renamed"
    echo -e " ${mag}C${r}  = Copied"
    echo -e " ${blue}U${r}  = Updated but unmerged"
    echo -e " ${orange}XY${r} = Multi-status"
    echo -e " ${grey}??${r} = Untracked"
    echo    
fi

# restore the input field separator
IFS=$OLDIFS
