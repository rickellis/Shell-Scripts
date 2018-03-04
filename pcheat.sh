#!/usr/bin/env bash
#-----------------------------------------------------------------------------------
#            _             _   
#   _ __  __| |_  ___ __ _| |_ 
#  | '_ \/ _| ' \/ -_) _` |  _|
#  | .__/\__|_||_\___\__,_|\__|
#  |_|        pacmam cheatsheet   
#
#-----------------------------------------------------------------------------------
# VERSION="1.0.1"
#-----------------------------------------------------------------------------------
#
# Shows a list of pacman commands
#
#-----------------------------------------------------------------------------------
# Author:   Rick Ellis
# URL:      https://github.com/rickellis/Shell-Scripts/pcheat.sh
# License:  MIT
#-----------------------------------------------------------------------------------

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

        echo " Search for packages that contain a keyword"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Ss${r} ${cyn}keyword${r}"
        echo
        echo " Search for package name that begins with a keyword"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Ss${r} ${yel}'^${r}${cyn}keyword${r}${yel}'${r}"
        echo
        echo " Show detailed information about a package"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Si${r} ${cyn}package-name${r}"

        _search=true
    fi
}

#-----------------------------------------------------------------------------------

query() {

    if [ $_query == false ]; then

        heading olive "SEARCH LOCAL PACKAGES"
        
        echo " Show all installed packages"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Qs${r}"
        echo
        echo " Search for installed packages that contain a keyword"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Qs${r} ${cyn}keyword${r}"
        echo
        echo " Show detailed information about an installed package"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Qi${r} ${cyn}package-name${r}"
        echo
        echo "Show all files installed by a package"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Ql${r} ${cyn}package-name${r}"
        echo
        echo " List all packages that are out of date"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Qu${r}"
        echo
        echo " List all foreign (AUR) packages and include version info"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Qm${r}"
        echo
        echo " List all foreign (AUR) packages - name only"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Qmq${r}"
        echo
        echo " Create a file with all installed pckages including AUR"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Qqe ${yel}>${r}${r} ${cyn}/path/to/pkglist.txt${r}"

        _query=true
    fi                
}

#-----------------------------------------------------------------------------------

files() {

    if [ $_files == false ]; then

        heading blue "SEARCH FILES"

        echo " Search for package filenames that contain a keyword"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Fs${r} ${cyn}keyword${r}"
        echo
        echo " Show all files installed by a remote package"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Fl${r} ${cyn}package-name${r}"
        echo
        echo " Show which remote package a file belongs to"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Fo${r} ${cyn}/path/to/file_name${r}"

        _files=true
    fi
}

#-----------------------------------------------------------------------------------

sync() {

    if [ $_sync == false ]; then
    
        heading purple "SYNC COMMANDS"

        echo " Install a package"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -S${r} ${cyn}package-name${r}"
        echo
        echo " Update all installed packages and sync and refresh database"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Syu${r}"
        echo
        echo " Sync and refresh the pacman database"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Sy${r}"
        echo
        echo " Sync and FORCE refresh the pacman database. Be careful!"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Syy${r}"
        echo
        echo " Download a package but do not install it"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Sw${r} ${cyn}package-name${r}"
        echo
        echo " Install a local package"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -U${r} ${cyn}/path/to/package.pkg.tar.xz${r}"
        echo
        echo " Clear caches (run this periodically)"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Scc${r}"

        _sync=true
    fi
}

#-----------------------------------------------------------------------------------

remove() {

    if [ $_remove == false ]; then

        heading red "REMOVE"

        echo " Remove a package and leave all dependencies installed"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -R${r} ${cyn}package-name${r}"
        echo
        echo " Remove a package and dependencies not needed by other packages"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Rs${r} ${cyn}package-name${r}"
        echo
        echo " Remove a package and its config files"
        echo
        echo -e "    ${yel}\$${r}   ${grn}pacman -Rc${r} ${cyn}package-name${r}"
        echo
        echo " Remove a package, dependencies, and config files"
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
