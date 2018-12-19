# Who:  Sevan Mardirossian
# What: Recersive_search.asm
# Why:  insertion_sort and binarysearch
# When: Created 11/6/2018 Due 11/9/2018
# How:  .space/.asciiz

.data
array: .space 400
inputDisplay: .asciiz "Please input 20 intgers\n"
space: .asciiz" "
newLine: .asciiz"\n"
newValue: .asciiz"value: "
sizeArr: .asciiz"Please enter how man numbers you want"
msg: .asciiz "Please input the n number "
msg2: .asciiz "Please input value 2 or higher, or less then 100 "
exists: .asciiz "your value exists: "
dosent: .asciiz "your values dosen't exists: "
dot: .asciiz ". "
choice: .asciiz "Please input your choice intgers\n"
swaped: .asciiz"swaped "
.text
######################################
.globl main
main:# program entry
	la $s0,array      #array itself 
	li $s1,0          #array size
	li $s2,0		  #num of values in array
	li $s3,0		  #offset arr[0]
	li $s4,4		  #offset arr[1]
	li $s5,0		  #bit offset
	li $s6,100        #base case 
	
	li $t0,1		  #inital size 
	li $t1,0		  #offset
	li $t2,1		  
	li $t3,0		  #loop2 counterr
	li $t4,1		  #true/false
	li $t7,0
	
	
	li $v0,4
	la $a0,sizeArr
	syscall
	
	#while loop for input less then 0 or more then 100
	while2 :
		li $v0, 5
		syscall
		move $s1, $v0 # 'n' input
		slt $t8,$s1,$t0
		beq $t8,$zero,Endif # 0 input validation
			li $v0, 4
			la $a0, msg2 
			syscall
			j while2
		Endif: # 100 input validation
			slt $t8,$s6,$s1
			beq $t8,$zero,Endif2
			li $v0, 4
			la $a0, msg2 
			syscall
			j while2
		Endif2:
			
	bltz $s1,while2
	
	li $t0,0		  #inital size 
	li $t1,0		  #offset
	
	#do while loop to insret values
	while :
		li $v0, 1
		move $a0,$t0
		syscall
		
		li $v0,4
		la $a0,dot
		syscall
		
		li $v0,4
		la $a0,newValue
		syscall 
		
		li $v0, 5
		syscall
		move $t5,$v0
		sw $t5,array($t1)
		addi $s2,$s2,1
		addi $s5,$s5,4
		
		slt $t9,$t2,$t4   #if 1 < s7 go to sort
		beq $t9,$zero,else
			jal sort
		else:
	
		li $t2,0		  
		li $t3,0
		addi $t1,$t1,4
		addi $t0,$t0,1
	bne $t0,$s1,while
	
	li $t0,0		  #inital size 
	li $t1,0		  #offset
	
	loop:
		lw $t1,($s0)
		
		li $v0,1
		move $a0,$t1
		syscall
			
		li $v0, 4
		la $a0, space
		syscall
		
		addi $s0,$s0,4
		addi $t0,$t0,1
	bne $s1,$t0,loop
	
	while3:
		li $t4,1
		li $v0,4
		la $a0,choice
		syscall
		
		li $v0,5
		syscall
		move $t5,$v0  #input
		
		jal binarySearch
		
		beq $t4,$zero,false
			li $v0,4
			la $a0,exists
			syscall
		
			li $v0,1
			move $a0,$t5
			syscall
			
			li $v0,4
			la $a0,newLine
			syscall
			j while3
		false:
			li $v0,4
			la $a0,dosent
			syscall
			j while3
	beq $s6,$zero,while3
	
			
li $v0, 10
syscall

.data
.text
sort:
	li $t6,0
	li $s3,0 #j 
	li $t8,0 #key
	li $s4,4 #i = 1
	
	loop5:
		bge $s4,$s5,end2 #8
		lw $t9, array($s4) #arr[i]
		move $t8,$t9  #key = arr[i]
		sub $s3,$s4,4 #j = i -1
		while4:
			bltz $s3,finish2 # j > 0
				lw $t9,array($s3) #arr[j]
				blt $t9,$t8,finish2 #arr[j] > key
					add $t6,$s3,4 # j + 1
					sw $t9,array($t6) # arr[j+1] = arr[j]
					addi $s3,$s3,-4  # j = j -1
					j while4
		finish2:
			add $t6,$s3,4 #j +1
			sw $t8,array($t6) #arr[j+1] = key
			addi $s4,$s4,4
			j loop5
	end2:
	jr $ra
	
.data
.text
binarySearch: 	# divide into 3 array upper lower and middle

	slt $t9, $t7, $s2 #t7 < arrSize
	beq $t9, $0, falseTerminate
	
	sll $t9, $t7, 2
	lw $t8, array($t9)
	
	beq $t8, $t5, endFunction
	addi $t7, $t7, 1
	j binarySearch
	
	falseTerminate:
	li, $t7,0
	li, $t4,0
	jr $ra
endFunction:
	li, $t7,0
	jr $ra
	
	
 


