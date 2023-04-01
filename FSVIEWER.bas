0  ST$ = "S6,D1,V254"
1  PRINT  CHR$ (4);"BLOAD DR,A$300"
2  PRINT  CHR$ (4);"BLOAD HS.INTRP,A$4000"
3  HGR: HOME: VTAB 21: POKE -16301,0
10  GOSUB 2000
20  INPUT "PAUSE ITERATIONS ";PA: IF PA<1 THEN PA = 1
30  GOTO 100

70  POKE 776,Y: POKE 778, INT(X / 256): POKE 777,X -  INT (X / 256) * 256: RETURN: REM POKE IN COORDS

100  REM MAIN LOOP
110  INPUT "FILE (Q=QUIT)? ";A$
120  IF A$="Q" THEN TEXT: HOME: PRINT "INSERT SDP IN ";ST$: INPUT "PRESS ENTER WHEN READY"; A$: PRINT CHR$(4);"RUN HELLO,";ST$
125  HGR : PRINT  CHR$ (4);"BLOAD ";A$;",A$4C00,S";SL$;",D";DV$;",V";VOL$
130  GOSUB 500: GOSUB 300: GOTO 100

300  REM ANIMATE
310  X = 100: Y = 50: ST =  2: YM = 100
320  POKE 3,0: GOSUB 70: POKE 769,0: POKE 770,76: CALL 16582
330  FOR P = 1 TO PA: NEXT P
340  POKE 3,0: POKE 769,0: POKE 770,112: CALL 16582
350  Y = Y + ST: IF Y > YM THEN POKE 769,0: POKE 770,76: CALL 16582: RETURN
360  GOTO 320

500  REM BUILD ERASER SHAPE AS A WORKAROUND
510  AS = 19456: AE = 28672: REM ADDRESS OF SHAPE AND ERASER
520  IF PEEK(AS) = 96 OR AE > 37000 THEN 599
530  POKE AE,PEEK(AS): POKE AE+1,0: REM COPY MOVE, SET PIXELS TO 0
540  AS = AS + 2: AE = AE + 2: GOTO 520
599  POKE AE,96: RETURN

2000  REM GET DRIVE INFORMATION
2010  INPUT "ENTER SLOT (6) ";SL$
2020  IF SL$="" THEN SL$="6"
2030  INPUT "ENTER DRIVE (1) ";DV$
2040  IF DV$="" THEN DV$="1"
2050  INPUT "ENTER VOLUME (254) ";VOL$
2060  IF VOL$="" THEN VOL$="254"
2070  RETURN
