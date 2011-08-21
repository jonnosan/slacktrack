
.include "common.i"

.zeropage
pptr: .res 2
test_ptr: .res 2

;for debugging
.macro JAM
	.byte $92
.endmacro

.segment "STARTUP"    ;this is what gets put at the start of the file on the C64

.word basicstub		; load address

basicstub:
	.word @nextline
	.word 2003
	.byte $9e 
	.byte <(((init / 1000) .mod 10) + $30)
	.byte <(((init / 100 ) .mod 10) + $30)
	.byte <(((init / 10  ) .mod 10) + $30)
	.byte <(((init       ) .mod 10) + $30)
	.byte 0
@nextline:
	.word 0

init:

	;set funky colours
	lda #$06  ;
    sta $D020 ;border
    lda #$00	;dark blue
    sta $D021 ;background

	ldax #banner
	jsr	print
	
	jsr	load_irq
	jsr	get_key
	jsr	unload_irq
	
	rts
	
irq_handler:

	inc	$d020
	ldx	#0
:
	dex
	bne	:-
	dec	$d020
	jmp	(old_irq)
load_irq:
	sei
	ldax	$314
	stax	old_irq
	ldax	#irq_handler
	stax	$314
	cli
	rts	
unload_irq:
	sei
	ldax	old_irq
	stax	$314
	cli	
	rts


.data

banner:
.byte $93 ;CLS
.byte $9a;
.byte $0d,"SLACKTRACK 0.1"
.include "timestamp.i"
.byte $0d
.byte 0


.bss
	old_irq:	.res 2
	