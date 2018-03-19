#!/usr/bin/env bash
#-----------------------------------------------------------------------------------
#   _____   _____     _           ___ _  _  ___ 
#  / __\ \ / / __|___| |_ ___ ___| _ \ \| |/ __|
#  \__ \\ V / (_ |___|  _/ _ \___|  _/ .` | (_ |
#  |___/ \_/ \___|    \__\___/   |_| |_|\_|\___|                                             
#
#-----------------------------------------------------------------------------------
VERSION="1.2.1"
#-----------------------------------------------------------------------------------
#
# Convert all SVG files in a directory to PNG. You will be prompted to enter the
# desired color and image size via the terminal when you run this script.
#
#-----------------------------------------------------------------------------------
# Author:       Rick Ellis
# URL:          https://github.com/rickellis/SVG-to-PNG
# License:      MIT
# Dependencies: Inkscape or ImageMagick on Linux, and ImageMagick on Mac OS.
#-----------------------------------------------------------------------------------

# Enable extended pattern matching
shopt -s extglob

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
heading green "SVG to PNG" 

# CHECK FOR DEPENDENCIES ----------------------------------------------------------------

os="$(uname)"

# If we are on Linux...
if [ "${os:0:5}" == "Linux" ]; then

	# Is Inkscape installed?
	if [ "$(command -v inkscape)" >/dev/null 2>&1 ]; then
		converter="inkscape"
		
	# Inkscape is not installed. How about ImageMagick?
	elif [ "$(type command)" > /dev/null 2>&1 ]; then
		converter="imagemagick"
		
	else
		echo -e " ERROR: This script requires either Inkscape or ImageMagick"
        echo
		exit 1;
	fi

# If we are on Mac OSX
elif [ "${os:0:6}" == "Darwin" ]; then

	# Is ImageMagick installed/
	if [ "$(type command)" > /dev/null 2>&1 ]; then
		converter="imagemagick"
		
	else
		echo -e " ERROR: This script requires either ImageMagick"
        echo
		exit 1;
	fi

else
    echo -e " ERROR: Unsupported operating system"
    echo
    exit 1;
fi


# SVG PATH ------------------------------------------------------------------------------

echo -e " Enter the path to the folder with SVG files you want to convert:"

read -p " " sourcedir

if [[ $sourcedir == "" ]]; then
    echo -e " ERROR: No source directory supplied. Aborting..."
    echo
    exit 1
fi

# Remove the trailing slash if it was submitted
if [[ $sourcedir =~ .*/$ ]]; then
    sourcedir="${sourcedir:0:-1}"
fi

# Does the source directory exist?
if  ! [[ -d $sourcedir ]]; then
    echo -e " ERROR: The supplied path isn't valid. Aborting..."
    echo
    exit 1
fi


# SIZE ----------------------------------------------------------------------------------

echo
echo -e " Enter the size in pixels you wish your PNG images to be."
echo " You may enter a width x height (example: 400x300) or a"
echo " single number which will be used for both width and height:"
read -p " " size

# Remove "px" from the size in the event the user included it:
size="${size//px/}"

# Set the width by removing everything before the x
width="${size%%x*}"

# Set the height by removing everything after the x
height="${size##*x}"

# Trim leading whitespaces from width and height
width="${width##*( )}"
height="${height##*( )}"

# Trim trailing whitespaces from width and height
width="${width%%*( )}"
height="${height%%*( )}"

# Are the remaining values integers?
if ! [[ $width =~ ^[0-9]+$ ]] || ! [[ $height =~ ^[0-9]+$ ]]; then 
    echo -e " ERROR: The size you entered is not a valid number. Aborting..."
    echo
    exit 1
fi


# COLOR ---------------------------------------------------------------------------------

echo
echo -e " Enter the hex color value you wish to convert the SVG images to:"
read -p " " color

# Did they submit a valid HEX value?
if ! [[ $color =~ ^[\#a-fA-F0-9]+$ ]]; then 
    echo -e " ERROR: The color you entered is not a valid number. Aborting..."
    echo
    exit 1
fi

# Add the # character if they omitted it from the hex color
if [[ ${color:0:1} != "#" ]]; then
    color="#${color}"
fi

# The hex color should now be 7 characters. Ex: #ffffff
if [[ ${#color} -ne 7 ]]; then
    echo -e " ERROR: Hex values must be 6 characters in length, or 7 if you include the # symbol."
    echo
    exit 1
fi


# CONFIRM VALUES ------------------------------------------------------------------------

echo
echo -e " You entered the following values:"
echo -e " Width:  ${width}PX"
echo -e " Height: ${height}PX"
echo -e " Color:  ${color}"
echo
echo -e " Do you wish to proceed? [y|n]"
read -p " " _consent

if [[ $_consent != "" ]] && [[ $_consent != "y" ]] && [[ $_consent != 'Y' ]]; then
    echo
    echo -e " Goodbye..."
    echo
    exit 1
fi


# COPY SVG TO TMP/DIRECTORY  ------------------------------------------------------------

# Name of the temp directory that we will copy the SVGs to.
tempdir="/tmp/SVGCONVERT"

# Copy the master svg images to the temp directory.
# We don't want to mess with the originals.
cp -R "${sourcedir}" "${tempdir}"


# REPLACE COLOR IN SVG FILES ------------------------------------------------------------

# We now open each SVG file in the temp directory and replace the fill color
for filepath in "${tempdir}"/*.svg
    do
    # Match the pattern: fill="#hexval" and replace with the new color
    sed -i -e "s/fill=\"#[[:alnum:]]*\"/fill=\"${color}\"/g" "$filepath"
done


# CONVERT SVG TO PNG  -------------------------------------------------------------------

# The most logical place to put the final PNG folder is at the same directory level as the
# SVG source directory. In order to do that we look for a slash in the supplied source name.
if ! [[ $sourcedir =~ .*/.* ]]; then
        sourcepath=""
    else
        sourcepath="${sourcedir%/*}/"
fi

# The name of the folder containing the master SVGs
sourcename="${sourcedir##*/}"

# The name/path of the output directory where the PNGs will be saved
outputdir="${sourcepath}PNG-${width}x${height}-${color}"

# Create the output directory if it doesn't exist
if  ! [[ -d $outputdir ]]; then
   mkdir "${outputdir}"
fi

# Convert the SVG files to PNG
echo -e " Converting images using: $converter"
for filepath in "${tempdir}"/*.svg
    do

    # Extract the filename from the path
    filename="${filepath##*/}"

    # Remove the file extension, leaving only the name  
    name="${filename%%.*}"

    echo " Converting ${filename}"

    # Convert to PNG using either Inkscape or ImageMagick
    if [[ $converter == "inkscape" ]]
    then
        inkscape -z -e \
        "${outputdir}/${name}.png" \
        -w "$width" \
        -h "$height" \
        "$filepath" \
        >/dev/null 2>&1 || { 
                                echo " An error was encountered. Aborting...";
                                rm -R "$tempdir";
                                exit 1; 
                            }
    else
        convert \
        -background none \
        -density 1500 \
        -resize "${width}x${height}!" \
        "$filepath" \
        "${outputdir}/${name}.png" \
        >/dev/null 2>&1 || { 
                                echo " An error was encountered. Aborting..."; 
                                rm -R "$tempdir";
                                exit 1;
                            }
    fi

done

# Delete the temporary directory
rm -R "$tempdir"

# High five!
echo
echo -e " SVG files successfully converted to PNG!"
echo
echo -e " Your PNG files are located at:"
echo -e " $outputdir"
echo