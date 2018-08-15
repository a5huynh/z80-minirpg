;Map Viewer, for development

#include "includes/ti86.inc"

.org _asm_exec_ram

    nop
    jp ProgStart
    .dw 0
    .dw ShellTitle

ShellTitle:
    .db "MiniRPG v. 5.0 by A.H",0

;For testing reasons
ProgStart:
    call _runIndicOff
    call LoadGreyscale
    call ClearScreen
    ;Draw Terrain
    ld hl,map01
    call DrawMap

    call waitkey

Exit:
    call ClearScreen
    call CloseGrey
    call _clrLCD
    call _homeUp
    ret

map01:
    .db 11,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10
    .db  7,25,30,25,30,25,30,25,30,25,30,25,30,25,25,25
    .db  7,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25
    .db  7,25,26,25,29,28,28,28,28,28,28,28,28,28,27,25
    .db  7,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25
    .db  7,25,25,31,25,31,25,31,25,31,25,31,25,31,25,25
    .db  7,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25
    .db  8, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6

; Stubs so this can assemble
current_map:
p_posROW:
p_posCOL:
LoadMap:

#include "grayscale.asm"
#include "mapper.asm"
#include "routines.asm"
#include "sprites/map.asm"
#include "sprites/textwindow.asm"
.end