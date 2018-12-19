# Who:  Sevan Mardirossian
# What: single_line.asm
# Why:  to print an integer in one line
# When: Created 9/24/2018 Due 9/26/2018
# How:  .space/.word/.asciiz 

.data


arr: .space 80 
ArrSize: .word 20
space: .asciiz " "
start: .asciiz "Please input 20 intgers\n"
input: .asciiz "Enter: "
.text
######################################
.globl main

main:	# program entry
	li $t0, 0 #index
	lw $t1, ArrSize
	la $s1, arr
	li $t2, 0
	li $s2, 0
	
	li $v0, 4
	la $a0, start
	syscall
	
	loop:
		beq $t0, $t1, final
		
		li $v0, 4 
		la $a0, input 
		syscall
		
		li $v0, 5 
		syscall
		move $s2,$v0 

		sw $s2, arr($t2)
		addi $t2,$t2,4 #increminates
		addi $t0,$t0,1 #incremenates
		j loop
	final:
	
	li $t0, 0 #index
	
	while:
		beq $t0, $t1,exit #exits loop after reaching arraySize
		li $v0, 1 #gets ready to print array
		lw $a0, ($s1) #prints array at index of 4,8,12,16 bit..
		syscall
		li $v0, 4
		la $a0, space #print \n
		syscall
		addi $s1,$s1,4 #increminates
		addi $t0,$t0,1 #incremenates
		j while
	exit:
	
	li $v0, 10
	syscall
	
end: