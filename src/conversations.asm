;Conversations/Examine Info

;===========================================================
; Conversation Format
; Label:
;   .dw Text to display
;   .db 255 <- Prompt
;   .dw <- First Prompt option
;   .dw <- Second Prompt option
;   ;If first prompt option is selected
;   .db <- 0 = Display Text, 1 = Display Text, Execute Code
;   .dw <- Text to display
;   .dw <- Code to execute, if 1
;   ;Same for second prompt option
;   .db 0 <- End of Conversation
;============================================================

StarkinKing:
    .dw KS1
    .db 0
    
SignInfo:
    .dw SI1
    .dw SI2
    .db 0

SoldierText:
    .dw SE1
    .dw SE2
    .dw SE3
    .dw SE4
    .dw SE5
    .db 0

TableText:
    .dw TT1
    .db 0

KS1: .db "King Fredy: Good luck on your quest!",0

SI1: .db "I'm a sign, examine me for",0
SI2:      .db "important information",0

SE1: .db "Andrew: Hi!!! Wassupp!!!",0
SE2: .db "Soldier: ...",0
SE3: .db "Andrew: Come on talk to me... wimp",0
SE4: .db "Soldier: What did you say?!?!",0
SE5: .db "Andrew: Nothing...",0

TT1: .db "Its a table! Oh boy!",0