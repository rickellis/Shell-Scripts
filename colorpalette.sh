#!/usr/bin/env bash
#-----------------------------------------------------------------------------------
#          _                    _     _   _ 
#   __ ___| |___ _ _ _ __  __ _| |___| |_| |_ ___ 
#  / _/ _ \ / _ \ '_| '_ \/ _` | / -_)  _|  _/ -_)
#  \__\___/_\___/_| | .__/\__,_|_\___|\__|\__\___|
#                   |_|     Colorpalette Generator
#
#-----------------------------------------------------------------------------------
VERSION="1.0.2"
#-----------------------------------------------------------------------------------
#
# This script creates a PNG image containing the most common colors found in an image
#
# Usage: Open a terminal and execute this script. You'll be prompted for the rest.
#
#-----------------------------------------------------------------------------------
# Author:       Rick Ellis
# URL:          https://github.com/rickellis/Shell-Scripts
# License:      MIT
# Dependencies: ImageMagick
#-----------------------------------------------------------------------------------


# Basepath to the directory containing this script.
BASEPATH=$(dirname "$0")
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
heading green "Colorpalette Generator ${VERSION}"

echo "Enter the path to the source image:"
read source

if [[ $source == "" ]]; then
    echo "No source image supplied. Aborting..."
	exit 1
fi

# Does the source image exist?
if  ! [[ -f $source ]]; then
    echo "The supplied image path is not valid. Aborting..."
    exit 1
fi

# DESTINATION DIRECTORY -----------------------------------------------------------------

echo
echo "Enter the path to the destination directory:"
read destination

if [[ $destination == "" ]]; then
    echo "No destination directory supplied. Aborting..."
	exit 1
fi

# Remove the trailing slash if it was submitted
if [[ $destination =~ .*/$ ]]; then
    destination="${destination:0:-1}"
fi

# Does the destination directory exist?
if  ! [[ -d $destination ]]; then
    echo "The supplied destination path does not exist. Aborting..."
    exit 1
fi

# Build the path to the final image
destination="${destination}/colorpalette.png"

# COLORS --------------------------------------------------------------------------------

echo
echo "How many colors would you like in the palette?"
read colors

# Is the values an integers?
if ! [[ $colors =~ ^[0-9]+$ ]]; then 
    echo "Not a valid number. Aborting..."
    exit 1
fi

# WIDTH ---------------------------------------------------------------------------------

echo
echo "How wide (in pixels) do you want the image to be?"
read width

# Remove "px" from the size in the event the user included it:
width="${width//px/}"

# Is the width value an integers?
if ! [[ $width =~ ^[0-9]+$ ]]; then 
    echo "Not a valid size. Aborting..."
    exit 1
fi

# RENDER --------------------------------------------------------------------------------

# Use ImageMagick to create the colorpalette
convert ${source} \
+dither \
-colors ${colors} \
-unique-colors \
-filter box \
-geometry ${width} \
${destination} >/dev/null 2>&1 || { echo "An error was encountered. Aborting..."; exit 1; }

# SUCCESS -------------------------------------------------------------------------------

echo
echo "Your image has been generated at:"
echo "$destination"
echo