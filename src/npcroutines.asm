;==================================
;
; Handles NPC Drawing/Animation
; Keeps track of all NPCs on screen
;
;==================================

;======================================================
; DrawNPC Routine
; Description:
;   Draws NPC
; Input: None
; Output: NPC is drawn
; Destroys: HL,BC,AF
;======================================================
DrawNPC:
    ;Load NPC List
    call LoadNPC
    ld a,(hl)
    ;Has NPCs?
    cp 0
    ret z
    call _ldHLind
DrawNPC2:
    ;Load Pos into de
    ld d,(hl) ;Row
    inc hl
    ld e,(hl) ;Col
    inc hl
    ld a,(hl) ;State
    inc hl
    inc hl
    ;Preserve Registers for later
    push hl
    push af
    ;Get to Anim Struct
    call _ldHLind
    pop af
    ;Is Anim struct in right place?
    cp 0
    jr z,DrawNPC3
DrawNPC_Loop:
    ;Not in right place loop until in right place
    inc hl
    inc hl
    dec a
    jr nz,DrawNPC_Loop
DrawNPC3:
    ;Draw NPC
    call _ldHLind
    call GridPutSprite
    pop hl
    ;Get to next npc
    ld bc,4
    add hl,bc
    ;End of NPC List?
    ld a,(hl)
    cp 255
    ret z
    ;Repeat process
    jr DrawNPC2


;============================================
;Checks to see if player collides into a NPC
;============================================

CheckNPC:
    ;Load NPC List
    call LoadNPC
    ld a,(hl)
    ;No NPCs?
    cp 0
    jr z,NPCNo
    call _ldHLind
CheckNPC_Loop:
    ;Load the NPC Position into BC
    ld b,(hl)
    inc hl
    ld c,(hl)
    call CompareDEBC
    cp 0
    jr z,NPCYes
    ld bc,8
    add hl,bc
    ;End of NPC List?
    ld a,(hl)
    cp 255
    jr nz,CheckNPC_Loop
;No NPCs/No collision detected/End of NPC List
NPCNo:
    xor a
    ret
;NPC Collision Detected
NPCYes:
    ld a,1
    ret

;Loads npc conversation into HL
LoadNPCText:
    call LoadNPC
    ld a,(hl)
    cp 0
    jr z,LTErr
    call _ldHLind
LTLoop:
    ld b,(hl)
    inc hl
    ld c,(hl)
    call CompareDEBC
    cp 0
    jr z,LTFound
    ld bc,8
    add hl,bc
    ld a,(hl)
    cp 255
    jr nz,LTLoop
LTErr:
    ;NPC Text not found for some reason
    ld hl,0
    ret
LTFound:
    ld bc,5
    add hl,bc
    call _ldHLind
    ret

;Load NPC List
LoadNPC:
    call LoadMapStruct
    ld bc,12
    add hl,bc
    ret
