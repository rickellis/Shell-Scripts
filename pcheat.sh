#!/usr/bin/env bash
#-----------------------------------------------------------------------------------
#            _             _   
#   _ __  __| |_  ___ __ _| |_ 
#  | '_ \/ _| ' \/ -_) _` |  _|
#  | .__/\__|_||_\___\__,_|\__|
#  |_|        pacmam cheatsheet   
#
#-----------------------------------------------------------------------------------
# VERSION="1.0.3"
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
    
    echo -e "${grn}pcheat${r}\t\t  # Show all commands"
    echo -e "${grn}pcheat${r}${yel} -s${r}\t  # Sync commands"
    echo -e "${grn}pcheat${r}${yel} -r${r}\t  # Remote search commands"
    echo -e "${grn}pcheat${r}${yel} -q${r}\t  # Local query commands"
    echo -e "${grn}pcheat${r}${yel} -f${r}\t  # File commands"
    echo -e "${grn}pcheat${r}${yel} -x${r}\t  # Remove commands"
    echo -e "${grn}pcheat${r}${yel} -srqfx${r}\t  # Arguments can be combined"
    echo
    exit 1
}

#-----------------------------------------------------------------------------------

search() {

    if [ $_search == false ]; then
    
        heading green "SEARCH REMOTE PACKAGES"

        echo -e "${grn}pacman${r}${yel} -Ss${r} ${cyn}keyword${r}\t  # Search for packages that contain a keyword"
        echo -e "${grn}pacman${r}${yel} -Ss${r} ${yel}'^${r}${cyn}keyword${r}${yel}'${r}\t  # Search for package name that begins with a keyword"
        echo -e "${grn}pacman${r}${yel} -Si${r} ${cyn}package-name${r}\t  # Show detailed information about a package"

        _search=true
    fi
}

#-----------------------------------------------------------------------------------

query() {

    if [ $_query == false ]; then

        heading olive "SEARCH LOCAL PACKAGES"
        
        echo -e "${grn}pacman${r}${yel} -Qs${r}\t\t  # Show all installed packages"
        echo -e "${grn}pacman${r}${yel} -Qs${r} ${cyn}keyword${r}\t  # Search for installed packages that contain a keyword"
        echo -e "${grn}pacman${r}${yel} -Qi${r} ${cyn}package-name${r}\t  # Show detailed information about an installed package"
        echo -e "${grn}pacman${r}${yel} -Ql${r} ${cyn}package-name${r}\t  # Show all files installed by a package"
        echo -e "${grn}pacman${r}${yel} -Qu${r}\t\t  # List all packages that are out of date"
        echo -e "${grn}pacman${r}${yel} -Qm${r}\t\t  # List all foreign (AUR) packages and include version info"
        echo -e "${grn}pacman${r}${yel} -Qmq${r}\t\t  # List all foreign (AUR) packages - name only"
        echo -e "${grn}pacman${r}${yel} -Qqe ${yel}>${r}${r} ${cyn}pkglist.txt${r} # Create a file with all installed pckages including AUR"

        _query=true
    fi                
}

#-----------------------------------------------------------------------------------

files() {

    if [ $_files == false ]; then

        heading blue "SEARCH FILES"

        echo -e "${grn}pacman${r}${yel} -Fs${r} ${cyn}keyword${r}\t  # Search for package filenames that contain a keyword"
        echo -e "${grn}pacman${r}${yel} -Fl${r} ${cyn}package-name${r}\t  # Show all files installed by a remote package"
        echo -e "${grn}pacman${r}${yel} -Fo${r} ${cyn}/path/filename${r} # Show which remote package a file belongs to"

        _files=true
    fi
}

#-----------------------------------------------------------------------------------

sync() {

    if [ $_sync == false ]; then
    
        heading purple "SYNC COMMANDS"

        echo -e "${grn}pacman${r}${yel} -S${r} ${cyn}package-name${r}\t  # Install a package"
        echo -e "${grn}pacman${r}${yel} -Syu${r}\t\t  # Update all installed packages and sync and refresh database"
        echo -e "${grn}pacman${r}${yel} -Sy${r}\t\t  # Sync and refresh the pacman database"
        echo -e "${grn}pacman${r}${yel} -Syy${r}\t\t  # Sync and FORCE refresh the pacman database. Be careful!"
        echo -e "${grn}pacman${r}${yel} -Sw${r} ${cyn}package-name${r}\t  # Download a package but do not install it"
        echo -e "${grn}pacman${r}${yel} -U${r} ${cyn}/path/package.pkg.tar.xz${r} # Install a local package"
        echo -e "${grn}pacman${r}${yel} -Scc${r}\t\t  # Clear caches (run this periodically)"

        _sync=true
    fi
}

#-----------------------------------------------------------------------------------

remove() {

    if [ $_remove == false ]; then

        heading red "REMOVE"

        echo -e "${grn}pacman${r}${yel} -R${r}   ${cyn}package-name${r}  # Remove a package and leave all dependencies installed"
        echo -e "${grn}pacman${r}${yel} -Rs${r}  ${cyn}package-name${r}  # Remove a package and dependencies not needed by other packages"
        echo -e "${grn}pacman${r}${yel} -Rc${r}  ${cyn}package-name${r}  # Remove a package and its config files"
        echo -e "${grn}pacman${r}${yel} -Rsc${r} ${cyn}package-name${r}  # Remove a package, dependencies, and config files"

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
