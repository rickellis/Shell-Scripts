#!/usr/bin/env bash
#-----------------------------------------------------------------------------------
#            _             _   
#   _ __  __| |_  ___ __ _| |_ 
#  | '_ \/ _| ' \/ -_) _` |  _|
#  | .__/\__|_||_\___\__,_|\__|
#  |_|        pacmam cheatsheet   
#
#-----------------------------------------------------------------------------------
# VERSION="1.0.0"
#-----------------------------------------------------------------------------------
#
# Shows a list of pacman commands
#
#-----------------------------------------------------------------------------------
# Author:   Rick Ellis
# URL:      https://github.com/rickellis/Shell-Scripts/pcheat.sh
# License:  MIT
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
        echo " $2"
        echo " ----------------------------------------------------------------------"
        echo
    }
fi

# These ensure we only show each category of commands once
_sync=false
_search=false
_query=false
_files=false
_remove=false

# Capture the argument string
args=$@

#-----------------------------------------------------------------------------------

help(){

    heading green "HELP" 
    
    echo " To show all commands"
    echo
    echo -e "    ${yel}\$${r}   ${grn}pcheat${r}"
    echo
    echo " To show sync commands"
    echo
    echo -e "    ${yel}\$${r}   ${grn}pcheat -s${r}"
    echo 
    echo " To show remote search commands"
    echo
    echo -e "    ${yel}\$${r}   ${grn}pcheat -r${r}"
    echo 
    echo " To show local query commands"
    echo
    echo -e "    ${yel}\$${r}   ${grn}pcheat -q${r}"
    echo 
    echo " To show file commands"
    echo
    echo -e "    ${yel}\$${r}   ${grn}pcheat -f${r}"
    echo 
    echo " To show remove commands"
    echo
    echo -e "    ${yel}\$${r}   ${grn}pcheat -x${r}"
    echo 
    echo " Arguments can be combined"
    echo
    echo -e "    ${yel}\$${r}   ${grn}pcheat -srqfx${r}"
    echo
    exit 1
}

#-----------------------------------------------------------------------------------

search() {

    if [ $_search == false ]; then
    
        heading green "SEARCH REMOTE PACKAGES"

        echo -e " Search for packages that contain a keyword"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Ss${r} ${cyn}keyword${r}"
        echo
        echo -e " Search for package name that begins with a keyword"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Ss${r} ${yel}'^${r}${cyn}keyword${r}${yel}'${r}"
        echo
        echo -e " Show detailed information about a package"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Si${r} ${cyn}package-name${r}"

        _search=true
    fi
}

#-----------------------------------------------------------------------------------

query() {

    if [ $_query == false ]; then

        heading olive "SEARCH LOCAL PACKAGES"
        
        echo -e " Show all installed packages"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Qs${r}"
        echo
        echo -e " Search for installed packages that contain a keyword"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Qs${r} ${cyn}keyword${r}"
        echo
        echo -e " Show detailed information about an installed package"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Qi${r} ${cyn}package-name${r}"
        echo
        echo -e " Show all files installed by a package"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Ql${r} ${cyn}package-name${r}"
        echo
        echo -e " List all packages that are out of date"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Qu${r}"
        echo
        echo -e " Create a file with all installed pckages including AUR"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Qqe ${yel}>${r}${r} ${cyn}/path/to/pkglist.txt${r}"

        _query=true
    fi                
}

#-----------------------------------------------------------------------------------

files() {

    if [ $_files == false ]; then

        heading blue "SEARCH FILES"

        echo -e " Search for package filenames that contain a keyword"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Fs${r} ${cyn}keyword${r}"
        echo
        echo -e " Show all files installed by a remote package"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Fl${r} ${cyn}package-name${r}"
        echo
        echo -e " Show which remote package a file belongs to"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Fo${r} ${cyn}/path/to/file_name${r}"

        _files=true
    fi
}

#-----------------------------------------------------------------------------------

sync() {

    if [ $_sync == false ]; then
    
        heading purple "SYNC COMMANDS"

        echo -e " Install a package"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -S${r} ${cyn}package-name${r}"
        echo
        echo -e " Update all installed packages and sync and refresh database"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Syu${r}"
        echo
        echo -e " Sync and refresh the pacman database"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Sy${r}"
        echo
        echo -e " Sync and FORE refresh the pacman database. Be careful!"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Syy${r}"
        echo
        echo -e " Download a package but do not install it"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Sw${r} ${cyn}package-name${r}"
        echo
        echo -e " Install a local package"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -U${r} ${cyn}/path/to/package.pkg.tar.xz${r}"
        echo
        echo -e " Clear caches (run this periodically)"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Scc${r}"

        _sync=true
    fi
}

#-----------------------------------------------------------------------------------

remove() {

    if [ $_remove == false ]; then

        heading red "REMOVE"

        echo -e " Remove a package and leave all dependencies installed"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -R${r} ${cyn}package-name${r}"
        echo
        echo -e " Remove a package and dependencies not needed by other packages"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Rs${r} ${cyn}package-name${r}"
        echo
        echo -e " Remove a package and its config files"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Rc${r} ${cyn}package-name${r}"
        echo
        echo -e " Remove a package, dependencies, and config files"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Rsc${r} ${cyn}package-name${r}"

        _remove=true
    fi
}

#-----------------------------------------------------------------------------------

# GENERATE OUTPUT
clear


# No arguments, we show all
if [ -z "$args" ]; then
    sync
    search
    query
    files
    remove
    echo
    exit 1
fi

args=${args,,}    # lowercase
args=${args// /}  # remove spaces
args=${args//-/}  # remove dashes

# Help menu
if [[ $args =~ [h] ]] ; then
    help
fi

# Invalid arguments trigger help
if [[ $args =~ [^srqfx] ]]; then
    help
fi

# Explode the characters into an array
args=$(echo $args | grep -o .)

# Show specific request
for arg in ${args[@]}; do
    case "$arg" in
        s)  sync    ;;
        r)  search  ;;
        q)  query   ;;
        f)  files   ;;
        x)  remove  ;;
        *)  help    ;;
    esac
done

echo
