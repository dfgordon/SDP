* This is a one-to-one disassembly of the DR program,
* originally hand-coded in machine language.
         ORG   $300

fac1     =     $00
fac2     =     $01
prod     =     $02        ; word

* These two small subroutines were needed only because
* I was unaware of indirect addressing!
HSload   LDA   $4C00,X
         RTS
paint    STA   $34BE
         RTS
yin      HEX   00         ; input y coord
xin      HEX   00,00      ; input x coord
offset   HEX   00,00
remndr   HEX   00
quotient HEX   00
extra    HEX   00
scrn     HEX   00,00      ; holds a screen address on output

* Divide a word by a byte, assuming result is a byte
* in: nominator = A*256 + fac1, denominator = prod, fac2 = 0
* out: fac2 = quotient, A=remainder
divwb    LDY   #$08
         SEC
         SBC   prod
:loop    PHP
         ROL   fac2
         ASL   fac1
         ROL
         PLP
         BCC   :clr1
         SBC   prod
         BCC   :clr2
         BCS   :clr2
:clr1    ADC   prod
:clr2    DEY
         BNE   :loop
         BCS   :set
         ADC   prod
         CLC
:set     ROL   fac2
         RTS

* Multiply two bytes to get a word
mulbb    LDA   #$00
         STA   prod       ; apparently prod+1 was assumed 0
         LDX   #$08
:loop    LSR   fac1
         BCC   :clr1
         CLC
         LDA   prod+1
         ADC   fac2
         STA   prod+1
:clr1    ROR   prod+1
         ROR   prod
         DEX
         BNE   :loop
         RTS

* Trailing dead code
* Keep this so assembly is identical to original hand coded ML
         LDA   #$00
         RTS
         DFB   #$00