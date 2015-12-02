.text
	j main
inputSentenceToCrypt:
	li $v0, 4
	la $a0, msgInKey
	syscall
	li $v0, 8 				#Entrer la cle de cryptage
	la $a0, keyCrypt
	li $a1, 50
	syscall
	li $v0, 4
	la $a0, msgInSentenceToCrypt
	syscall
	li $v0, 8				#Entrer la phrase a crypter
	la $a0, sentenceNotCrypted
	li $a1, 50
	syscall
	la $a0, sentenceNotCrypted
	la $a1, keyCrypt
	la $a2, sentenceCrypted
toCrypt:
	lb $t0, ($a0) 				#On recupere un caractere de la phrase a coder		
	la $ra, toCrypt				#Sauvegarde l'adresse de la fonction dans le registre
	beq $t0, 32, addSpace			#Si c'est un espace on le code pas
	lb $t1, ($a1) 				#On recupere un caractere de la cle
	add $a3,$t0,$t1	
	sub $a3,$a3,130				#Car A=65 en ASCII donc 65*2 pour reporter à 0
	div $a3,$a3,26
	mfhi $a3 				#Prendre le modulo 26
	add $a3,$a3,65
	sb $a3, ($a2) 				#On stocke le nouveau caractere dans un tableau
	addi $a0, $a0, 1			#Se decaler a  droite de la phrase
	addi $a1, $a1, 1			#Se decaler a  droite de la cle
	addi $a2, $a2, 1			#Se decaler a  droite de la phrase cryptee
	lb $t0, ($a0)
	lb $t1, ($a1)
	la $t5, sentenceCrypted			#Sauvegarde la phrase cryptee afin de l'envoyer éventuellement a l'affichage
	beq $t0,10, printSentence		#Si on est arrive au bout de la phrase (retour de ligne) on affiche la nouvelle phrase cryptee
	beqz $t0, printSentence			#Si du vide suit (cas d'un fichier texte)		
	bne $t1,10, toCrypt 			#Tant qu'on a pas parcouru toute la cle on reboucle (10 est le metacaractere de retour de ligne)
	la $a1, keyCrypt			#Sinon on se replace au debut
	j toCrypt  				#On reboucle apres avoir recharger la cle
