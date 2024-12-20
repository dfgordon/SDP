10  REM SDP MAIN MENU
40  TEXT : HOME : REM START MAIN LOOP
50  PRINT  TAB(15);"SDP VERSION 4.2"
60  PRINT : PRINT : PRINT
61  PRINT "1) PICTURE"
62  PRINT "2) TEXT"
63  PRINT "3) SHAPE"
64  PRINT "4) UTILITIES"
65  PRINT "5) FAST SHAPES"
66  PRINT "6) VIEW PICTURE"
67  PRINT "7) VIEW FAST SHAPE"
68  PRINT "H) HELP"
69  PRINT "Q) QUIT"
70  PRINT : GET A$
71  PRINT : PRINT : PRINT
80  IF A$ = "1" THEN  PRINT  CHR$ (4);"RUN SDP"
90  IF A$ = "2" THEN  PRINT  CHR$ (4);"RUN TEXT"
100  IF A$ = "3" THEN  PRINT  CHR$ (4);"RUN SHAPE"
110  IF A$ = "4" THEN  PRINT  CHR$ (4);"RUN UTIL"
120  IF A$ = "5" THEN  PRINT  CHR$ (4);"RUN FASTSHAPE"
130  IF A$ = "6" THEN  PRINT  CHR$ (4);"RUN VIEWER"
131  IF A$ = "7" THEN PRINT CHR$(4);"RUN FSVIEWER"
140  IF A$ = "H" THEN GOSUB 2000
150  IF A$ = "Q" THEN END
160  GOTO 40 : REM END MAIN LOOP

2000  TEXT : HOME : REM HELP SUBROUTINE
2010  PRINT "SUPER DUNGEON PLOT"
2011  PRINT: PRINT "PICTURE - CREATE GRAPHICS"
2020  PRINT "TEXT - CREATE GRAPHICAL TEXT"
2030  PRINT "SHAPE - CREATE SHAPE TABLES"
2040  PRINT "UTILITIES - ADJUST PICTURES"
2043  PRINT "  (UN)SQUEEZE, CUT, MOVE, PRINT"
2050  PRINT "FAST SHAPES - BIT MAP OF SORTS"
2070  PRINT : PRINT "APPLICABLE THROUGHOUT:"
2080  PRINT "Y,G,J,SPACE = FINE MOVEMENT"
2090  PRINT "1,2,3,4 = COARSE MOVEMENT"
2099  PRINT: PRINT "PRESS ANY KEY TO CONTINUE":GET A$
2100  HOME
2105  PRINT "SDP POINT MODE"
2130  PRINT: PRINT "B=BRUSH P=PLOT C=COLOR L=LINE MODE"
2140  PRINT "F=FILL MODE Q=QUIT"
2150  PRINT "Z=REPEAT ]=FULL [=MIXED"
2160  PRINT "<=REWIND >=FAST FORWARD U=UNDO"
2170  PRINT "M=MULTI-UNDO S=PARTIAL PIC"
2175  PRINT "I=INSERT EXISTING PICTURE"
2180  PRINT: PRINT "PRESS ANY KEY TO CONTINUE":GET A$
2200  HOME
2210  PRINT "SDP LINE MODE"
2240  PRINT: PRINT "C=COLOR R=RETURN TO POINT"
2250  PRINT "@=START LINE !=DRAW LINE"
2260  PRINT: PRINT "PRESS ANY KEY TO CONTINUE":GET A$
2300  HOME
2310  PRINT "SDP FILL MODE"
2320  PRINT: PRINT "A,D = ADJUST LEFT POINT"
2330  PRINT "G,J = ADJUST RIGHT POINT"
2340  PRINT "Y,SPACE = FILL UP OR DOWN"
2350  PRINT "C=COLOR R=RETURN TO POINT"
2360  PRINT "Z=REPEATING FILL DOWN"
2370  PRINT: PRINT "PRESS ANY KEY TO CONTINUE":GET A$
2400  HOME
2410  PRINT "FASTSHAPE:"
2420  PRINT "S = START SCAN"
2430  PRINT "Q = FINISH SCAN"
2440  PRINT : PRINT "SHAPE:"
2450  PRINT "FOLLOW PROMPTS"
2460  PRINT "UNDO CANCELS 8-BIT CLUSTER"
2470  PRINT "ILLEGAL MOVE FORCES UNDO"
2480  PRINT "AVOID DOUBLE PLOTTING"
2490  PRINT: PRINT "PRESS ANY KEY TO CONTINUE":GET A$
2999  RETURN
