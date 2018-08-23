ShowText:
    ;Save text ptr to be used later.
    push hl

    ;Draw TextWindow
    call drawTextWindow

    pop hl

    ;Show text
    call drawText

    ret

drawText:
    ;Init variables
    ld d,52
    ld e,4
    ld (_penCol),de
    ;Num of text counter
    ld c,0
dt_loop:
    ;Inc counter
    inc c
    ;Check for 0, meaning end of text
    ;Check for 255, meaning prompt
    ld a,(hl)
    cp 0
    jr z,dt_scroll
    cp 255
    jr z,dt_prompt
    ;Preserve hl
    push hl
    ;ld hl,(hl), display text
    call _ldHLind
    call _vputs
    ;Restore hl
    pop hl
    ;Prepare for next line of text
    ld d,58
    ld e,4
    ld (_penCol),de
    ;Display 2 lines of text?
    ld a,c
    cp 2
    jr z,dt_scroll
    ;Inc hl to next text line
    inc hl
    inc hl
    jr dt_loop
dt_scroll:
    ;Preserve hl
    push hl
    ld a,(hl)
    cp 0
    call nz,hasMoreText
dt_wait:
    call waitkey
    cp SND
    jr nz,dt_wait
    pop hl
    ld a,(hl)
    cp 0
    ret z
    push hl
    call clearTextWind
    pop hl
    ld c,0
    ld d,52
    ld e,4
    ld (_penCol),de
    jr dt_loop
dt_prompt:
    xor a
    ld (prompt_loc),a
    ;To be used later
    inc hl
    push hl
    ;Clear text wind
    call clearTextWind

        ;Draw pointer
    ld d,52
    ld e,4
    ld (_penCol),de
    ld hl,pointer
    call _vputs

    pop hl
    push hl
    call _ldHLind
    ;Draw First prompt option
    ld d,52
    ld e,15
    ld (_penCol),de
    call _vputs

    pop hl
    inc hl
    inc hl
    push hl
    call _ldHLind
    ;Draw Second prompt option
    ld d,58
    ld e,15
    ld (_penCol),de
    ld hl,NO
    call _vputs
dt_prompt_key:
    call waitkey
    cp UP
    jr z,prompt_up
    cp DN
    jr z,prompt_down
    cp SND
    jr z,prompt_done
    jr dt_prompt_key
prompt_up:
    xor a
    ld (prompt_loc),a

    ld d,58
    ld e,8
    ld (_penCol),de
    ld hl,space
    call _vputs

    ld d,52
    ld e,8
    ld (_penCol),de
    ld hl,pointer
    call _vputs

    jr dt_prompt_key
prompt_down:
    ld a,1
    ld (prompt_loc),a
    ld d,52
    ld e,8
    ld (_penCol),de
    ld hl,space
    call _vputs
    ld d,58
    ld e,8
    ld (_penCol),de
    ld hl,pointer
    call _vputs
    jr dt_prompt_key
prompt_done:
    pop hl
    inc hl
    inc hl
    ld a,(prompt_loc)
    cp 0
    jr z,loc_ok
    ld bc,5
    add hl,bc
loc_ok:
    ; If 0, display text and end
    ld a,(hl)
    cp 0
    jr z,pend_display
    cp 1
    jr z,pend_exec
    ret

pend_display:
    push hl
    call clearTextWind
    ld d,52
    ld e,4
    ld (_penCol),de
    pop hl
    inc hl
    ld c,0
    jp dt_loop

pend_exec:
    ;Display text and execute some code
    push hl
    call clearTextWind
    ld d,52
    ld e,4
    ld (_penCol),de
    ;Display text
    pop hl
    inc hl
    push hl
    call _ldHLind
    call _vputs

    ;Location to execute
    pop hl
    ;Get hl to right location
    inc hl
    inc hl
    call _ldHLind
    call waitkey
    ;Jp to code to execute, must return in code
    jp (hl)

hasMoreText:
    ld d,7
    ld e,15
    ld hl,MoreText
    call GridPutSprite
    ret

prompt_loc: .db 0
pointer: .db 5,0
space: .db "     ",0
;Used for prompt
YES: .db "Yes!",0
NO:  .db "No...",0
