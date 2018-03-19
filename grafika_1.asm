; =============================================================
; Author: Petar Ratkovic

; Calls the required method depending on the first bit
grafika1:
	ld	a, (hl)
	bit	0, a
	call	z, north_east
	call	nz, south_west
	ret

; Checks the second bit in order to decide between north and east
north_east:
	bit	1, a
	jp	z, north
	jp	nz, east	

; Checks the second bit in order to decide between south and west
south_west:
	bit	1, a
	jp	z, south
	jp	nz, west

north:
	; Sets the 'north' bit to be the same as 'south' bit
	bit	south_bit, a
	call	z, res_north_bit
	call	nz, set_north_bit
	; end

	; ==========================================================
	; This block of code switches two bits (n and m)
	; Here's an example:
	;
	; ld	b, a
	; or	%00110000 This mask depends on n and m
	; bit	m, b
	; jr	nz, $ + 4
	; res	n, a
	; bit	n, b
	; ret	nz
	; res	m, a
	;

	ld	b, a
	or	%00110000
	bit	west_bit, b
	jr	nz, $ + 4
	res	east_bit, a
	bit	east_bit, b
	ret	nz
	res	west_bit, a

	; ==========================================================

	ret

east:
	; Sets the 'east' bit to be the same as 'north' bit
	; Note: this has to go before the next block of code!
	bit	north_bit, a
	call	z, res_east_bit
	call	nz, set_east_bit
	; end

	; Sets the 'north' bit to be the same as 'west' bit
	bit	west_bit, a
	call	z, res_north_bit
	call	nz, set_north_bit
	; end

	; Sets the 'west' bit to be the same as 'south' bit
	bit	south_bit, a
	call	z, res_west_bit
	call	nz, set_west_bit
	; end

	ret

south:
	ret ;Nothing to do, view already adjusted

west:
	; Sets the 'west' bit to be the same as 'north' bit
	; Note: this has to go before the next block of code!
	bit	north_bit, a
	call	z, res_west_bit
	call	nz, set_west_bit
	; end

	; Sets the 'north' bit to be the same as 'east' bit
	bit	east_bit, a
	call	z, res_north_bit
	call	nz, set_north_bit
	; end

	; Sets the 'east' bit to be the same as 'south' bit
	bit	south_bit, a
	call	z, res_east_bit
	call	nz, set_east_bit
	; end

	ret


set_north_bit:
	set	7, a
	ret

res_north_bit:
	res	7, a
	ret

set_south_bit:
	set	6, a
	ret

res_south_bit:
	res	6, a
	ret

set_east_bit:
	set	5, a
	ret

res_east_bit:
	res	5, a
	ret

set_west_bit:
	set	4, a
	ret

res_west_bit:
	res	4, a
	ret

switch_bits:
	push	af
	

	pop	af
	ret

; Sets the bit (index stored in 'bit to set') in the A register
set_bit:
	push	hl
	push	af
	ld	a, (bit_to_set)
	ld	h, a
	pop	af
	or	h
	pop	hl
	ret

; Resets the bit (index stored in 'bit to set') in the A register
res_bit:
	push	hl
	push	af
	ld	a, (bit_to_set)
	xor	%11111111
	ld	h, a
	pop	af
	and	h
	pop	hl
	ret

bit_to_set: db	%10000000

north_bit equ	7
south_bit equ	6
east_bit  equ	5
west_bit  equ	4
