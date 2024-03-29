;=======================================
;
; MiniRPG::Main/Credit Page
;
; Description: Gives version info, etc.
;
;=======================================

; Number of msgs
NUM_MSG         equ 11
NUM_ROWS        equ 5

START_Y         equ 10
PADDING_X       equ 5
PADDING_Y       equ 9

MainMenu:
; Initialize Variables
init:
    xor a
    ld (scroll_pos),a

title_screen:
    ; Display title at top
    call _clrLCD
    ld hl,0
    ld (_curRow),hl
    ld (_curCol),hl
    ld hl,tTitle
    call _puts

    ;Display title at bottom
    ld hl,7
    ld (_curRow),hl
    ld hl,bTitle
    call _puts

;Prepare to draw
dml_init:
    ld hl,msgList
    ld a,(scroll_pos)
    ld b,a
    cp 0
    jr z,dml
mLoop:
    inc hl
    inc hl
    djnz mLoop
dml:
    ; Setup the start pixel
    ld b,START_Y
    push hl
drawMsgList:
    call _ldHLind

    ld a,PADDING_X
    ld (_penCol),a
    ld a,b
    ld (_penRow),a
    call _vputs

    ; Pop old hl value to hl
    pop hl
    ; inc twice to get to next address
    inc hl
    inc hl
    ; Push new value on stack
    push hl

    ; Move the pen down to next row
    ld a,PADDING_Y
    add a,b
    ld b,a

    ; Increment pos & check to see if we've hit the maximum number of
    ; rows we can draw.
    inc d
    ld a,d
    ;Number of msgs allowed on screen
    cp NUM_ROWS
    jr nz,drawMsgList
    ; Finished with drawing
    pop hl

title_loop:
    call _getkey

    cp kF1
    jr z,GameStart

    cp kExit
    jr z,Exit

    cp kUp
    jr z,scroll_up

    cp kDown
    jr z,scroll_dn

    jr nz,title_loop
    jr Exit

scroll_up:
    ld a,(scroll_pos)
    cp 0
    jr z,title_loop
    dec a
    ld (scroll_pos),a
    jp title_screen

scroll_dn:
    ld a,(scroll_pos)
    ld d,5
    add a,5
    cp NUM_MSG
    jr z,title_loop
    ld a,(scroll_pos)
    inc a
    ld (scroll_pos),a
    jp title_screen

;Scroll position
scroll_pos: .db 0

;Top Title
tTitle:  .db " MiniRPG",0
;Bottom Title
bTitle:  .db " Scroll With Up/Down",0

;Msg List
msgList:
    .dw m0
    .dw m1
    .dw m2
    .dw m3
    .dw m4
    .dw m5
    .dw m6
    .dw m7
    .dw m8
    .dw m9
    .dw m10

;Messages to scroll
m0: .db 0
m1: .db "MiniRPG v. 5.0",0
m2: .db "Created By: Andrew Huynh(A.H)",0
m3: .db "Press [F1] to start/load game",0
m4: .db "Press [EXIT] to exit program",0
m5: .db 0
m6: .db "Greets to...",0
m7: .db "Eimantas K.",0
m8: .db "Danny W.",0
m9: .db "Fredy M.",0
m10: .db "Others i forgot...",0