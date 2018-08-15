;===========================================================
; Mapper :: MiniRPG
;
; Description: Draws the map(ground, tress, buildings,etc)
;
;===========================================================

;================================================
; DrawMap Routine
; Description:
;   Draws sprites onto screen according to map
;
; Input: None
; Output:
;   Sprites drawn onto screen
;
; Destroys/Modifies: DE, HL, BC, A
;================================================

DrawMap:
    ld de,$0000            ; start drawing at (0, 0)
DrawMapL:
    push hl                ; save map pointer
    ld a,(hl)              ; get the current tile
    ld bc,spriteList       ; load the start of the sprites
    cp 0
    jr z,DrawMap2
DM_loop:
    inc bc
    inc bc
    dec a
    jr nz,DM_loop
DrawMap2:
    push de                ; save sprite draw location
    push bc
    pop hl
    call _ldHLind
    call GridPutSprite     ; draw the sprite
    pop de                 ; restore sprite draw location
    pop hl                 ; restore map pointer
    inc hl                 ; go to next tile
    inc e                  ; move location to the right
    bit 4,e                ; if the 5th bit (e = 16), we're done
    jr z,DrawMapL          ; only jump if the row isn't complete
    ld e,0                 ; draw at the left again
    inc d                  ; move location down a row
    bit 3,d                ; check if it's done (e = 8)
    ret nz                 ; return if we're done
    jr DrawMapL            ; jump back to the top of the loop

;===========================================================
; DrawMapXY Routine
; Description:
;   Used to draw a sprite in a particular location
;   Mainly used after a char sprite "walks" over something
;
; Input: DE: Sprite location (D = ROW, E = COL)
;
; Output: Sprite drawn at loc
;
; Destroys/Modifies: HL, BC, DE, A
;============================================================
DrawMapXY:
    call LoadMap
    ;Get bc to correct position
    ld a,d
    cp 0
    jr z,row_correct
row_loop:
    ld bc,16
    add hl,bc
    dec a
    jr nz,row_loop
row_correct:
    ld c,e
    ld b,0
    ld a,e
    add hl,bc
col_correct:
    push hl
    pop bc
    ;Find correct sprite
    ld hl,spriteList
    ;Read tileMap byte
    ld a,(bc)
    ;Make sure a is not zero
    cp 0
    jr z,DMXY_Draw
DMXY_Loop:
    inc hl
    inc hl
    dec a
    jr nz,DMXY_Loop
DMXY_Draw:
    ;Load hl,(hl)
    call _ldHLind
    ;Will destroy most registers
    call GridPutSprite
    ret

;==========================================
; GetMapXY Routine
; Description:
;   Gets tile num at specified location
;
; Input: HL: PTR to tileMap, DE: Row,Col
; Outpu: A equ tile map num
;==========================================
GetMapXY:
    ;Get hl to correct position
    ld a,d
    cp 0
    jr z,GMrow_correct
GMrow_loop:
    ld bc,16
    add hl,bc
    dec a
    jr nz,GMrow_loop
GMrow_correct:
    ld c,e
    ld b,0
    add hl,bc
GMcol_correct:
    ld a,(hl)
    ret

