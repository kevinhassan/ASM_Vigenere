.data
fileIn: .asciiz"fileDecrypt.txt"
fileOut: .asciiz"fileCrypt.txt"
.text 
	j main
	
openFileToCrypt:
	li $v0, 4
	la $a0, msgInKey
	syscall
	li $v0, 8 				# Entrer la cle de cryptage
	la $a0, keyCrypt
	li $a1, 50
	syscall
	li $v0, 13          			# Syscall pour ouvrir un fichier
	li $a1, 0            			# Flag du fichier (0:read)
	la $a0, fileIn         			# Nom du fichier
	add $a2, $zero, $zero    		# Supprime le contenu dans $a2
	syscall					# Fichier ouvert
	move $a0, $v0       			# Lancer le descripteur du fichier
	li $v0, 14           			# Syscall pour lire dans un fichier
	la $a1, sentenceNotCrypted        	# Charge la phrase qui contiendra le contenu lu
	li $a2, 1024         			# Taille du contenu a lire
	syscall  
	la $a0, sentenceNotCrypted		
	la $a1, keyCrypt
	la $a2, sentenceCrypted	
	la $s1, fileOut				# Stocke le nom du nouveau fichier
	j toCrypt
