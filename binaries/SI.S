* This is a one-to-one disassembly of the SI program,
* originally hand coded in machine language.
* This is a way of getting the screen address of a coordinate.
* Now we know there is a more efficient ROM routine.

         ORG   $4000

* The following are also defined in DR.
* If an assembler had been available these
* could have been external labels.

fac1     =     $00
fac2     =     $01
prod     =     $02        ; word

yin      =     $308       ; input y coord
xin      =     $309       ; word - input x coord
offset   =     $30B       ; word
remndr   =     $30D
quotient =     $30E
extra    =     $30F
scrn     =     $310       ; word - holds a screen address on output
divwb    =     $312       ; external routine in DR
mulbb    =     $333       ; external routine in DR

getscrn  LDA   #$28       ; initial offset determines the page
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

* add trailing stuff so the assembly is identical to original
* hand coded machine language

         DW    $0000
         DW    $FFFF