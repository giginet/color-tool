# color-tool

A simple tool to generate color constants


## Usage

Copy `color-tool` someplace where you can access it, e.g. into your `/usr/local/bin` folder.


### Input formats

Currently only a simple text based format is supported. An input files looks something like this:

    # Section header
    00AAFF: My Beautiful Color
    332211: Another One
    
    123456: And yet another one

Sections start with an optional name and the entries just after it. Use blank lines to separate sections.
An entry starts with a 6-digit hex value describing the RGB value, followed by a colon and the color name.
Whitespaces are trimmed at the start, end and after the colon.

The default file ending for those files is `.scl` (simple color list).


### Generating Apple Color Palette files (.clr)

`color-tool create-clr /path/to/input.scl /path/to/output.clr`

Creates an Apple Color Palette file. This file can be opened from the color picker which then
provides the colors as a palette.

The output path is optional. If the path is omitted or a directory the input file name is taken and
the file extension is changed to `.clr`.


### Generating Code Constants

`color-tool create-constants --format=format --prefix=prefix /path/to/input.scl /path/to/output-file`

Generates code constants from the colors.

The output path is optional. If the path is omitted or a directory the input file name is taken and
the file extension is changed according to the specified format.


Valid Options:

*	--format: `swift`, `scss` or `android`. If the format parameter is omitted, `swift` is assumed.
*	--prefix (optional): An optional prefix which gets added first before the name. Example: $prefix- for `scss`, prefix_ for `android`. Swift does not need it since it's already scoped in a Struct


Sample swift constants:

    // GENERATED FILE - DO NOT MODIFY
    
    struct Sample {
        
        static let myBeautifulColor = UIColor(red: 0.0, green: 0.67, blue: 1.0, alpha: 1.0)
        static let anotherOne = UIColor(red: 0.2, green: 0.13, blue: 0.07, alpha: 1.0)
        static let andYetAnotherOne = UIColor(red: 0.07, green: 0.2, blue: 0.34, alpha: 1.0)
    }


Sample SCSS constants:

    // GENERATED FILE - DO NOT MODIFY
    
    $my-beautiful-color: #00AAFF;
    $another-one: #332211;
    $and-yet-another-one: #123456;
    
  
Sample Android colors.xml:

	<?xml version="1.0" encoding="utf-8"?>
	<resources>
		<color name="my_beautiful_color">#00AAFF</color>
		<color name="another_one">#332211</color>
		<color name="and_yet_another_one">#123456</color>
	</resources>


### Generating a PDF Color Guide

`color-tool create-guide /path/to/input.scl /path/to/output.pdf`

Generates a pdf file containing the colors with the names, hex and RGB values.

The output path is optional. If the path is omitted or a directory the input file name is taken and
the file extension is changed to `.pdf`.