;Keys
EXIT  = 1
UP    = 2
DN    = 3
RT    = 4
LF    = 5
ENTER = 6
SND   = 7

anim_counter: .db 0

;===================================
; Waits til arrow keys are released
;===================================
waitRelease:
    ld b,10
wait_loop:
    halt
    djnz wait_loop
    ret

;==================================
; Port Equivalent of get_key
;
; Input: None
; Output: A, key pressed
;
;==================================
waitkey:
    ;wait for a sec
    call waitRelease
    ;Check for Exit key
    ld a,%00111111
    out (1),a
    in a,(1)
    ld b,EXIT
    bit 6,a
    jr z,got_key
    ld b,SND
    bit 5,a
    jr z,got_key
    ;Check for Enter key
    ld a,%01111101
    out (1),a
    in a,(1)
    ld b,ENTER
    bit 0,a
    jr z,got_key
    ;Check for arrow keys
    ld a,%01111110
    out (1),a
    in a,(1)
    ;Check for up key
    ld b,UP
    bit 3,a
    jr z,got_key
    ;Check for dn key
    ld b,DN
    bit 0,a
    jr z,got_key
    ;Check for left key
    ld b,LF
    bit 1,a
    jr z,got_key
    ;Check for right key
    ld b,RT
    bit 2,a
    jr z,got_key
    jr waitkey
got_key:
    ld a,b
    ret

;TODO: Make smaller
;=========================
; Centered Text Routine
; Input:
;   HL: PTR to String
;   B: Row to display on
;
; Output:
;   String displayed centered
;
; Destroys: HL, DE, A, F
;=========================

vputs_center:
    ld d,64
    push hl
    push de
    ld a,b
    ld (_penRow),a          ;set pen row
    xor e              ;length
get_size:
    ld a,(hl)               ;get next byte
    or a                    ;check if a=0
    jr z,got_size           ;finished getting size
    push hl
    push de
    call _get_var_size         ;hl->size of char
    pop de
    ld a,(hl)               ;get size
    add a,e             ;add to cumulative length
    ld e,a              ;save
    pop hl
    inc hl                  ;next byte
    jr get_size
got_size:
    srl e                   ;divide by 2
    pop af              ;center column
    sub e               ;a=center column
    ld (_penCol),a
    pop hl              ;retrieve start of text
    jp _vputs               ;print the text

;=================
;Clear text window
;=================
clearTextWind:
    ld d,7
    ld e,0
    ld hl,WhiteSpace
    call DS_Loop
    ld d,6
    ld e,0
    ld hl,Border
    jp DS_Loop

;================
;Draw text window
;================
drawTextWindow:
    ;Start at row 6, col 0
    ld d,6
    ld e,0
    ld hl,Border
DTW_Loop:
    push de
    push hl
    call GridPutSprite
    pop hl
    pop de

    inc e
    ld a,e
    cp 16
    jr z,DrawSpace

    jr DTW_Loop
DrawSpace:
    ld d,7
    ld e,0
    ld hl,WhiteSpace
DS_Loop:
    push de
    push hl
    call GridPutSprite
    pop hl
    pop de

    inc e
    ld a,e
    cp 16
    ret z

    jr DS_Loop
