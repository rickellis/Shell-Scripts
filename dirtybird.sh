#!/usr/bin/env bash
#-----------------------------------------------------------------------------------
#      _ _     _        _    _        _ 
#   __| (_)_ _| |_ _  _| |__(_)_ _ __| |
#  / _` | | '_|  _| || | '_ \ | '_/ _` |
#  \__,_|_|_|  \__|\_, |_.__/_|_| \__,_|
#                  |__/ 
#  recursive directory git status check
#-----------------------------------------------------------------------------------
VERSION="1.2.0"
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
heading green "DirtyBird ${VERSION}"

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
  
    # Are there any changed files in the status output?
    isdirty=$(git status -s )
  
    if [ -n "$isdirty" ]; then
        found_dirty=1

        # Clean up the git status
        gitstatus=$(git status -s | grep "^.*")

        # Print the dirty directory name
        if [[ $gitprojpath == '.' ]]; then
            echo "${PWD##*/}"
        else
            echo "${gitprojpath:2}"
        fi

        # Cycle through the git status result, then align and colorize it
        for stati in ${gitstatus[@]}; do

            # Extract the status and filename so we can handled them independently
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

            # Since the git result code can be one or two characters
            # we pad single characters so our alignment is correct
            if [ "${#status}" == 1 ]; then padding=" "; else padding=""; fi

            # Print the result
            echo -e " ${color}${status}${padding} ${filename}${r}"

        done
        echo
    fi

    # Return to the starting directory
    popd >/dev/null
done

echo "DIRECTORIES CHECKED: $dir_count"

if [[ "$found_dirty" == 0 ]]; then

    if [[ $dir_count -eq 1 ]]; then
        echo -e " ${green}Repository is clean!${reset}"
    else
        echo -e " ${green}All repositories are clean!${reset}"
    fi
    echo
else
    heading sky "GIT CODES"
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

# Restore original state
IFS=$OLDIFS
