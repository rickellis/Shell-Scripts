#!/bin/bash
#----------------------------------------------------------------------------------------
#
# colorpalette.sh
#
# Version 1.0
#
# This script creates a PNG image containing the most common colors found in an image
#
# Dependencies: ImageMagick
#
# by Rick Ellis
# https://github.com/rickellis
#
# License: MIT
#
# Usage: Open a terminal and execute this script. You'll be prompted for the rest.
#
#----------------------------------------------------------------------------------------
# DO NOT JUST RUN THIS SCRIPT. EXAMINE THE CODE. UNDERSTAND IT. RUN IT AT YOUR OWN RISK.
#----------------------------------------------------------------------------------------


echo ""
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

echo ""
echo "Enter the path to the directory you would like to save the colorpalette image to:"
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

echo ""
echo "How many colors would you like in the palette?"
read colors

# Is the values an integers?
if ! [[ $colors =~ ^[0-9]+$ ]]; then 
    echo "Not a valid number. Aborting..."
    exit 1
fi

# WIDTH ---------------------------------------------------------------------------------

echo ""
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

echo ""
echo "Your image has been generated at:"
echo "$destination"
echo ""