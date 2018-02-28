# Shell-Scripts
Some Bash scripts I've written.

### Table of Contents

* [colorpalette.sh](#colorpalletesh)
* [colors.sh](#colorssh)
* [dirtybird.sh](#dirtybirdsh)
* [pcheat.sh](#pcheatsh)
* [mufire.sh](#mufiresh)


# colorpallete.sh
Creates a PNG color palette image with the most common colors contained in another image. Just execute the script via the terminal and you'll be prompted to enter the path to the source image and destination folder. Example:

<img src="https://i.imgur.com/G0olWDV.png" />

<img src="https://i.imgur.com/pNjQHUm.jpg" />

# colors.sh

Color variables and headings for shell scripts. The script contains two things:

Color variables that allow text in shell scripts to be colorized, and a heading function that outputs a centered heading with a colored background. The background spans the entire width of the terminal. The background color can be specified or it can be random.

<img src="https://i.imgur.com/G81iUOk.png" />

### Colorizing Text

To give a text string a color use:

    echo -e "${green}This is green text${reset}

    echo -e "${bold}${magenta}This is bold magenta text${reset}
    
    # Shorter syntax

    echo -e "${pur}This is purple text${r}

    echo -e "${b}${mag}This is bold magenta text${r}
    

__Note:__ Make sure to reset the color at the end of the string.

#### Available Text Colors

    COLOR       SHORTCUT
    white       wht
    black       blk
    grey        gry
    red         red
    green       grn
    blue        blu
    cyan        cyn
    yellow      yel
    orange      org
    magenta     mag
    purple      pur

    bold        b
    reset       r


### Generating Headings

To generate a heading with a colored background use:

    heading <color> "Heading Text"

For a heading with bold text use:

    bheading <color> "Heading Text"

For a heading with a randomly selected color use:

    heading random "Heading Text"

#### Available Heading Colors

    COLOR       SHORTCUT
    random      rnd
    grey        gry
    charcoal    chr
    red         red
    green       grn
    lime        lim
    aquamarine  aqm
    olive       olv
    blue        blu
    sky         sky
    cyan        cyn
    agua        aqa
    goldenrod   gdr
    yellow      yel
    coral       crl
    orange      org
    pink        pnk
    lavender    lav
    magenta     mag
    purple      pur


The above colors can be used to generate your own colored strings. For background colors just prefix "bg" to the color.

    echo -e "${bgred}${b}${wht}Red background with bold white text${r}"

# dirtybird.sh

This script will recursively traverse all directories under a specified folder and display the names of any dirty files under git control. Folders you want ignored can be added to the `IGNORE` array in the script.

Usage:

    dirtybird.sh /path/to/parent/directory

<img src="https://i.imgur.com/tgP8WTQ.png"  />


# pcheat.sh

Arch Linux package manager cheat sheet.

<img src="https://i.imgur.com/kHOmhvk.png" />

### Usage

    $   pcheat          # Show all commands

    $   pcheat -h       # Show help

    $   pcheat -s       # Show sync commands

    $   pcheat -r       # Show remote package search commands

    $   pcheat -q       # Show local search commands

    $   pcheat -f       # Show file search commands

    $   pcheat -x       # Show remove package commands

    $   pcheat -srqfx   # Arguments can be combined


# mufire.sh
Multi-file Rename. Allows all the files in a directory to be renamed identically along with an incrementing counter. I wrote the to batch rename images, but it works with any file type.

---

## Credits

Written by __[Rick Ellis](http://rickellis.com/)__.

## License

All scripts, unless specifically noted, are released under the following license:

MIT

Copyright 2018 Rick Ellis

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.