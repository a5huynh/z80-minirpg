#include "includes/ti86.inc"

;============================
; MiniRPG :: Main Program
;
; Description:
;   Loads Grayscale routines, other basic loading/initializing stuff
;
;
;============================

;Constants
;Keys
EXIT  = 1
UP    = 2
DN    = 3
RT    = 4
LF    = 5
ENTER = 6

.org _asm_exec_ram

    nop
    jp ProgStart
    .dw 0
    .dw ShellTitle

ShellTitle:
    .db "MiniRPG v. 5.0 by A.H",0

;Start program
ProgStart:
    call _runIndicOff
    jp MainMenu

;Start up grayscale
GameStart:
    call LoadGreyscale
    call ClearScreen
    ; in core/engine/main.asm
    call GameLoop

;Exit Program
Exit:
    call CloseGrey
    call _clrLCD
    call _homeUp
    jp ClearScreen

#include "MainMenu.asm"
#include "routines.asm"

; Main game engine
#include "core/engine/main.asm"
#include "core/engine/mover.asm"
#include "core/engine/items.asm"
#include "MenuData.asm"

#include "core/draw/grayscale.asm"
#include "action.asm"     ;<- Player Actions (Examine, Lever, etc)
#include "mapper.asm"     ;<- Draws Map
#include "npcroutines.asm";<- Draws, Animates NPCS
#include "showtext.asm"   ;<- Display Text (When examining something, etc)

; Assets
; ------------------------------------
; Player Data (Location, Items, etc)
#include "assets/playerinfo.asm"
; Maps used
#include "assets/maps.asm"
; Player, NPC Sprites
#include "assets/sprites/characters.asm"
; Map sprites
#include "assets/sprites/map.asm"
; Menu sprites
#include "assets/sprites/menu.asm"
; Text, Item Window Sprites
#include "assets/sprites/textwindow.asm"
.end