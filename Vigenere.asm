.include"fonctionsCrypter.asm"
.include"fonctionsDecrypter.asm"
.include"FonctionsOpenFileToCrypt.asm"
.include"FonctionsOpenFileToDecrypt.asm"

.data
keyCrypt: .space 50
sentenceNotCrypted: .space 1024
sentenceCrypted : .space 1024
msgOptions: .asciiz"\n 1: Crypter une phrase\n 2: Decrypter une phrase\n 3: Crypter un fichier texte\n 4: Decrypter un fichier texte\n 5: Finir le programme"
msgInputOption: .asciiz"\n Veuillez saisir le chiffre correspondant a l'option souhaitee : "
msgError:.asciiz" \nErreur ! Votre saisie est incorrecte \n"
msgInKey: .asciiz " Entrer la cle de cryptage : "
msgInSentenceToCrypt: .asciiz " Entrer la phrase a crypter : "
msgInSentenceToDecrypt: .asciiz " Entrer la phrase a decrypter : "
msgFichierCree: .asciiz "\n Un fichier vient d'etre genere ....\n"
msgResultat: .asciiz "Le résultat est :\n"

.text
main: 
	li $v0,51
	la $a0,msgOptions			#Affiche un pop-Up avec les options
	syscall
	bnez $a1, main				#Tant que la saisie est incorrecte on recommence
	beq $a0, 1, inputSentenceToCrypt
	beq $a0, 2, inputSentenceToDecrypt
	beq $a0, 3, openFileToCrypt
	beq $a0, 4, openFileToDecrypt
	beq $a0, 5, end
	li $v0, 55
	la $a1,0
	la $a0, msgError			#Si l'option choisi n'est pas le bon affiche une erreur et on recommence
	syscall
	j main
addSpace:
	la $t4, 32
	sb $t4, ($a2) 		
	addi $a0, $a0, 1	
	addi $a2, $a2, 1	
	jr $ra
printSentence: 
	bnez $s1, writeFile			#Si le registre n'ai pas vide (registre stockant le nom du fichier)-> Eviter de printer la phrase et passer a l'ecriture
	li $v0,59
	la $a0, msgResultat
	move $a1,$t5
	syscall
	la $a0, sentenceCrypted
	la $a1, keyCrypt
	la $a2, sentenceNotCrypted
	jal clearSentenceCrypted
	j main
writeFile:	
	# Creer le fichier sortant en l'ouvrant
  	li  $v0, 13       	# Syscall pour ouvrir le fichier
  	move  $a0, $s1  	# Nom du fichier sortant
  	li  $a1, 1        	# Ouvrir pour l'ecriture (1: ecriture)
  	li  $a2, 0        	# Le mode est ignore
  	syscall            	# Ouvrir le fichier et retourne le descripteur du fichier dans $v0)
  	move $s6, $v0      	# Sauvegarder le descripteur du fichier
  	# Ecrire dans le nouveau fichier
  	li  $v0, 15       	# Syscall pour ecrire le fichier
  	move $a0, $s6      	# Descripteur du fichier
  	move  $a1, $t5   	# Adresse dans laquelle se trouve la phrase a ecrire
  	li  $a2, 1024       	# Taille maximale du contenu a ecrire
  	syscall            	# Le fichier est ecrit
  	# Fermer le fichier
  	li   $v0, 16       	# Syscall pour fermer le fichier
  	move $a0, $s6      	# Fermer la description du fichier
  	syscall            	# Fermer le fichier
	li $v0, 55
	la $a1,1
	la $a0, msgFichierCree			
	syscall
	la $a0, sentenceCrypted
	la $a1, keyCrypt
	la $a2, sentenceNotCrypted
	jal clearSentenceCrypted
	j main

clearSentenceCrypted:				#Routine pour effacer les anciennes phrases sauvegardees dans une execution anterieure
	lb $t0, ($a0)
	sb $0, ($a0)
	addi $a0,$a0, 1
	bne $t0, 10, clearSentenceCrypted 	#Si on a un retour de ligne on passe a la phrase pas cryptee
clearSentenceNotCrypted:
	lb $t0, ($a2)
	sb $0, ($a2)
	addi $a2,$a2, 1
	bne $t0, 10, clearSentenceNotCrypted 	#Si on a un retour de ligne on passe a la phrase pas cryptee
clearKey:
	lb $t0, ($a1)
	sb $0, ($a1)
	addi $a1,$a1, 1
	bne $t0, 10, clearKey 			#On peut retourner au main
	jr $ra
end:
	li $v0, 10
	syscall 
