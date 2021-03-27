SDP Overview
------------

*Super Dungeon Plot* (SDP) is an Apple II graphics package which provides both editing and deployment features intended for use in games.  It was developed by the author in the early to mid 1980's.  Its basic purposes are creating artwork, creating sprites, and providing machine language routines for rendering both.  The creation functions are all exposed by a menu in the HELLO program, which is run upon booting the disk.  The main SDP program is for generating artwork, and storing it efficiently.  SDP artwork makes use of simple line drawing, and paint brushes implemented as shape tables.  Sprites are implemented either as standard Apple II shapes, or as SDP fast shapes.

Motivation
----------

This project is nostalgic. I developed *SDP* in my youth in order to develop artwork and graphics for a game I was creating, *Realm*.  Rediscovering the workings of *SDP* is a prerequisite for doing the same for *Realm*.

Installation
------------

In order to install *SDP* on a vintage machine or emulator, the files in the repository have to be converted and copied to an Apple DOS 3.3 disk image, using a tool such as [CiderPress](https://a2ciderpress.com/).  The text versions of the binaries are for reading on a modern computer and should not be copied.  If running on an actual vintage computer, the disk image must then be copied to a real 5.25 inch floppy disc, or a modern replacement like the [Floppy Emu](https://www.bigmessowires.com/floppy-emu/).  Note that the directory of course has to be flattened, since DOS 3.3 has no hierarchical structure.

Notation
--------

This document uses the Apple II convention of using the dollar sign to indicate a hexidecimal number, e.g., $100 is hexidecimal for the decimal 256.

Shape Tables
------------

Shape tables are scalable sprites built into AppleSoft.  They are flexible but slow.  SDP includes the following shape tables:

* D0 = brushes used in SDP pictures
* D1 = bold font
* D2 = tech font
* D3 = caligraphy font (incomplete?)
* D4 = pica font
* D5 = normal font
* D6 = cosmic shapes (perhaps meant for Interstellar Assault)

These are stored in the `git` repository as if they are machine language programs (extraction is performed using [CiderPress](https://a2ciderpress.com/)).  The displayed assembly language operations mean nothing.

Fast Shapes
-----------

SDP fast shapes are essentially a bitmap, or better yet, a bytemap.  The Apple II screen buffer is peculiar.  Each byte consists of seven binary pixels, plus 1 color bit (yet 6 colors are possible, due to further intricacies).  So every fast shape is a multiple of 7 pixels wide.  The fast shape editor is designed to load an existing screen buffer, or SDP graphic, and then allow the user to move a 7x1 (col x row) pixel "scanner" over portions of the screen to be scanned into the fast shape.

The fast shape is encoded as a sequence of pairs of moves and "pixel" values.  Each move is encoded as 2=right, 3=down, 4=left, 96=finish (we never go up).  Each "pixel" value is the value of the byte of the screen buffer that is being moved to.  The horizontal moves stride over 7 pixels, since we are writing full bytes all at once (this is why fast shapes are fast).

Note on Machine Code
--------------------

Machine language programs on the 6502 processor which use the `JSR` instruction (jump to subroutine) are not relocatable, because the `JSR` instruction uses absolute addresses.  To get around this (to an extent), high level SDP routines `JSR` to lower level routines stored on page 3 (addresses $300-$3FF).  This way the high level routines can be relocated.  An exception is that the entry point of `HS.INTRP`,which is offset from the start of the file, begins with `JSR ADDR`, where `ADDR` is the start of the file.  In cases like this, the caller must `POKE` in the correct `ADDR` in order to relocate the code.

This relocation issue is also why there are seemingly strange branch instructions, such as setting the carry bit, followed immediately by a branch on the carry bit.  Since the branch instructions have relative forms, this is a way of producing a relative jump.  Relative branches use 8 bit offsets, and so are short range.

Machine Code `DR`
-----------------

This is a low level set of routines used by `SI` and `HS.INTRP`.  It is typically loaded at $300 and contains the following subroutines:

* $300 `LDA ADDR,X` : `RTS` - `ADDR` is the start of fast shape data, can be poked by caller
* $304 `STA ADDR` : `RTS` - `ADDR` is a screen buffer byte, i.e., this routine paints the screen
* $312 manipulation of zero page $00-$02, involving Y index
* $333 manipulation of zero page $00-$03, involving X index

`SI` does not use the trivial subroutines at $300 and $304. `HS.INTRP` uses all four subroutines.

Locations $308-$311 are used as variables:
* $308 = input, y, vertical coordinate
* $309,$30A = input, x, horizontal coordinate
* $30B-$30F = intermediate variables, I have not recovered exact purpose
* $310,$311 = output, screen address associated with screen x,y

Machine Code `SI`
-----------------

This machine language program computes the screen address of the byte that holds a given pixel coordinate.  In other words, this is a machine language version of the Applesoft program `BYFNDR`, which is on the SDP disk for reference.  This is also a subroutine re-packaged within `HS.INTRP` (see below).

Machine Code `HS.INTRP`
-----------------------

The fast shape interpreter, `HS.INTRP` (I believe HS was originally HyperShapes), is typically loaded at 16384 ($4000), but has entry point 16582 ($40C6).  This is because it was built by adding to the `SI` code (see above), which already had entry point $4000.  As a result, `SI` and `HS.INTRP` share identical code at the top.  In fact, location $40C6 is a call to location $4000, i.e., a call to `SI`.

Machine code `SDP.INTRP`
------------------------

The standard intepreter `SDP.INTRP`, is a machine language program for rendering SDP artwork.  It works as follows.  There are 3 drawing elements, encoded as 8 bytes:

1. plot shape: 0,color,shape index,x low byte,x high byte, y,unused,unused
2. plot line: 1,x1 low,x1 high,x2 low,x2 high,y1,y2,color
3. fill down: 2,x1 low,x1 high,x2 low,x2 high,y,reps,color

The enhanced interpreter `SDP.INTRP.E`, operates on "squeezed" files, which simply make use of the fact that the shape element requires only 6 bytes instead of 8.  This allows a few extra monsters to be squeezed onto a floppy disk.  The enhanced interpreter also has an extra element that allows the graphic to encode the particular shape table it wants to use:

4. load shapes: 3, ascii decimal character, unused*6

When the interpreter encounters this code it prints `[4]BLOAD D[n],A$4000`, where `[4]` is `CHR$(4)` (redirect to DOS) and `[n]` is an ascii decimal.  So the shape table files are expected to have names like D0,D1,D2,etc..  The return branch from this was broken in the initial recovery state.  I'm not sure if this was ever really used.

The SDP editor cannot work on squeezed files.  The workflow is to squeeze a graphic only when it is ready to be deployed.

Pseudocode for `SDP.INTRP` and `SDP.INTRP.E` is as follows:

  1. Clear screen - this is sometimes bypassed by calling 3 bytes beyond the start of the routine
  2. If no more graphics elements end, else:
  2. Loop 8 times on X:
    * Load A with graphics data.  In detail, call $0300, which must contain `LDA ADDR,X` : `RTS`, where `ADDR` is the address of the graphics data
    * Store A in $00+X
  3. Read $00 and branch to one of the drawing element processing subroutines, which use data in $01-$07
    * At end of drawing, $0301,$0302 (containing `ADDR`) are incremented by the size of the encoded data
  4. Goto 2
