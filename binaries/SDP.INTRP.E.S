* This is a one-to-one disassembly of SDP.INTRP.E

HGR      =     $F3E2
HPOSN    =     $F411
HCOLOR   =     $F6F0
HGLIN    =     $F53A
SETSHP   =     $F730
DRAW     =     $F601
COUT     =     $FDED

erase    JSR   HGR
draw     LDX   #$00
getnext  JSR   $0300      ; substitute for indirect addressing
         STA   $00,X      ; copy instructions to zp 0-7
         INX
         CPX   #$08
         BEQ   select
         LDA   #$00
         CMP   #$00
         BEQ   getnext
select   LDA   $00
         CMP   #$00
         BEQ   brush
         CMP   #$01
         BEQ   line
         CMP   #$02
         BEQ   fill
         CMP   #$03
         BEQ   load
         RTS
brush    LDX   $01
         JSR   HCOLOR
         LDX   $03
         LDY   $04
         LDA   $05
         JSR   HPOSN
         LDX   $02
         JSR   SETSHP
         LDX   $1A
         LDY   $1B
         JSR   DRAW
         CLC
         LDA   $0301
         ADC   #$06
         CLV
         BVC   squeeze
         BRK   #$00
advance  CLC
         LDA   $0301
         ADC   #$08
squeeze  STA   $0301
         LDA   $0302
         ADC   #$00
         STA   $0302
         LDA   #$00
         CMP   #$00
         BEQ   draw
line     LDX   $07
         JSR   HCOLOR
         LDX   $01
         LDY   $02
         LDA   $05
         JSR   HPOSN
         LDA   $03
         LDX   $04
         LDY   $06
         JSR   HGLIN
relay    LDA   #$00
         CMP   #$00
         BEQ   advance
         DFB   00
fill     LDX   $07
         JSR   HCOLOR
loop     DEC   $06
         LDA   $06
relay2   CMP   #$00
         BEQ   relay
         LDX   $01
         LDY   $02
         LDA   $05
         JSR   HPOSN
         LDA   $03
         LDX   $04
         LDY   $05
         JSR   HGLIN
         INC   $05
         CLV
         BVC   loop
* load shapes by printing DOS command
* (rather inefficiently)
load     LDA   #$84 ; chr$(4)
         JSR   COUT
         LDA   #$C2 ; B
         JSR   COUT
         LDA   #$CC ; L
         JSR   COUT
         LDA   #$CF ; O
         JSR   COUT
         LDA   #$C1 ; A
         JSR   COUT
         LDA   #$C4 ; D
         JSR   COUT
         LDA   #$A0 ; space
         JSR   COUT
         LDA   #$C4 ; D
         JSR   COUT
         LDA   $01 ; digit to select shape file
         JSR   COUT
         LDA   #$AC ; comma
         JSR   COUT
         LDA   #$C1 ; A
         JSR   COUT
         LDA   #$A4 ; $
         JSR   COUT
         LDA   #$B4 ; 4
         JSR   COUT
         LDA   #$B0 ; 000
         JSR   COUT
         JSR   COUT
         JSR   COUT
         JSR   $FD8E
         LDA   #$00
         CMP   #$00
         BEQ   relay2
         BRK   #$00
         BRK   #$00
