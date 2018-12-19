# Who:  Sevan Mardirossian
# What: reverse_order.asm
# Why:  to print an integer in reverse line
# When: Created 9/24/2018 Due 9/26/2018
# How:  .space/.word/.asciiz 

.data

arr: .space 80 
ArrSize: .word 20
start: .asciiz "Please input 20 intgers\n"
input: .asciiz "Enter: "
newline: .asciiz "\n"
str: .asciiz "Please input how many values you want in line"
space: .asciiz " "
.text
######################################
.globl main

main:	# program entry
	
	li $t0, 0 #index
	lw $t1, ArrSize
	la $s1, arr
	li $t2, 0
	li $s2, 0
	li $t3, 1 # any size array loop incrmation 
	li $s3, 5 # n for number of ints in line 
	li $t5, 1 # counter 
	
	li $v0, 4
	la $a0, start
	syscall
	
	loop1:
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
		j loop1
	final:
	
	li $v0, 4
	la $a0, str
	syscall
	
	li $v0, 5 
	syscall
	move $s3,$v0 
	
	li $t0, 0 #index
	
	loop:
		beq $t3,$t1,done 
		addi $s1,$s1,4
		addi $t3,$t3,1
		j loop
	done:
	
	while:
		beq $t0, $t1,exit #exits loop after reaching arraySize
		li $v0, 1 #gets ready to print array
		lw $a0, ($s1) #prints array at index of 4,8,12,16 bit..
		syscall
		li $v0, 4
		la $a0, space #print \n
		syscall
		
		bne $t5,$s3, IF
			li $t5,0
			la $a0, newline
		IF: 
		syscall
		
		addi $t5,$t5,1
		addi $s1,$s1,-4 #increminates
		addi $t1,$t1,-1 #incremenates
		j while
	exit:
	
	li $v0, 10
	syscall
	
end: