#include "../src/includes/ti86.inc"

.org _asm_exec_ram

    call _clrLCD
    ld a,0
    ld (_curRow),a
    ld a,0
    ld (_curCol),a
    ld hl,String
    call _puts
    call _getkey
    ret

String: .db "Made in @asm!", 0
.end