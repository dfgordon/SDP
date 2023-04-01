1  REM exhibition of hi-res row address
2  REM compares BASIC, ML, and ROM routines
3  DEF FN GTADDR(X) = PEEK(38) + 256*PEEK(39) + INT(X/7)
4  PRINT: PRINT CHR$(4);"BLOAD DR"
5  PRINT: PRINT CHR$(4);"BLOAD SI"
6  HGR: HOME: VTAB 21: REM HGR sets $E6 to hi-res page for ROM routine

10 INPUT "X COORD: "; X
20 INPUT "Y COORD: "; Y
30 GOSUB 1000: PRINT "BASIC: ADDRESS = ";BY;" , VALUE = ";PEEK(BY)
40 GOSUB 2000: PRINT "ROM: ADDRESS = ";BY;" , VALUE = ";PEEK(BY)
50 GOSUB 3000: PRINT "ML: ADDRESS = ";BY;" , VALUE = ";PEEK(BY)
60 TEXT: END

1000  REM get screen address purely in BASIC
1010 M = 8232
1020 B =  INT (Y / 8):Q = 9
1030  B = B + 1: IF B < 9 THEN M = 8192:Q = 0:B = B - 1: GOTO 1050
1040  IF B > 16 THEN M = 8272:Q = 17
1050 BY = M + ((B - Q) * 128)
1060  IF  LEN ( STR$ (Y / 8)) > 2 THEN 1080
1070 BY = BY +  INT (X / 7): RETURN
1080 Z = (Y / 8) -  INT (Y / 8)
1090 Z = Z * 10
1100 Z =  INT (Z)
1110  IF Z > 3 THEN Z = Z - 1
1120 BY = BY + (Z * 1024) +  INT (X / 7): RETURN

2000  REM  get row address via ROM routine, then account for column
2010  POKE 768,169: POKE 769,Y: POKE 770,32: POKE 771,23: POKE 772,244: POKE 773,96
2020  POKE 769,Y: CALL 768: BY = FN GTADDR(X)
2030  RETURN 

3000  REM  get screen address using my own ML routine
3010  POKE 776,Y: POKE 777,X - 256*INT(X/256): POKE 778,INT(X/256)
3020  CALL 16384: BY = PEEK(784) + 256*PEEK(785)
3030  RETURN