;===========================================
;
; Items :: MiniRPG
; Description:
;   Handles items. (viewing, receiving, etc)
;
;===========================================

ItemMenu:
    call DrawItemMenu
    ;Always Draw Manu Menu First
    ld hl,MainMenuText
    call PopulateMenu
    call DrawPointer
    jp item_key_loop

;Determines what menu to draw
PopulateMenu:
    call StoreMenu
    ;Check Menu Type
    ld a,(hl)
    cp 0
    jr z,DrawMainMenu   ;Draw Main Menu
    cp 1
    jr z,DrawNormal     ;Draw Normal Menus
    cp 2
    jr z,DrawSpellMenu  ;Draw Spell Menu
    cp 3
    jr z,DrawOptionMenu ;Draw Option Menu

;===============================
; DrawMainMenu
;   Draws the Main Menu
;   TODO: Add scrolling support
;===============================
DrawMainMenu:
    inc hl
    ld d,5
DMM_loop:
    ;Draw Menu Item
    push hl
    call _ldHLind
    ld e,10
    ld (_penCol),de
    call _vputs
    pop hl
    ;Get hl to next menu item
    ld bc,4
    add hl,bc
    ;Check for end of menu
    ld a,(hl)
    cp 0
    ;Return if end of menu
    ret z
    ;If not continue drawing
    ld a,9
    add a,d
    ld d,a
    jr DMM_loop

DrawNormal:
DrawSpellMenu:
DrawOptionMenu:

item_key_loop:
    call waitkey
    cp EXIT
    jp z,exit_item_menu
    ;If not any of the keys go back to key_loop
    jr item_key_loop

exit_item_menu:
    call GameLoop

;=========================
;
; Draw Menu Borders
;
;=========================
DrawItemMenu:
    ld hl,ItemMenuMap
    ld de,$0000            ; start drawing at (0, 0)
DrawItemL:
    push hl                ; save map pointer
    ld a,(hl)              ; get the current tile
    ld bc,ItemMenuSprite   ; load the start of the sprites
    cp 0
    jr z,DrawItemMenu2
DIM_loop:
    inc bc
    inc bc
    dec a
    jr nz,DIM_loop
DrawItemMenu2:
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
    jr z,DrawItemL         ; only jump if the row isn't complete
    ld e,0                 ; draw at the left again
    inc d                  ; move location down a row
    bit 3,d                ; check if it's done (e = 8)
    ret nz                 ; return if we're done
    jr DrawItemL           ; jump back to the top of the loop

DrawPointer:
    ld hl,pointer
    push hl
    jp PStart
ClearPointer:
    ld hl,cpointer
    push hl
PStart:
    ld d,5
    ld e,5
    call LoadPointLoc
    ld b,a
    cp 0
    jr z,DP_Okay
DP_Loop:
    ld a,9
    add a,d
    ld d,a
    djnz DP_Loop
DP_Okay:
    ld (_penCol),de
    pop hl
    call _vputs
    ret

;=====================
;Load/Store Functions
;=====================

;Loads current menu
LoadMenu:
    ld hl,MenuInfo
    ret

StoreMenu:
    ld (MenuInfo),hl
    ret

LoadPointLoc:
    ld a,(MenuInfo+2)
    ret

StorePointLoc:
    ld (MenuInfo+2),a
    ret

;Stores temp info on menu
MenuInfo:
    .dw 0   ;<- Current Menu
    .db 0   ;<- Pointer Location

cpointer: .db "   ",0