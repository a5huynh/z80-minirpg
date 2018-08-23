;=============================================================
; Mover :: MiniRPG
; Description:
;   Handles character movement. Handles character drawing
;=============================================================

Mover:
    call DrawChar
    jr key_loop

DrawChar:
    ;Loads Character Animation
    call LoadCharAnim
    push hl
    ;Load State of character
    call LoadState
    ;If state is zero, its fine Draw char
    ld a,(hl)
    pop hl
    cp 0
    jr z,DrawChar2
DC_Loop:
    inc hl
    inc hl
    dec a
    jr nz,DC_Loop
DrawChar2:
    call _ldHLind
    push hl
    ;Loads Player Position into DE
    call LoadPosROWCOL
    pop hl
    call GridPutSprite
    ret

; Main Key Loop
key_loop:
    ;Blocks til key is pressed
    call waitkey
    ;Return back to handler
    cp EXIT
    ret z
    cp SND
    jp z,Action
    cp UP
    jr z,char_up
    cp DN
    jr z,char_down
    cp RT
    jp z,char_right
    cp LF
    jr z,char_left
    cp ENTER
    jr z,enter_action
    ;If none of the keys, go back to key_loop
    jp key_loop

enter_action:
    call ItemMenu
    jp key_loop

char_up:
    xor a
    call CheckCollision
    jr DrawCharOk
char_right:
    ld a,1
    call CheckCollision
    jr DrawCharOk
char_down:
    ld a,2
    call CheckCollision
    jr DrawCharOk
char_left:
    ld a,3
    call CheckCollision
    jr DrawCharOk
DrawCharOk:
    ;Collision? Jump back to key loop
    cp 0
    jr nz,key_loop
    push de
    call LoadPosROWCOL
    call DrawMapXY
    pop de
    call StorePosROWCOL
    call DrawChar
    jr key_loop

;Checks for collisions in specified direction (A)
CheckCollision:
    ;Get Character to face current direction
    call StoreState
    call DrawChar
    ;Load Player Pos into DE
    call LoadPosROWCOL
    ;Load Direction of Player
    call LoadState
    ld a,(hl)
    ;Check collision up
    cp 0
    jr z,CC_UP
    ;Check collision right
    cp 1
    jr z,CC_RIGHT
    ;Check collision down
    cp 2
    jr z,CC_DOWN
    ;Check collision left
    cp 3
    jr z,CC_LEFT
CC_UP:
    ld a,d
    ;cp 0
    ;jr z,MapUp
    dec d
    jr CheckTerrain
CC_RIGHT:
    ld a,e
    ;cp 16
    ;jr z,MapRight
    inc e
    jr CheckTerrain
CC_DOWN:
    ld a,d
    ;cp 8
    ;jr z,MapDown
    inc d
    jr CheckTerrain
CC_LEFT:
    ld a,e
    ;cp 0
    ;jr z,MapLeft
    dec e
CheckTerrain:
    push de
    call LoadMap
    call GetMapXY
    pop de
    ;Grass okay
    cp 0
    jr z,CheckNo
    ;Sand okay
    cp 1
    jr z,CheckNo
    ;Castle Floor
    cp 25
    jr z,CheckNo
    ;House Floor
    ;cp 24
    ;jr z,LoadHouse
    ;Door, "Special Collision"
CheckYes:
    ;Collision Detected
    ld a,1
    ret
CheckNo:
    ;Check for NPC Collision
    call CheckNPC
    cp 0
    jr nz,CheckYes
    xor a
    ret

;Moves to next map
MapUp:
    ;Load Map Structure
    call LoadMapStruct
    ;See if there is a map in that direction
    ld bc,2
    jr MoveMap
MapRight:
    call LoadMapStruct
    ld bc,4
    jr MoveMap
MapDown:
    call LoadMapStruct
    ld bc,6
    jr MoveMap
MapLeft:
    call LoadMapStruct
    ld bc,8
MoveMap:
    add hl,bc
    ;No map? Jump back to key_loop
    ld a,(hl)
    cp 0
    jp z,key_loop
    ;If there is a new map, store it and load it
    call _ldHLind
    call StoreMapStruct
    ;Handles drawing, etc.
    jp GameLoop

;Moves into a house
LoadHouse:
;TODO: Loop thru DoorList looking for correct houseMap, then load





