.data
fileIn2: .asciiz"fileCrypt.txt"
fileOut2: .asciiz"fileDecrypt.txt"
.text 
	j main
	
openFileToDecrypt:
	li $v0, 4
	la $a0, msgInKey
	syscall
	li $v0, 8 				
	la $a0, keyCrypt
	li $a1, 50
	syscall
	li $v0, 13          			
	li $a1, 0            			
	la $a0, fileIn2         		
	add $a2, $zero, $zero    	
	syscall
	move $a0, $v0       		
	li $v0, 14           			
	la $a1, sentenceCrypted        
	li $a2, 1024         			
	syscall  
	la $a0, sentenceCrypted
	la $a1, keyCrypt
	la $a2, sentenceNotCrypted	
	la $s1, fileOut2
	j toDecrypt