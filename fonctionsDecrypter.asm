.text
	j main
inputSentenceToDecrypt:
	li $v0, 4
	la $a0, msgInKey
	syscall
	li $v0, 8 				#Entrer la cle de cryptage
	la $a0, keyCrypt
	li $a1, 50
	syscall
	li $v0, 4
	la $a0, msgInSentenceToDecrypt
	syscall
	li $v0, 8				#Entrer la phrase a decrypter
	la $a0, sentenceCrypted
	li $a1, 50
	syscall
	la $a0, sentenceCrypted
	la $a1, keyCrypt
	la $a2, sentenceNotCrypted
toDecrypt:
	lb $t0, ($a0) 				#On recupere un caractere de la phrase a coder
	la $ra, toDecrypt				#Sauvegarde l'adresse de la fonction dans le registre
	beq $t0, 32, addSpace			#Si c'est un espace on le code pas
	lb $t1, ($a1) 				#Cle
	sub $a3,$t0,$t1				#Peut etre negatif
	add $a3, $a3,26 			#On ajoute 26 et on en prend le modulo (pour negatif) --> Si positif (aucun changement car on prend le modulo 26)
	div $a3,$a3,26	
	mfhi $a3
	add $a3, $a3,65
	sb $a3, ($a2) 				#On stocke le nouveau caractere dans un tableau
	addi $a0, $a0, 1			#Se decaler a  droite de la phrase
	addi $a1, $a1, 1			#Se decaler a  droite de la cle
	addi $a2, $a2, 1			#Se decaler a  droite de la phrase cryptee
	lb $t0, ($a0)
	lb $t1, ($a1)
	la $t5,sentenceNotCrypted		#Sauvegarde la phrase decryptee afin de l'envoyer a l'affichage
	beq $t0,10, printSentence		#Si on est arrive au bout de la phrase (retour de ligne) on affiche la nouvelle phrase cryptee
	beqz $t0, printSentence			#Si du vide suit (cas d'un fichier texte)
	bne $t1,10, toDecrypt 			#Tant qu'on a pas parcouru toute la cle on reboucle (10 est le metacaractere de retour de ligne)
	la $a1, keyCrypt			#Sinon on se replace au debut en rechargeant l'adresse de la cle dans $t1
	j toDecrypt  				#On reboucle apres avoir recharger la cle
