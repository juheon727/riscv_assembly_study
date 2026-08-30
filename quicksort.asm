.data
arr:
	.dword 3, 1, 4, 6, 3, 9, 10, 2

n:
	.dword 8

space:
	.byte 0x20
	.byte 0
	
.text
.globl main

# a0 is the address to array, a1 is l, a2 is r
quicksort:
	bge a1, a2, quicksort_base
	
	addi sp, sp, -8
	sd ra, 0(sp)
	
	addi t1, a1, 1
	addi t2, a2, 0
	
	# Getting the value of pivot = arr[l] and loading to t6
	slli t0, a1, 3
	add t0, t0, a0
	ld t6, 0(t0)
	
quicksort_outerloop:
	bgt t1, t2, quicksort_recursion
	
quicksort_iloop:
	# Loop only if i <= j
	blt t2, t1, quicksort_jloop

	# Getting the value of arr[i] and loading to t3
	slli t0, t1, 3
	add t0, t0, a0
	ld t3, 0(t0)
	
	# Loop only if arr[i] < pivot
	bge t3, t6, quicksort_jloop
	
	addi t1, t1, 1
	jal x0, quicksort_iloop
	
quicksort_jloop:
	# Loop only if i <= j
	blt t2, t1, quicksort_swap
	
	# Getting the value of arr[j] and loading to t3
	slli t0, t2, 3
	add t0, t0, a0
	ld t3, 0(t0)
	
	# Loop only if arr[j] >= pivot
	blt t3, t6, quicksort_swap
	
	addi t2, t2, -1
	jal x0, quicksort_jloop	
	
quicksort_swap:
	blt t2, t1, quicksort_swap_lj

	# Swap i(t1), j(t2) here
	slli t0, t1, 3
	add t0, t0, a0
	ld t3, 0(t0) # t3 has a[i]
	
	slli t5, t2, 3
	add t5, t5, a0
	ld t4, 0(t5) # t4 has a[j]
	
	sd t3, 0(t5)
	sd t4, 0(t0)
	
	jal x0, quicksort_outerloop

quicksort_swap_lj:
	# Swap l(a1), j(t2) here. Pivot value(a[l]) is already stored in t6.
	
	add t0, a1, x0
	slli t0, t0, 3
	add t0, t0, a0
	
	slli t5, t2, 3
	add t5, t5, a0
	ld t4, 0(t5) # t4 has a[j]
	
	sd t6, 0(t5)
	sd t4, 0(t0)
	
	jal x0, quicksort_outerloop
	
quicksort_recursion:
	addi sp, sp, -32
	sd t1, 0(sp)
	sd t2, 8(sp)
	sd a1, 16(sp)
	sd a2, 24(sp)
	
	addi a2, t2, -1
	jal ra, quicksort
	
	ld a1, 8(sp)
	addi a1, a1, 1
	ld a2, 24(sp)
	jal ra, quicksort
	
	ld ra, 32(sp)
	addi sp, sp, 40
	jalr x0, 0(ra)
	
quicksort_base:
	jalr x0, 0(ra)

#a0 is the array address, a1 is the array length
print_array:
	add t0, x0, x0
	addi sp, sp, -8
	sd s0, 0(sp)
	add s0, a0, x0

print_array_loop:
	# Exit if i >= n
	bge t0, a1, print_array_exit
	
	# Load a[i] to a0 and print
	slli t1, t0, 3
	add t1, t1, a0
	ld a0, 0(t1)
	li a7, 1
	ecall
	
	la a0, space
	li a7, 4
	ecall
	
	add a0, s0, x0
	addi t0, t0, 1
	
	jal x0, print_array_loop
	
print_array_exit:
	ld s0, 0(sp)
	addi sp, sp, 8
	jalr x0, 0(ra)

main:
	la a0, arr
	add a1, x0, x0
	ld a2, n
	addi a2, a2, -1
	jal ra, quicksort
	
	la a0, arr
	ld a1, n
	jal ra, print_array
	
	li a7, 10
	ecall
