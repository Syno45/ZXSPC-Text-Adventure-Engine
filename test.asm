


ld hl,start_polje
main_loop:
	ld a, 0
	ld (input), a
	push hl
ucitaj_input

	call getch					; ucitamo jedan karakter
	push af
	rst 10h						; ispisemo isti
	pop af

	;ld a,(LAST_K)
	;cp 13
	;call z,ispisi_komandu
	ld b, a 					; ako nije \n dodamo ga na string
	cp 13
	push af
	call nz,dodaj_karakter
	pop af
	jp nz,ucitaj_input

	
	push de
	;ld a,1
	;ld (23659), a   			; df-sz
	;ld (23682), a
	;call 0DFEh
	call 0D6Bh
	pop de
	call nadji_komandu
	pop hl
	call komchk
	call grafika1
	push hl
	call draw_all
	pop hl

jp main_loop

;setuje hl na adresu poslednjeg unetog karaktera
;zatim u hl postavlja 0 i ceka da se ona promeni
getch
ld hl,LAST_K
ld (hl),0
;ceka da se promeni karakter
cekaj
ld a,(hl)
cp 0
jr z,cekaj
ret

;dodaje zadati karakter iz registra b
;na kraj stringa cija je pocetna adresa u hl
dodaj_karakter:
ld hl,input
call idi_do_kraja
ld (hl),b
inc hl
ld (hl),0
ret

;u hl-u uzima adresu stringa
;i u hlu vraca adresu gde je 0
idi_do_kraja:
ld a,(hl)
or a
ret z
inc hl
jp idi_do_kraja

;podim input i d-tu komandu
;vraca mi u registru e broj komande ako ju je nasao,
;ili 0 ako je nije nasao
str_cmp
ld hl,input
proveri_str
;ispisi karaktere
;ld a,(hl)
;rst 10h
;ld a,(bc)
;rst 10h
;izadji ako su razliciti
ld a,(bc)
cp (hl)
ret nz
;izadji ako si stigao do kraja stringa
ld a,(bc)
or a
jp z, nasao_komandu

inc hl
inc  bc
jp proveri_str

;ako je nasao komandu, vraca redni broj te komande
;ako nije nasao komandu, vraca 0 i ispisuje wrong command
nasao_komandu
ld e,d
ret

ispisi_komandu:
vrtic
ld a,(bc)
cp 0
ret z
rst 10h
inc bc
jp vrtic


;ucitam sve komande u hl
;i idem redom i poredim ih sa inputom
;d je broj trenutne komande
;e je output
nadji_komandu:
ld e,0
ld d,1
ld hl,komande
prodji_kroz_sve_komande
ld c,(hl)
inc hl
ld b,(hl)
inc hl

ld a, b
or c
ret z

push hl
call str_cmp
pop hl

ld a,e
cp 0
jp nz,rez

ld a,(hl)
cp 0
jp z,rez

ld a,(br_kom)
cp d
ret z

inc d
jp prodji_kroz_sve_komande

;ako je e 0, znaci da je losa komanda
;ako je e razlicito od 0, znaci da je fina komanda i
;treba je proslediti dalje
rez
ld a,e
cp 0
jp nz, dobar
;zameni input sa 0
losa_kom:
ld hl,odgovori
ld c,(hl)
inc hl
ld b,(hl)
call ispisi_komandu
call obrisi_i
ret 
dobar:
ld a,e
call obrisi_i
ret

obrisi_i
ld hl,input
obrisi
ld a,(hl)
cp 0
ret z
ld (hl),0
inc hl
jp obrisi



;
komchk
	ld a,e
	cp 0
	jp nz,zero_e
zero

	jp komchk_end
zero_e

	cp 1
	jp nz,one_e
one
	ld a,%10000000
	and (hl)
	cp %10000000
	jp nz, komchk_ce

	ld bc,MATRIX_W
	sbc hl,bc
	ld a,(hl)
	and %11111101
	or %00000001
	ld (hl),a
	jp komchk_end
one_e

	cp 2
	jp nz,two_e
two
	ld a,%01000000
	and (hl)
	cp %01000000
	jp nz,komchk_ce

	ld bc,MATRIX_W
	add hl,bc
	ld a,(hl)
	and %11111100
	ld (hl),a
	jp komchk_end

two_e

	cp 3
	jp nz,three_e
three
	ld a,%00100000
	and (hl)
	cp %00100000
	jp nz,komchk_ce

	inc hl
	ld a,(hl)
	and %11111100
	or %00000011
	ld (hl),a
	jp komchk_end
three_e

	cp 4
	jp nz,four_e
four
	ld a,%00010000
	and (hl)
	cp %00010000
	jp nz,komchk_ce

	dec hl
	ld a,(hl)
	and %11111100
	or %00000010
	ld (hl),a
	jp komchk_end
four_e


	cp 5
	jp nz,five_e
five

	ld bc,MATRIX_SCD
	add hl,bc
	ld a,%10000000
	and (hl)
	push af
	sbc hl,bc
	pop af
	cp %10000000
	jp nz,komchk_ce

	ld de,MATRIX_D
	add hl,de
	ld a,(hl)
	and %11111101
	or %00000001
	ld (hl),a
	jp komchk_end

five_e

	cp 6
	jp nz,six_e
six

	ld bc,MATRIX_SCD
	add hl,bc
	ld a,%10000000
	and (hl)
	push af
	sbc hl,bc
	pop af
	cp %10000000
	jp nz,komchk_ce
	
	ld de,MATRIX_D
	add hl,de
	ld a,(hl)
	and %11111100
	ld (hl),a
	jp komchk_end 

six_e

	cp 7
	jp nz,seven_e
seven

	ld bc,MATRIX_SCD
	add hl,bc
	ld a,%00100000
	and (hl)
	push af
	sbc hl,bc
	pop af
	cp %00100000
	jp nz,komchk_ce
	
	ld de,MATRIX_D
	add hl,de
	ld a,(hl)
	and %11111100
	or %00000011
	ld (hl),a
	jp komchk_end

seven_e

	cp 8
	jp nz,eight_e
eight

	ld bc,MATRIX_SCD
	add hl,bc
	ld a,%00010000
	and (hl)
	push af
	sbc hl,bc
	pop af
	cp %00010000
	jp nz,komchk_ce
	
	ld de,MATRIX_D
	add hl,de
	ld a,(hl)
	and %11111100
	or %00000010
	ld (hl),a
	jp komchk_end

eight_e

	cp 9
	jp nz,nine_e
nine

	ld bc,MATRIX_SCD
	add hl,bc
	ld a,%00001000
	and (hl)
	push af
	sbc hl,bc
	pop af
	cp %00001000
	jp nz,komchk_ce
	
	ld de,MATRIX_D
	sbc hl,de
	ld a,(hl)
	and %11111101
	or %00000001
	ld (hl),a
	jp komchk_end	

nine_e

	cp 10
	jp nz,ten_e
ten

	ld bc,MATRIX_SCD
	add hl,bc
	ld a,%00000100
	and (hl)
	push af
	sbc hl,bc
	pop af
	cp %00000100
	jp nz,komchk_ce
	
	ld de,MATRIX_D
	sbc hl,de
	ld a,(hl)
	and %11111100
	ld (hl),a
	jp komchk_end	

ten_e

	cp 11
	jp nz,elev_e
elev

	ld bc,MATRIX_SCD
	add hl,bc
	ld a,%00000010
	and (hl)
	push af
	sbc hl,bc
	pop af
	cp %00000010
	jp nz,komchk_ce
	
	ld de,MATRIX_D
	sbc hl,de
	ld a,(hl)
	and %11111100
	or %00000011
	ld (hl),a
	jp komchk_end

elev_e

	cp 12
	jp nz,twel_e
twel

	ld bc,MATRIX_SCD
	add hl,bc
	ld a,%00000001
	and (hl)
	push af
	sbc hl,bc
	pop af
	cp %00000001
	jp nz,komchk_ce
	
	ld de,MATRIX_D
	sbc hl,de
	ld a,(hl)
	and %11111100
	or %00000010
	ld (hl),a
	jp komchk_end

twel_e

komchk_ce
	push hl
	ld hl,odgovori
	inc hl
	inc hl
	ld c,(hl)
	inc hl
	ld b,(hl)
	call ispisi_komandu
	pop hl

komchk_end
	ret

pp: db %10000000
br_kom db 12
komanda: db 0
kom1: db "go n",0
kom2: db "go s",0
kom3: db "go e",0
kom4: db "go w",0
kom5: db "go up n",0
kom6: db "go up s",0
kom7: db "go up e",0
kom8: db "go up w",0
kom9: db "go down n",0
kom10: db "go down s",0
kom11: db "go down e",0
kom12: db "go down w",0
komande: dw kom1,kom2,kom3,kom4,kom5,kom6,kom7,kom8,kom9,kom10,kom11,kom12,0,0
odg1: db "WRONG COMMAND",13,0
odg2: db "YOU CAN'T GO THERE",13,0
odgovori dw odg1,odg2,0,0
input: db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
LAST_K equ 23560
MATRIX_W equ 21
MATRIX_H equ 6
MATRIX_D equ 126
MATRIX_SCD equ 504
CLRS equ 0E44h



