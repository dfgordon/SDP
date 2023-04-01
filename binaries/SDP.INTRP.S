* This is a one-to-one disassembly of SDP.INTRP

HGR      =     $F3E2
HPOSN    =     $F411
HCOLOR   =     $F6F0
HGLIN    =     $F53A
SETSHP   =     $F730
DRAW     =     $F601

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
         RTS
         DFB   $FF,$FF,$00,$00
         DFB   $FF,$FF,$00,$00
         DFB   $FF,$FF,$00,$00
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
advance  CLC
         LDA   $0301
         ADC   #$08
         STA   $0301
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
         DFB   $00
fill     LDX   $07
         JSR   HCOLOR
loop     DEC   $06
         LDA   $06
         CMP   #$00
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
         LDA   #$00
         CMP   #$00
         BEQ   loop
         BRK   #$00
