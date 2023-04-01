* This is a one-to-one disassembly of HS.INTRP,
* originally hand coded in machine language.
* The `getscrn` routine is the same as what is in SI.

         ORG   $4000

* The following are also defined in DR.
* If an assembler had been available these
* could have been external labels.

fac1     =     $00
fac2     =     $01
prod     =     $02        ; word

HSload   =     $300
paint    =     $304
hsaddr   =     $301       ; word
pntaddr  =     $305       ; word
yin      =     $308       ; input y coord
xin      =     $309       ; word - input x coord
offset   =     $30B       ; word
remndr   =     $30D
quotient =     $30E
extra    =     $30F
scrn     =     $310       ; word - holds a screen address on output
divwb    =     $312       ; external routine in DR
mulbb    =     $333       ; external routine in DR

getscrn  LDA   #$28
         STA   offset
         LDA   #$20
         STA   offset+1
         LDA   #$08
         STA   prod
         LDA   yin
         STA   fac1
         LDA   #$00
         STA   fac2
         JSR   divwb      ; put y/8 in fac2, remainder in A
         STA   remndr
         LDA   fac2
         STA   quotient
         LDA   #$09
         STA   extra
         INC   quotient
         LDA   quotient
         CMP   #$09
         BMI   :neg1
         CMP   #$11
         BPL   :pos1
         CMP   #$11
         BMI   :neg2
:neg1    LDA   #$00
         STA   offset
         LDA   #$00
         STA   extra
         DEC   quotient
         CMP   #$00
         BEQ   :neg2
:pos1    LDA   #$50
         STA   offset
         LDA   #$11
         STA   extra
:neg2    SEC
         LDA   quotient
         SBC   extra
         STA   fac1
         LDA   #$80
         STA   fac2
         LDA   #$00
         STA   prod
         STA   prod+1
         JSR   mulbb
         CLC
         LDA   prod
         ADC   offset
         STA   scrn
         LDA   prod+1
         ADC   offset+1
         STA   scrn+1
         LDA   remndr
         STA   fac1
         LDA   #$04
         STA   fac2
         LDA   #$00
         STA   prod
         STA   prod+1
         JSR   mulbb
         CLC
         LDA   prod+1     ; should be 0
         ADC   scrn
         STA   scrn
         LDA   prod       ; remainder * 4 added to high byte
         ADC   scrn+1
         STA   scrn+1
* we have the row address, now add x/7
         LDA   xin
         STA   fac1
         LDA   #$07
         STA   prod
         LDA   #$00
         STA   fac2
         LDA   xin+1
         JSR   divwb      ; put x/7 into fac2, remainder in A
         LDA   #$00
         STA   prod
         LDA   fac2
         ADC   scrn
         STA   scrn
         LDA   prod
         ADC   scrn+1
         STA   scrn+1
         RTS

* Draw the fast shape
* inputs: xin, yin, hsaddr
draw     JSR   getscrn
:start   LDX   #$00       ; load the move code
         JSR   HSload
         CMP   #$02
         BEQ   :right
         CMP   #$04
         BEQ   :left
         CMP   #$01
         BEQ   :up
         CMP   #$03
         BEQ   :down
         RTS

:right   CLC
         LDA   scrn
         ADC   #$01
         STA   scrn
         LDA   scrn+1
         ADC   #$00
         STA   scrn+1

:paint   LDA   scrn
         STA   pntaddr
         LDA   scrn+1
         STA   pntaddr+1
         LDX   #$01
         JSR   HSload     ; load the byte value
         JSR   paint
         CLC
         LDA   hsaddr
         ADC   #$02
         STA   hsaddr
         LDA   hsaddr+1
         ADC   #$00
         STA   hsaddr+1
         CLC
         BCC   :start

:left    SEC
         LDA   scrn
         SBC   #$01
         STA   scrn
         LDA   scrn+1
         SBC   #$00
         STA   scrn+1
         CLC
         BCC   :paint

:up      RTS
         BCC   :err       ; vestigial

:down    CLC
         LDA   scrn+1
         ADC   #$04
         STA   scrn+1
         CMP   #$43
         BEQ   :overflw
         CLC
         BCC   :check2

* the rest is working out the screen offset
* resulting from a single row advance

:overflw LDA   scrn
         CMP   #$80
         BPL   :rewind
:check2  LDA   scrn+1
         CMP   #$40
         BPL   :rewind2
         CLC
         BCC   :paint
:rewind  SEC
         LDA   scrn
         SBC   #$58
         STA   scrn
         LDA   scrn+1
         SBC   #$23
         STA   scrn+1
:relay   CLC
         BCC   :paint
:rewind2 SEC
         LDA   scrn+1
         SBC   #$20
         STA   scrn+1
         CLC
         LDA   scrn
         ADC   #$80
         STA   scrn
         LDA   scrn+1
         ADC   #$00
         STA   scrn+1
         CLC
         BCC   :relay
:err     HEX   FF         ; unreachable
