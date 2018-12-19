# Who:  Sevan Mardirossian
# What: Fibonacci.asm
# Why:  to print fibonacci and display each 'n' for each output 
# When: Created 10/24/2018 Due 10/26/2018
# How:  .space/.asciiz 

.data
array: .space 184
msg: .asciiz "Please input the n number "
msg2: .asciiz "Please input value 0 or higher, or less then 47 "
newline: .asciiz "\n"
dot: .asciiz ". "
.text
######################################
	.globl main
	main:	# program entry
		la $s0, array
		li $s1, 0 # base case 1
		li $s2, 1 # base case 2
		li $t0, 0 #counter
		li $t2, 1 # int i = 2
		li $t3, 0 # offset arr[0]
		li $t4, 4 # offset arr[1]
		li $s7, 46 # max value in array
	
		li $v0, 4
		la $a0, msg 
		syscall
		
		#while loop for input less then 0 or more then 46
		while :
			li $v0, 5
			syscall
			move $s3, $v0 # 'n' input
			slt $t8,$s3,$s1
			beq $t8,$zero,Endif # 0 input validation
				li $v0, 4
				la $a0, msg2 
				syscall
			Endif: # 46 input validation
			slt $t8,$s7,$s3
			beq $t8,$zero,Endif2
				li $v0, 4
				la $a0, msg2 
				syscall
				j while
			Endif2:
			
		bltz $s3,while
		
		beqz $s3,IF 
		beq $s3,$s2,IFElse
		j Else
		
		IF: # input 0 saves 0 to arr[0]
			sw $s1, 0($s0)
			j loop
		IFElse: # input 1 saves 0 -> arr[0] && 1 -> arr[1]
			sw $s1, 0($s0)
			sw $s2, 4($s0)
			j loop
		Else: 
			sw $s1, 0($s0) #save in the arr[0]
			sw $s2, 4($s0) #save in the arr[1]
			j loop2
		
		loop2:
			beq $s3,$t2,final # n >= t2
			lw $t5,array($t3) # arr[0] #works
			lw $t6,array($t4) # arr[1] #works
			add $t5,$t5,$t6   # x = arr[i -1] + arr[i -2] #works
			
			addi $t3,$t3,4 #arr[1]
			addi $t4,$t4,4 #arr[2]
			sw $t5,array($t4)   # save the value to arr[2]
		
			addi $t2,$t2,1 # counter
			j loop2
		final:
		
		# loop that displays
		loop:
			lw $t1,($s0)
			
			li $v0,1
			move $a0,$t0
			syscall
			
			li $v0, 4
			la $a0, dot #dot
			syscall
		
			li $v0,1
			move $a0,$t1
			syscall
		
			li $v0, 4
			la $a0, newline #\n
			syscall
		
			addi $s0,$s0,4
			addi $t0,$t0,1
			bge $s3,$t0,loop
		
	li $v0, 10
	syscall
	

	