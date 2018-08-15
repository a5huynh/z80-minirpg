;============================
; Terrain Maps
;
;
;
;==============================================================
; Map Format
; Label:
; 0   .dw MapName  <-PTR to map to use
; 2   .dw MapUp    \
; 4   .dw MapRight  \ Points to map that user will 'exit' to
; 6   .dw MapDn     /
; 8   .dw MapLeft  /
; 10  .dw SignList <- List of signs and examine info
; 12  .dw NPCList  <- List of NPCs to draw
; 14  .dw DoorList <- List of Doors to different HouseMaps
;===============================================================

;===============================================================
; House Map Format
; Label:
; 0   .db 0,0       <- Entrance, where user starts and exits
; 2   .dw MapName   <- PTR to map to use
; 4   .dw MapUp     \
; 6   .dw MapRight   \ Points to map that user will 'exit' to
; 8   .dw MapDn      /
; 10  .dw MapLeft   /
; 12  .dw NPCList   <- List of NPCs to draw
; 14  .dw DoorList  <- List of Doors to different HouseMaps (maybe)
;===============================================================

;==============================
; Sign List Format
; 0   .db X,Y   <- Location of Sign
; 2   .dw Text  <- Text to 'say'
; 4   .db 255   <- End of Sign List
;==============================

;===============================
; NPC List Format
; 0   .db X,Y,S <- Row, Col, State
; 3   .db 0     <- Animated?
; 4   .dw Label <- Animation Struct
; 6   .dw Label <- NPC Conversation
; 8   .db 255   <- End of NPC List
;===============================

;==================================
; Door List Format
; 0   .db X,Y   <- Location of Door
; 2   .dw Label <- HouseMap
; 4   .db 255   <- End of Door List
;==================================

StarKinCastle:
    .dw map00
    .dw 0 ;No exit up
    .dw SKC2
    .dw 0 ;No exit down
    .dw 0 ;No exit left
    .dw 0 ;No signs
    .dw NPC1 ;List of npcs
    .dw 0
    
SKC2:
    .dw map01
    .dw 0
    .dw 0
    .dw 0
    .dw StarKinCastle
    .dw 0
    .dw 0
    .dw 0

NPC1:
    .db 3,3,0 ;<- Loc of NPC, NPC Current State
    .db 0   ;<- Animated?
    .dw King;<- NPC Anim Block
    .dw StarkinKing ;Conversation Text
    .db 255   ;<- End of NPC Struct
  
map00:
    .db 11,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10 
    .db  7,25,25,30,25,30,25,30,25,30,25,30,25,30,25,25
    .db  7,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25
    .db  7,25,26,25,25,25,25,25,25,25,25,25,25,25,25,25
    .db  7,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25
    .db  7,25,25,31,25,31,25,31,25,31,25,31,25,31,25,25
    .db  7,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25
    .db  8, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6

map01:
    .db 11,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10 
    .db 25,25,30,25,30,25,30,25,30,25,30,25,30,25,25,25
    .db 25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25
    .db 25,25,26,25,29,28,28,28,28,28,28,28,28,28,27,25
    .db 25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25
    .db 25,25,25,31,25,31,25,31,25,31,25,31,25,31,25,25
    .db 25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25
    .db  8, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6

#include "conversations.asm" ;<- NPC Conversations, Sign Data, others