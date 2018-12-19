# who: Sevan Mardirossian
# What: Encryption_Decryption.asm
# Why: password input where encrypts a txt file
# When: Create 12/1/2018 DUe 12/5/2018
# How: .space/.asciiz 

.data
des_file: .space 1024
src_file: .space 1024
input: .asciiz "please input your password: "
input_file_read: .asciiz "please input your file read name: "
input_file_write: .asciiz "please input your file write name: "
password_buffer: .space 501
temp_str: .space 1
buffer_size: .space 1024
.text
.globl main
main:
	#modeifycation 4 less registers $t6,$t8,$t9 and $t2 fixed password size to 500
	
	#$s0 for read file
	#$s1 for write to file
	#$s2 password 
	#$s3 read file characters
	
	#$t0 checking if it exits for any check method for bid loop / null/ encrypted value
	#$t1 ckecking for password character/newline checker / temp_str
	#$t2 counter for big loop v0 / small loop v0
	
	jal password_input
	
	###################################
	la $t1,password_buffer
	li $t2,10
	####################################
	
	jal remove_NewLine
	la $s2,password_buffer
	
	jal read_file
	
	la $t1,src_file
	jal remove_NewLine
	
	li $v0,13		  #open file
	la $a0, src_file  #get the fileName
	li $a1, 0		  #read the file
	syscall
	
	#checks to see if the file exists 
	slt $t0,$v0,$0
	beq $t0,$0,skip
	j Exit
	skip:
	
	move $s0,$v0
	
	jal write_file
	
	la $t1,des_file
	jal remove_NewLine
	
	xor $t1,$t1,$t1
	
	li $v0,13		  #open file
	la $a0, des_file  #get the fileName
	li $a1, 0x41		  #create file
	li $a2, 0x1FF	
	syscall
	
	move $s1,$v0
	
	jal encryption
	
Exit: 
	li $v0,10 
	syscall
##################################################
.data
.text
write_file:
	li $v0,4
	la $a0,input_file_write
	syscall
	
	li $v0,8
	la $a0,des_file
	li $a1,1024
	syscall
jr $ra

###################################################
.data
.text
read_file:
	li $v0,4
	la $a0,input_file_read
	syscall
	
	#loads the input for reading file to buffer
	li $v0,8
	la $a0,src_file
	li $a1,1024
	syscall
jr $ra

####################################################
.data
.text
password_input:
	li $v0,4
	la $a0,input
	syscall
	
	#loads the password into buffer
	la $a0, password_buffer
	li $a1, 501
	li $v0, 8
	syscall
jr $ra

###################################################
.data
.text
encryption:
	#big loop
	loop:
		#read from file and write it to string
		li $v0, 14        #read file 
		move $a0,$s0	  #file to write
		la $a1, buffer_size	  #load the buffer to read the file
		la $a2, 1024      
		syscall
		
		#loads the buffer sizes that $v0 was reading from file
		la $s3, buffer_size
		move $t2,$v0
		
		#if $t2 is 0 end loop
		beq $t2,$0,end 
		
		#small loop
		loop2:
			lb $t0,0($s3) #src
			lb $t1,0($s2) #password
			beq $t2,$zero jump_to_big_loop #if $t9 = $t2 reset $t9
			beq $t1,$zero,reset_password    #exit loop on null byte
			
			#encryption for xor
			xor $t0,$t1,$t0
			la $t1,temp_str
			sb $t0,0($t1)
			
			li $v0, 15        #write file 
			move $a0,$s1	  #file to write
			la $a1,temp_str	  #load the buffer to read the file
			la $a2,1      
			syscall
			
			addi $s2,$s2,1 #password character
			addi $s3,$s3,1 #character from src 
			addi $t2,$t2,-1 #small loop counter for $t2 = buffer 
			j loop2
			
			reset_password:
				la $s2,password_buffer
				j loop2
			jump_to_big_loop:
				j loop
	end:
	
	# Close the src_file 
	li   $v0, 16       # system call for close file
	move $a0, $s0      # file descriptor to close
	syscall            # close file	
	
	# Close the des_file 
	li   $v0, 16       # system call for close file
	move $a0, $s1      # file descriptor to close
	syscall            # close file
jr $ra

##########################################################
.data

.text
remove_NewLine:
	removeNewLineLoop:
	
		#gets bit to check for newline character
		lb $t0, 0($t1)
		beq $t0,$t2,change
			addi $t1,$t1,1
			j removeNewLineLoop     
		change: 
		
		#save null instead of newline
			sb $0, 0($t1)
			j stop
	stop:
jr $ra 	


