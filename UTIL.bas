0  ST$ = "S6,D1,V254"
1  POKE 232,0
2  POKE 233,64
3  SCALE= 1: ROT= 0
5  PRINT  CHR$ (4);"BLOAD SDP.INTRP,A$4B00,";ST$
6  PRINT  CHR$ (4);"BLOAD D0,A$4000,";ST$
10  TEXT : HOME
11  PRINT  TAB( 17);"SDP UTILITIES" : PRINT : PRINT
12  PRINT "A) PRINT"
13  PRINT "B) MOVE"
14  PRINT "C) CUT"
15  PRINT "D) SQUEEZE"
16  PRINT "E) EXPAND"
17  PRINT "F) QUIT"
20  GET A$
21  IF A$ = "A" THEN 100
22  IF A$ = "B" THEN 200
23  IF A$ = "C" THEN 400
24  IF A$ = "D" THEN 3000
25  IF A$ = "E" THEN 4000
26  IF A$ = "F" THEN 10000
30  GOTO 10

50  POKE 768,189: POKE 769,0: POKE 770,76: POKE 771,96: CALL 19200: RETURN: REM RENDER

100  REM PRINT
102  HGR : HOME : VTAB 21
104  GOSUB 600
106  IF A$ = "" THEN 10
108  PRINT  CHR$ (4);"BLOAD ";A$;",A19456,S";S;",D";D;",V";V
110  GOSUB 50: GOTO 114
114  PRINT "(L)EFT, (R)IGHT, OR (C)ENTER: ";: GET B$: A = 0
116  IF B$ = "L" THEN A = 0
118  IF B$ = "C" THEN A = 20
120  IF B$ = "R" THEN A = 41
122  PRINT : PRINT "(D)OUBLE SIZE: ";: GET B$: PRINT
124  PR# 1
126  PRINT  CHR$ (9);A;"L"
128  IF B$ = "D" THEN 134
130  PRINT  CHR$ (9);"GL"
132  GOTO 136
134  PRINT  CHR$ (9);"GDR"
136  PR# 0
138  HOME : VTAB 21: GOTO 10

200  REM MOVE
205  GOSUB 600
210  IF A$ = "" THEN 1
215  PRINT  CHR$ (4);"BLOAD ";A$;",A19456,S";S;",D";D;",V";V
220  GOSUB 50
225  HOME : VTAB 21: INPUT "SHIFT LEFT/RIGHT: ";L
230  INPUT "SHIFT UP/DOWN: ";U
240  HOME : VTAB 21
245  PRINT "WORKING..."
250 I = 19456
252 Z =  PEEK (I)
253  IF Z = 96 THEN 293
254  IF Z = 0 THEN 260
256  IF Z = 1 THEN 270
258  IF Z = 2 THEN 280
259  GOTO 290

260 Z =  PEEK (I + 3) + 256 *  PEEK (I + 4)
261 Z = Z + L
262  IF Z < 0 THEN 296
263  IF Z > 279 THEN 296
264  POKE I + 4, INT (Z / 256): POKE I + 3,Z -  INT (Z / 256) * 256
265 Z =  PEEK (I + 5)
266 Z = Z + U
267  IF Z < 0 THEN 296
268  IF Z > 159 THEN 296
269  POKE I + 5,Z: GOTO 290

270 Z =  PEEK (I + 1) + 256 *  PEEK (I + 2):Z = Z + L
271  IF Z < 0 OR Z > 279 THEN 296
272  POKE I + 2, INT (Z / 256): POKE I + 1,Z -  INT (Z / 256) * 256
273 Z =  PEEK (I + 3) + 256 *  PEEK (I + 4):Z = Z + L
274  IF Z < 0 OR Z > 279 THEN 296
275  POKE I + 4, INT (Z / 256): POKE I + 3,Z -  INT (Z / 256) * 256
276 Z =  PEEK (I + 5):Z = Z + U: IF Z < 0 OR Z > 159 THEN 296
277  POKE I + 5,Z
278 Z =  PEEK (I + 6):Z = Z + U: IF Z < 0 OR Z > 159 THEN 296
279  POKE I + 6,Z: GOTO 290

280 Z =  PEEK (I + 1) + 256 *  PEEK (I + 2):Z = Z + L
281  IF Z < 0 OR Z > 279 THEN 296
282  POKE I + 2, INT (Z / 256): POKE I + 1,Z -  INT (Z / 256) * 256
283 Z =  PEEK (I + 3) + 256 *  PEEK (I + 4):Z = Z + L
284  IF Z < 0 OR Z > 279 THEN 296
285  POKE I + 4, INT (Z / 256): POKE I + 3,Z -  INT (Z / 256) * 256
286 Z =  PEEK (I + 5):Z = Z + U: IF Z < 0 OR Z > 159 THEN 296
287  POKE I + 5,Z

290 I = I + 8
292  GOTO 252
293  GOSUB 50
294  INPUT "SAVE ? ";A$: IF A$ = "Y" THEN B = 19456: LN = I - B + 1: GOTO 500
295  GOTO 200
296  FOR M = 0 TO 7
297  POKE I + M,0
298  NEXT M
299  GOTO 290

400  REM CUT
401  HGR: HOME: VTAB 21: GOSUB 600: IF A$ = "" THEN 10000
402  PRINT: PRINT  CHR$ (4);"BLOAD ";A$;",A19456,S";S;",D";D;",V";V
405  HOME : VTAB 21: INPUT "HOW MANY STEPS ? ";A
410 A = A * 8
411 I = 19456
412 I = I + 8
413  IF  PEEK (I) = 96 THEN 420
414  GOTO 412
420 I = I - A
425  IF I < 19464 THEN 490
426  POKE I,96
430  GOSUB 50
440  INPUT "SAVE ? ";A$
450  IF A$ = "Y" THEN B = 19456: LN = I - B + 1: GOTO 500
490  GOTO 10

500  REM SAVE
501  HOME : VTAB 21: GOSUB 600
502  IF A$="" THEN 1
503  HOME: VTAB 21: INPUT "DELETE FIRST? ";B$: IF B$="Y" THEN 505
504  GOTO 506 
505  PRINT  CHR$ (4);"DELETE ";A$;",S";S;",D";D;",V";V
506  PRINT  CHR$ (4);"BSAVE ";A$;",A";B;",L";LN;",S";S;",D";D;",V";V
510  GOTO 10

600  INPUT "FILENAME: ";A$
601  INPUT "SLOT (6): ";B$
602 S =  VAL (B$)
603  IF B$ = "" THEN S = 6
605  INPUT "DRIVE (1): ";B$
606 D =  VAL (B$)
607  IF B$ = "" THEN D = 1
609  INPUT "VOLUME (254): ";B$
610 V =  VAL (B$)
611  IF B$ = "" THEN V = 254
612  RETURN

3000  REM SQUEEZE
3001  HOME : VTAB 21: GOSUB 600
3005  IF A$ = "" THEN 1
3010  PRINT  CHR$ (4);"BLOAD ";A$;",A19456,S";S;",D";D;",V";V
3200  HOME : VTAB 21: PRINT "WORKING...":OF = 0:BY = 19456
3205 X =  PEEK (BY)
3210  IF X = 96 THEN 3300
3215  IF X = 0 THEN 3250
3220  FOR I = BY TO BY + 7: REM JUST COPYING
3222 VA =  PEEK (I)
3224  POKE I - OF,VA
3226  NEXT I
3230 BY = BY + 8
3231  VTAB 22: HTAB 1: PRINT BY
3240  GOTO 3205
3250  FOR I = BY TO BY + 7: REM SQUEEZING
3252 VA =  PEEK (I)
3254  POKE I - OF,VA
3256  NEXT I
3258 OF = OF + 2
3260 BY = BY + 8
3261  VTAB 22: HTAB 1: PRINT BY
3270  GOTO 3205
3300 VA =  PEEK (BY)
3305  POKE BY - OF,VA
3310  HOME : VTAB 21: PRINT "BYTES SAVED= ";OF
3315 LN = BY - 19456 - OF + 1
3320  PRINT "NEW LENGTH= ";LN
3325  INPUT "SAVE ? ";A$: IF A$ = "Y" THEN B = 19456: GOTO 500
3340  GOTO 10

4000  REM EXPAND
4001  HOME : VTAB 21: GOSUB 600
4005  IF A$ = "" THEN 1
4010  PRINT  CHR$ (4);"BLOAD ";A$;",A19456,S";S;",D";D;",V";V
4015  HOME : VTAB 21: PRINT "WORKING..."
4020 BY = 19456:OF = 0
4025 X =  PEEK (BY): REM PASS 1, GET COUNTS
4030  IF X = 96 THEN 4050
4040 BY = BY + 8
4044  IF X = 0 THEN OF = OF + 2
4045  IF X = 0 THEN BY = BY - 2
4046  GOTO 4025
4050  PRINT "BYTES ADDED = ";OF
4055 BN = BY + 10:B = BN
4060 BY = 19456
4065 X =  PEEK (BY): REM PASS 2, FILL BUFFER AT BN
4070  IF X = 96 THEN 4200
4075 M = 7: IF X = 0 THEN M = 5
4080  FOR I = 0 TO M
4085  POKE BN + I, PEEK (BY + I)
4090  NEXT
4095 BY = BY + M + 1:BN = BN + 8
4096  VTAB 23: HTAB 1: PRINT BN
4100  GOTO 4065
4200  POKE BN,96
4210  HOME : VTAB 21: PRINT "BYTES LOST= ";OF
4215 LN = BN - B + 1
4220  PRINT "NEW LENGTH= ";LN
4225  INPUT "SAVE ? ";A$: IF A$ = "Y" THEN 500
4240  GOTO 10

10000  REM EXIT TO MENU
10010  TEXT : HOME
10020  PRINT "INSERT SDP IN ";ST$
10030  INPUT "PRESS ENTER WHEN READY";A$
10040  PRINT : PRINT : PRINT  CHR$ (4);"RUN HELLO,";ST$