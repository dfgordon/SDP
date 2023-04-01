# SDP Overview

*Super Dungeon Plot* (SDP) is an Apple II graphics package.  It was developed by the author for personal use in the early to mid 1980's, mainly to produce sprites and artwork for [Realm](https://github.com/dfgordon/Realm).  All the graphics in *Realm* were produced with this package.

# Motivation

This is mainly nostalgia and archiving, my intention is to leave SDP essentially as it was circa 1987.  The shape table editor is the one component that has been significantly polished.

# Scope

* Disassembly of original hand-coded machine language.
  - Disassemblies assemble back to original binaries.
* Polishing of BASIC to eliminate bugs, eliminate vestigial code, and improve readability.
* Provide script to deploy the code to a working disk image.

# Installation

No installation *per se*, just download the disk image and boot in your favorite emulator.  You can also copy the disk image to a device like the [Floppy Emu](https://www.bigmessowires.com/floppy-emu/) and boot it on a real Apple II.

# SDP Menu Items

## 1) Picture

SDP pictures are binary-encoded Applesoft drawing commands.  The picture is composed of lines and brush strokes.  Pictures are rendered using the machine language programs `SDP.INTRP` or `SDP.INTRP.E`.  These assume the brushes are loaded per usual shape table procedures.

## 2) Text

This is a very simple "text editor" that plots graphical fonts on the hi-res screen as you type, or adjusts the cursor position in response to arrows or the nudge commands `@` and `#`.  The fonts are actually shape tables, and the drawing can be rendered the same way as a picture.

## 3) Shape

SDP includes a program to create and manipulate shape tables (a vector sprite built into Applesoft).  The following pre-built shape tables are used by other components:

* D0 = brushes used in SDP pictures
* D1 = bold font
* D2 = tech font
* D3 = caligraphy font (incomplete)
* D4 = pica font
* D5 = normal font
* D6 = cosmic shapes

These are stored in the `git` repository as [a2kit](https://github.com/dfgordon/a2kit) file images.

## 4) Utilities

* Print a picture, supported printer(s) unknown
* Move a picture, simple translation
* Cut a picture, removes last N commands (seems redundant)
* Squeeze, saves 2 bytes per brush stroke
* Expand, cost 2 bytes per brush stroke, but editable

## 5) Fast Shapes

This component was never fully developed.  The idea is to do something like a shape table, but 7-pixels at a time.  The Apple II screen buffer is peculiar.  Each byte consists of seven binary pixels, plus 1 color bit (yet 6 colors are possible, due to further intricacies).  So every fast shape is a multiple of 7 pixels wide.  The fast shape editor is designed to load an existing screen buffer, or SDP graphic, and then allow the user to move a 7x1 (col x row) pixel "scanner" over portions of the screen to be scanned into the fast shape.

The fast shape is encoded as a sequence of pairs of moves and "pixel" values.  Each move is encoded as 2=right, 3=down, 4=left, 96=finish (we never go up).  Each "pixel" value is the value of the byte of the screen buffer that is being moved to.  The horizontal moves stride over 7 pixels, since we are writing full bytes all at once.

## 6) Viewer

Allows quick review of multiple pictures.

## 7) Fast Shape Viewer

This will animate a fast shape along a predetermined line.

# Assembly Modules

The assembly code is disassembled machine code that was originally entered using the Monitor ROM.  What I have done is to add labels and comments to make the flow comprehensible.

* Module `DR` contains simple math, and two 4-byte routines that replace indirect addressing
  - The two 4-byte routines are bloopers, but they work 
* Module `SI` contains a routine to get the address of a pixel with given coordinates
  - Another blooper, could have been replaced by a simple ROM call
* Module `SDP.INTRP` renders a picture
* Module `SDP.INTRP.E` renders a squeezed picture
* Module `HS.INTRP` draws a fast shape

## Machine Code `HS.INTRP`

The fast shape interpreter, `HS.INTRP` (I believe HS was originally HyperShapes), is typically loaded at 16384 ($4000), but has entry point 16582 ($40C6).  This is because it was built by adding to the `SI` code (see above), which already had entry point $4000.  As a result, `SI` and `HS.INTRP` share identical code at the top.  In fact, location $40C6 is a call to location $4000, i.e., a call to `SI`.

## Machine Code `SDP.INTRP`

The standard intepreter `SDP.INTRP`, is a machine language program for rendering SDP artwork.  It works as follows.  The picture file consists of a sequence of commands, each encoded as 8 bytes:

1. plot shape: 0,color,shape index,x low byte,x high byte, y,unused,unused
2. plot line: 1,x1 low,x1 high,x2 low,x2 high,y1,y2,color
3. fill down: 2,x1 low,x1 high,x2 low,x2 high,y,reps,color

The enhanced interpreter `SDP.INTRP.E`, operates on "squeezed" files, which simply make use of the fact that the shape element requires only 6 bytes instead of 8.  The enhanced interpreter also has an extra command that allows the graphic to encode the particular shape table it wants to use:

4. load shapes: 3, ascii decimal character, unused*6

The ASCII character is used to form the numerical suffix of a shape file, like `D0`.

The SDP editor cannot work on squeezed files.  The workflow is to squeeze a graphic only when it is ready to be deployed.