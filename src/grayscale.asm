
;*************************************************************************
;* Greyscale Stuff                                                       *
;*************************************************************************
GridPutSprite:
    push hl                               
    pop ix               
    srl d                 
    rra                
    and $80                
    or e                  
    ld e,a
    push de     
    ld hl,$fc00           
    add hl,de              
    ld b,8                
    ld de,16              
GPS_Loop:
    ld a,(ix + 0)         
    ld (hl),a            
    inc ix               
    add hl,de           
    djnz GPS_Loop
    ld hl,$ca00
    pop de
    add hl, de
    ld b, 8
    ld de, 16
GPS_Loop2:
    ld a,(ix + 0)         
    ld (hl),a            
    inc ix               
    add hl,de           
    djnz GPS_Loop2          
    ret                   

GreyscaleRoutineStart:
    pop hl                          ;remove the calling routine from the stack - 
                                    ;we'll exit the routine in our own code
                                    ;without going through the default OS code

    ld bc,$3600                     ;b contains value to toggle link port with,
                                    ;c contains port to send value out of
    ld hl,GreyMem                   ;hl points to a memory location containing
                                    ;the interrupt counter

    dec (hl)                        ;decrease the interrupt counter... 
    jr z,SetCount3                  ;...and if it's zero goto SetCount3...
    inc hl                          ;...otherwise make hl point to current
                                    ;value of port 0 (port 0 is write only)
    ld a,(hl)                       ;load a with value of port 0
    xor b                           ;toggle it with b...
    out (c),a                       ;...send it out of port 0...
    ld (hl),a                       ;...and save it to memory

ExitInt:                          ;code to exit the interrupt

    in a,(3)                        ;The following was copied (nearly) from
    rra                             ;the ROM - it seems to handle the ON
    ld a,c                          ;key. If it is left out the calculator
    adc a,9                         ;may freeze, especially if the ON key
    out (3),a                       ;is pressed.
    ld a,$0b
    out (3),a

    exx                             ;restore normal registers
    ex af,af'
    ei                              ;make sure interrupts are enabled
    reti                            ;return from interrupt

SetCount3:
    ld (hl),3                       ;set interrupt counter to 3
    jr ExitInt                      ;and return from the interrupt

GreyMem:
  .db $01, $3c

LoadGreyscale:
    di                              ;disable interrupts in case they are
                                    ;called whilst we install our code

    ld hl,GreyscaleRoutineStart     ;copy user routine to the place
    ld de,_alt_interrupt_exec       ;it will be executed from
    ld bc,200
    ldir

    ld de,$28                       ;set up check digit
    ld a,(_alt_interrupt_exec)
    ld hl,_alt_int_chksum + $28
    add a,(hl)
    add hl,de
    add a,(hl)
    add hl,de
    add a,(hl)
    add hl,de
    add a,(hl)
    add hl,de
    add a,(hl)
    ld (_alt_int_chksum),a

    set 2,(iy + $23)                ;enable user routine
    ei                              ;enable interrupts

    ret                             ;return to main program

CloseGrey:
    res 2,(iy + $23)                ;disable user routine
    ld a,$3c                        ;restore screen to normal memory location
    out (0),a
    set graphdraw,(iy + graphflags) ;graph memory is 'dirty'
    ret                             ;return to main program

ClearScreen:
  ld hl,$fc00                     ;clear the memory at $fc00...
  ld (hl),l
  ld de,$fc01
  ld bc,1023
  ldir
  ld hl,$fc00                     ;...and the memory at $ca00
  ld de,$ca00
  ld bc,1023
  ldir
  ret                             ;return to main program
   
