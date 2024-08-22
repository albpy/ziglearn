	.text
.set __tmp_reg__, 0
.set __zero_reg__, 1
.set __SREG__, 63
.set __SP_H__, 62
.set __SP_L__, 61
	.file	"main"
	.globl	main
	.p2align	1
	.type	main,@function
main:
	sts	197, r1
	ldi	r24, 103
	sts	196, r24
	ldi	r24, 8
	sts	193, r24
	ldi	r24, 6
	sts	194, r24
	sbi	4, 5
	ldi	r24, 0
	ldi	r25, 0
	ldi	r18, 32
.LBB0_1:
	movw	r30, r24
.LBB0_2:
	cpi	r30, 10
	cpc	r31, r1
	brsh	.LBB0_6
	movw	r26, r30
	subi	r26, lo8(-(__anon_769))
	sbci	r27, hi8(-(__anon_769))
	ld	r19, X
.LBB0_4:
	lds	r20, 192
	andi	r20, 32
	cpi	r20, 0
	breq	.LBB0_4
	sts	198, r19
	adiw	r30, 1
	rjmp	.LBB0_2
.LBB0_6:
	in	r19, 5
	eor	r19, r18
	out	5, r19
	rjmp	.LBB0_1
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	; Declaring this symbol tells the CRT that it should
	;copy all variables from program memory to RAM on startup
	.globl	__do_copy_data
	.type	__anon_769,@object
	.section	.rodata.str1.1,"aMS",@progbits,1
__anon_769:
	.asciz	"Hello dear"
	.size	__anon_769, 11

