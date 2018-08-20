
;Player Info
;0   .dw MapName <- Current Map Struct Loc
;2   .db 0,0,0   <- ROW,COL,STATE
;5   .db 0       <- In House?
;6   .dw HouseName <- House Map Struct Loc
;8   .dw Char Anim <- Character Animation Structure (Man, Wizard, Demon)
;10  .db 0,0,0   <- ROW,COL,STATE in house

PlayerInfo:
    .dw StarKinCastle
    .db 3,4,3
    .db 0
    .dw 0
    .dw man_Anim
    .db 0,0,0

;Item List
; .db 1             <- Menu Type (For Menu Function)
; .db 0             <- Quantity
; .dw Name          <- Item/Weapon/Armor Name
; .db 0             <- Option Types ( 0 = Use, 1 = Equip/Unequip)
; .db 255           <- End of Item Menu

;Item/Weapon/Armor Names
; .dw Class         <- Class/Type
; .dw Name          <- Name
; .db 0             <- 0 = Weapon/Armor; 1 = Item; 2 = Does Nothing (Special/Quest Item)
; .db 0             <- Stats (Weapon = Damage, Armor = Defence, Item = Heal)

Items:
    .db 1
    .db 0
    .dw Staff
    .db 1

;Item Types
Food:    .db "Food",0
Quest:   .db "Quest",0
Potion:  .db "Potion",0
Special: .db "Special",0

;Weapon/Armor Classes
Cloth:   .db "Cloth",0
Wood:    .db "Wood",0
Bronze:  .db "Bronze",0
Iron:    .db "Iron",0
Steel:   .db "Steel",0
Myth:    .db "Myth",0
Dragon:  .db "Dragon",0
God:     .db "God",0
Demon:   .db "Demon",0

;Weapon Names
Staff:   .db "Staff",0
Dagger:  .db "Dagger",0
Sword:   .db "Sword",0
BAxe:    .db "B. Axe",0
Mace:    .db "Mace",0
Halberd: .db "Halberd",0

;Armor Names
WRobes:  .db "Wizard Robes",0
Robes:   .db "Robes",0
Chain:   .db "Chain Mail",0
Plate:   .db "Plate",0
Legs:    .db "Legs",0
Helm:    .db "Helm",0
Shield:  .db "Shield",0

;Items
Bread:   .db "Bread",0
Cake:    .db "Cake",0
Energy:  .db "Energy Potion",0
Health:  .db "Health Potion",0

;List of ALL Items/Weapons/Armor in Game
;Items
BBread:
    .dw Food
    .dw Bread
    .dw 2
    .dw 2

CCake:
    .dw Food
    .dw Cake
    .dw 2
    .dw 5

EnergyPot:
    .dw Potion
    .dw Energy
    .dw 2
    .dw 10

HealthPot:
    .dw Potion
    .dw Health
    .dw 2
    .dw 10