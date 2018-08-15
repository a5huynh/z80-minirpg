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

;Exit Program
Exit:
    call CloseGrey
    call _clrLCD
    call _homeUp
    jp ClearScreen

#include "MainMenu.asm"
#include "routines.asm"
#include "grayscale.asm"

WhiteSpace:
Border:

.end