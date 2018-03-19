
draw_all:
	push af
	call empty_room
	pop af

	push af
	bit 4, a
	call nz, door_left
	pop af

	push af
	bit 5, a
	call nz, door_right
	pop af

	push af
	bit 7, a
	call nz, door_center
	pop af
	;call draw_hallway_y
	;call hallway
	ret

empty_room:

;koordinatni pocetak
ld a, 0
ld (coordx), a
ld (coordy), a

;stare vrednosti (0,0) -> (0,255)
ld bc, 255
ld de, 0
call draw_line

;stare vrednosti (0,255) -> (255, 172)
ld bc, 0
ld de, 172
call draw_line

;pocetak nove prave (0, 0)
ld a, 0
ld (coordx), a
ld (coordy), a
;leva ivica rama
ld bc, 0
ld de, 172
call draw_line
;gornja ivica rama
ld bc, 255
ld de, 0
call draw_line

;leva dijagonala od (0,0) koja pici negde priblizno na trecinu
ld a, 0
ld (coordx), a
ld (coordy), a

ld bc, 75
ld de, 58
call draw_line

;donja strana centralnog pravougaonika
ld bc, 105
ld de, 0
call draw_line
;-------------------------------
;donja desna dijagonala unutrasnjeg pravougaonika
ld bc, 75
ld de, 58
call draw_neg_y

;pocetak u nuli i formiranje centralnog pravougaonika
ld a,75
ld (coordx), a
ld a, 58
ld (coordy), a

;desna strana unutrasnjeg pravougaonika
ld bc, 0
ld de, 54
call draw_line
;-------------------------------
;od desne strane gornja strana pravougaonika od leve strane
ld bc, 105
ld de, 0
call draw_line
;-------------------------------
;desna strana pravougaonika (nova linija; leva dijag-donja str; desna)
ld a, 180
ld (coordx), a
ld a, 58
ld (coordy), a
;desna strana
ld bc, 0
ld de, 54
call draw_line
;-------------------------------
;desna dijagonala
ld bc, 75
ld de, 60
call draw_line
;-------------------------------
;gornja leva dijagonala (levi deo rama, gornja leva dijagonala)
ld a, 0
ld (coordx), a
ld a, 172
ld (coordy), a

ld bc, 75
ld de, 59
call draw_neg_y
;-------------------------------
 
ret
hallway: 
	push hl
	ld hl, 5909h
	ld b, 7
loopX:
	ld c, 14 
loopY:
	ld (hl), 0
	inc hl
	dec c
	jp nz, loopY

	ld d, 0
	ld e, 18
	add hl, de

	djnz loopX
	pop hl
	ret	

door_right:
	ld a, 198
	ld (coordx), a
	ld a, 41
	ld (coordy), a
	ld bc, 0
	ld de, 40
	call draw_line
	
	ld bc, 17
	ld de, 11
	call draw_neg_y

	ld bc, 0
	ld de, 40
	call draw_neg_y
	ret

door_center:
	ld a, 120
	ld (coordx), a
	ld a, 58
	ld (coordy), a
	ld bc, 0
	ld de, 20
	call draw_line
	
	ld a, 120
	ld (coordx), a
	ld a, 78
	ld (coordy), a
	ld bc, 20
	ld de, 0
	call draw_line
	
	ld a, 140
	ld (coordx), a
	ld a, 58
	ld (coordy), a
	ld bc, 0
	ld de, 20
	call draw_line
	ret

door_left:
	ld a, 37
	ld (coordx), a
	ld a, 29
	ld (coordy), a

	ld bc, 0
	ld de, 40
	call draw_line
	
	ld a, 37
	ld (coordx), a
	ld a, 69
	ld (coordy), a
	ld bc, 17
	ld de, 11
	call draw_line
	
	ld a, 54
	ld (coordx), a
	ld a, 41
	ld (coordy), a
	ld bc, 0
	ld de, 40
	call draw_line
	ret


draw_line: 
	push de
	call 2d2bh
	pop de
	ld b, d
	ld c, e
	call 2d2bh
	call 24b7h
	ret
draw_neg_y:
	push de
	call 2d2bh
	pop de
	ld b, d
	ld c, e
	call 2d2bh
	rst 28h
	db 0a0h, 01h, 03h, 38h
	call 24b7h
	ret

COORDX EQU 23677
COORDY EQU 23678
