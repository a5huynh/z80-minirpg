;Menus.

;Menu Formats
;
; Menu Types: (0 = Main Menu, 1 = Item (Armor,weapon,etc), 2 = Spells, 3 = Option)
;
; .db 0         <- Menu Type
; .dw Name      <- First option
; .dw GoToItem  <- Action to execute
; .db 0         <- End of Main Menu
;
; .db 1             <- Menu Type
; .db 0             <- Quantity
; .dw Class         <- Item 'Class'
; .dw Name          <- Item Name
; .dw Description   <- Item Description
; .db 0             <- Option Types (Use, Equip/Unequip)
; .db 255           <- End of Item Menu
;
; .db 2         <- Menu Type
; .db 1         <- Spell Level
; .db 25        <- Energy it takes
; .dw Name      <- Spell Name
; .db 255       <- End of Spell Menu
;
; .db 3         <- Menu Type
; .dw Name      <- Option Name
; .db 0         <- Activated(0), Not Activated(1)
; .db 255       <- End of Option Menu

;================
;Main Menu Data
;================
MainMenuText:
    .db 0
    .dw MMT1
    .dw MenuItem
    .dw MMT2
    .dw MenuWeapon
    .dw MMT3
    .dw MenuArmor
    .dw MMT4
    .dw MenuSpell
    .dw MMT5
    .dw MenuOption
    .dw MMT6
    .dw Exit
    .db 0

MMT1:   .db "Items",0
MMT2:   .db "Weapons",0
MMT3:   .db "Armor",0
MMT4:   .db "Spells",0
MMT5:   .db "Options",0
MMT6:   .db "Back to Game",0

MenuItem:
    ld hl,Items
    jp PopulateMenu
MenuWeapon:
    ld hl,Weapons
    jp PopulateMenu
MenuArmor:
    ld hl,Armor
    jp PopulateMenu
MenuSpell:
    ld hl,Spells
    jp PopulateMenu
MenuOption:
    ld hl,Options
    jp PopulateMenu

Weapons:
Armor:
Spells:
Options:
;=================
;Option Menu Data
;=================

