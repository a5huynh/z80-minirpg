#include "../../includes/ti86.inc"

;=======================================================
; GameLoop :: MiniRPG
; Description:
;   Handles the main game event loop
;
;=======================================================

GameLoop:
    ;Draws NPCs, map, char
    call DrawStruct
    call Mover
    ret

DrawStruct:
    ;Draw Map, Character, NPCs
    call LoadMap
    call DrawMap
    call DrawNPC
    ret

;============================================
; Load Routines. Load Something into hl or de
; Store Routines. Store something from A or hl
; Description:
;   Basically the backbone of the program
;   All important data is retrieved using the
;   functions listed here
;===========================================
;Load Map Structure, checks to see whether user is in a house
LoadMapStruct:
    call LoadInHouse
    cp 0
    jr z,LoadMapStruct2
    ld hl,PlayerInfo+6
    call _ldHLind
    ret
LoadMapStruct2:
    ld hl,PlayerInfo
    call _ldHLind
    ret

;Store Map Structure
StoreMapStruct:
    call LoadInHouse
    cp 0
    jr z,SMS
    ld (PlayerInfo+6),hl
    ret
SMS:
    ld (PlayerInfo),hl
    ret

;Load Map/HouseMap, checks to see whether user is in a house
LoadMap:
    ;Check to see if the player is in a house
    call LoadInHouse
    cp 0
    jr z,LoadMap2
    ;If in house load houseMap
    ld hl,PlayerInfo+6
    inc hl
    inc hl
    call _ldHLind
    ret
;If not in house load regular map
LoadMap2:
    call LoadMapStruct
    call _ldHLind
    ret

;Load Player Row Position
LoadPosROW:
    call LoadInHouse
    cp 0
    jr z,LPR2
    ld hl,PlayerInfo+8
    ret
LPR2:
    ld hl,PlayerInfo+2
    ret

;Store Player Row Position
StorePosROW:
    push af
    call LoadInHouse
    cp 0
    jr z,SPR
    pop af
    ld (PlayerInfo+8),a
    ret
SPR:
    pop af
    ld (PlayerInfo+2),a
    ret

;Load Player Col Position
LoadPosCOL:
    call LoadInHouse
    cp 0
    jr z,LPC
    ld hl,PlayerInfo+9
    ret
LPC:
    ld hl,PlayerInfo+3
    ret

;Store Player Col Position
StorePosCOL:
    push af
    call LoadInHouse
    cp 0
    jr z,SPC
    pop af
    ld (PlayerInfo+9),a
    ret
SPC:
    pop af
    ld (PlayerInfo+3),a
    ret

;Load Player Row And Col into de
LoadPosROWCOL:
    call LoadPosROW
    ld a,(hl)
    ld d,a
    call LoadPosCOL
    ld a,(hl)
    ld e,a
    ret

StorePosROWCOL:
    ld a,d
    call StorePosROW
    ld a,e
    call StorePosCOL
    ret

;Load Player State
LoadState:
    call LoadInHouse
    cp 0
    jr z,LoadState2
    ld hl,PlayerInfo+10
    ret
LoadState2:
    ld hl,PlayerInfo+4
    ret

;Store Player State
StoreState:
    push af
    call LoadInHouse
    cp 0
    jr z,StoreState2
    pop af
    ld (PlayerInfo+10),a
    ret
StoreState2:
    pop af
    ld (PlayerInfo+4),a
    ret

;Load Whether Player is in a house
LoadInHouse:
    ld a,(PlayerInfo+5)
    ret
StoreInHouse:
    ld (PlayerInfo+5),a
    ret

;Load Character Animation Structure
LoadCharAnim:
    ld hl,PlayerInfo+8
    call _ldHLind
    ret
StoreCharAnim:
    ld (PlayerInfo+8),hl
    ret
