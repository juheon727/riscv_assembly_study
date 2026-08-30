.data
n:
	.dword 8
	
.text
.globl main

main:
	la t0, n
	ld a0, 0(t0)
	
	jal ra, compute_factorial
	
	li a7, 1
	ecall
	
	li a7, 10
	ecall
	
#Input: n in a0, Output: a0 as the factorial value.
compute_factorial:
	beq a0, x0, base_case

	addi sp, sp, -16
	sd ra, 0(sp)
	sd a0, 8(sp)
	
	addi a0, a0, -1
	jal ra, compute_factorial
	
	ld a1, 8(sp)
	mul a0, a0, a1
	
	ld ra, 0(sp)
	addi sp, sp, 16
	
	jalr x0, 0(ra)
	
base_case:
	li a0, 1
	jalr x0, 0(ra)
	