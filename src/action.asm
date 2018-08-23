;=====================================================
; Action :: MiniRPG
; Description:
;   Handles player actions when 2ND key is pressed
;
;=====================================================

;Action Objects
SIGN = 13
TABLE = 26
SOLDIER = 30
SOLDIER2 = 31

Action:
    ;Determine where char is facing
    call LoadState
    ld a,(hl)
    ;Action Up
    cp 0
    jr z,Action_Up
    cp 1
    jr z,Action_Right
    cp 2
    jr z,Action_Down
    cp 3
    jr z,Action_Left
Action_Up:
    call LoadPosROWCOL
    dec d
    jr Action2
Action_Right:
    call LoadPosROWCOL
    inc e
    jr Action2
Action_Down:
    call LoadPosROWCOL
    inc d
    jr Action2
Action_Left:
    call LoadPosROWCOL
    dec e
Action2:
    ;Determine if there is an action to begin with
    ;Preserve location for later
    push de
    call LoadMap
    call GetMapXY
    pop de
    ;Sign?
    cp SIGN
    jr z,SignAction
    ;Table?
    cp TABLE
    jr z,TableAction
    ;Soldier?
    cp SOLDIER
    jr z,SoldierAction
    cp SOLDIER2
    jr z,SoldierAction
    ;Check for NPC
    call CheckNPC
    cp 0
    jr nz,NPCAction
    ;No Actions, go back to key loop
    jp key_loop

SignAction:
    ;Get to Sign List
    call LoadMapStruct
    ld bc,10
    add hl,bc
    ;No signlist? go back to key_loop
    ld a,(hl)
    cp 0
    jp z,key_loop
    ;Load hl,(hl)
    call _ldHLind
SignLoop:
    ;Load Row,Col into bc
    ld b,(hl)
    inc hl
    ld c,(hl)
    ;Find correct sign
    call CompareDEBC
    cp 0
    jr z,SignFound
    ;Get to next sign if not the right one
    inc hl
    inc hl
    inc hl
    ;End of Sign list?
    ld a,(hl)
    cp 255
    jp z,key_loop
    ;Loop again
    jr SignLoop
SignFound:
    ;Sign has been found display text
    inc hl
    ;Load the Sign Text
    call _ldHLind
    ;Display text
    call ShowText
    ;Refresh Map
    call DrawStruct
    jp key_loop

;Table only has one examine text
TableAction:
    ld hl,TableText
    call ShowText
    jp GameLoop
    jp key_loop

;Soldiers only have one examine text
SoldierAction:
    ld hl,SoldierText
    call ShowText
    jp GameLoop

NPCAction:
    ;Load the Conversation into hl
    call LoadNPCText
    ;Does NPC have text to say?
    ld a,(hl)
    cp 0
    ;If not jp to key_loop
    jp z,key_loop
    call ShowText
    jp GameLoop

;Compares DE and BC
CompareDEBC:
    ;Preserve the hl register
    push hl
    ;Push and Pop DE into HL
    push de
    pop hl
    ;Substract bc from hl
    sbc hl,bc
    ;Top byte zero?
    ld a,h
    cp 0
    jr nz,CompareNo
    ;Lower byte zero?
    ld a,l
    cp 0
    jr nz,CompareNo
    pop hl
    ;Both bytes zero, meaning HL == 0
    xor a
    ret
CompareNo:
    pop hl
    ;Not Zero
    ld a,1
    ret



