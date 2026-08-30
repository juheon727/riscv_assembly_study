.data
a:
	.ascii "Hello World!"
	.byte 0
b:
	.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

.text
.globl main

strcpy:
	lbu t0, 0(a0)
	sb t0, 0(a1)
	beq t0, x0, strcpy_end
	addi a0, a0, 1
	addi a1, a1, 1
	jal x0, strcpy
	
strcpy_end:
	jalr x0, 0(ra)

main:
	la a0, a
	la a1, b
	jal ra, strcpy
	
	la a0, b
	li a7, 4
	ecall
	
	li a7, 10
	ecall
