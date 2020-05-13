
		########################################################################
		#--- UPDATE~ Bon j'ai toujours pas réussi à corriger le problème de ---#
		#---         la case en haut à gauche, je sait que ce qu'on met     ---#	
		#---         dedans se retrouve à la case 42, et toute la colonne   ---#
		#--          se décale.                                             ---#
#  AISSAM :	#--          J'ai essayé de faire une fonction pour compter         ---#
		#--           les jetons mais c'est pas ouf                         ---#
		#----------------------------------------------------------------------#
		#--- LA SUITE~ Il reste à tester la méthode de comptage simple  ,   ---#
		#---           (en colonne), et la si elle marche alors on peut     ---#
		#---            faire dans les autres directions                    ---#
		#---                                                                ---#
		########################################################################
		
		########################################################################
# NAEL :	#--- Il faut regler le probleme de la case en haut a gauche qui ne  ---#
		#--- se rempli pas, j'ai rajouter une fonction verif_draw, donc si  ---#
		#--- t'arrivea remplir regler le probleme de la case ca devrait     ---#
		#---                  detecter l'egalite si y'en a une		    ---#
		########################################################################



		# Du coup le probleme que t'avais c'était l'adresse de $a1 qu'il fallait
.data		# réinitialiser à chaque fois
#Pour print le jeu
ligneH:		.asciiz "|\n+---+---+---+---+---+---+---+\n"
numColonne:	.asciiz "  1   2   3   4   5   6   7  \n"
saut:		.asciiz "\n"
erreur:		.asciiz "Choisissez un nombre en 1 et 7\n"
joueur1:	.asciiz "\nAu tour du joueur 1 : "
joueur2:	.asciiz "\nAu tour du joueur 2 : "
full_col:       .asciiz "\nVa jouer ailleurs"
draw:		.asciiz "\nPersonne n'a gagné (vous etes nul tout les 2)"
victoire:       .asciiz "\nVictoire du joueur 1\n"


# Dans la grille :
# 0 = Rien
# 1 = J1
# 2 = J2
grille:		.space 42 # Car 42 case  #grille : [ 0, 1 , .. , 6] Ligne 1
						  #[ :, : , .. , : ] Ligne i
						  #[35, 36, .. , 41] Ligne 6
#Jeton des joueurs
J1a:		.asciiz "| O "
J2a:		.asciiz "| X "
videa:		.asciiz	"|   "
J1b:		.asciiz "| O |\n"
J2b:		.asciiz "| X |\n"
videb:		.asciiz "|   |\n"


	.text
main:

	la $a1, grille				# a1 Grille
	addi $s0, $zero, 0			# 2 pour une croix (joueur 2)
	addi $t5,$a1,6
	addi $t4,$a1,14
	jal FCT_PRINT
	TOUR_J1:
		jal FCT_JouerJ1
		#jal FCT_PRINT
		jal FCT_VERIF_DRAW
		addi $t0, $0, 1
		beq $v0, $t0, fin
		j TOUR_J2
	
	TOUR_J2:
		jal FCT_JouerJ2
		#jal FCT_PRINT
		jal FCT_VERIF_DRAW
		addi $t0, $0, 1
		beq $v0, $t0, fin
		j TOUR_J1

	fin:
	li $v0, 10
	syscall

#<><><><><><><><><><><><><><><><><><> FCT_PRINT <><><><><><><><><><><><><><><><><><><><><>
FCT_PRINT: #Prend $a1 en entrée et ne renvoie rien
	addi $sp, $sp, -8 # PR
	sw $ra, 0($sp)    #   OL
	sw $fp, 4($sp)    #     OG
	addi $fp, $sp, 8  #       UE
	
	addi $t2, $0, 0                                  #t2 Compteur ligne
	PRINT:
		la $a0, ligneH
		li $v0, 4
		syscall
		addi $t2, $t2, 1
		beq $t2, 7, FIN_PRINT            # On verifie si on peut encore print une ligne
		addi $t0, $0, -1   # compteur de la grille         #t0 Compteur colonne
		PRINT_LIGNE:
			beq $t0, 6, FIN_PRINT_LIGNE         # On verifie si on peut encore print une case de la ligne
			addi $t0, $t0, 1
			lb $t1, 0($a1)                                #t1 Valeur de la case
			
			AFFICHE_CASE:
				beq $t1, 0, AFFICHE_VIDE
				j TEST_J1
				AFFICHE_VIDE:
				la $a0, videa                       # Affiche `"|   " si case de grille stockée dans t1 egale 0
				li $v0, 4
				syscall
				j CASE_AFFICHE
				
				TEST_J1:
				beq $t1, 1, AFFICHE_J1
				j AFFICHE_J2
				AFFICHE_J1:
				la $a0, J1a                       # Affiche `"| O " si case de grille stockée dans t1 egale 1
				li $v0, 4
				syscall
				j CASE_AFFICHE

				AFFICHE_J2:
				la $a0, J2a                     # Affiche `"| X "  si case de grille stockée dans t1 egale 2
				li $v0, 4
				syscall
				j CASE_AFFICHE
			CASE_AFFICHE:
			addi $a1, $a1, 1                             # a1 + 1      (7 fois dans cette boucle qui est elle meme dans la boucle de 6)
			j PRINT_LIGNE
		FIN_PRINT_LIGNE:
		j PRINT
	FIN_PRINT:
	la $a0, numColonne
	li $v0, 4
	syscall
	addi $a1, $a1, -42 # On remet la grille a1 au debut pour recommencer le meme procesus
	lw $ra, 0($sp)   # EP
	lw $fp, 4($sp)   #   IL
	addi $sp, $sp, 8 #     OG
	jr $ra           #       UE
	
#<><><><><><><><><><><><><><><><><><> FCT_JouerJ1 <><><><><><><><><><><><><><><><><><><><><>	

FCT_JouerJ1: #Prend $a1 en entrée et renvoie $a1 modifé
	addi $sp, $sp, -8 # PR
	sw $ra, 0($sp)    #   OL
	sw $fp, 4($sp)    #     OG
	addi $fp, $sp, 8  #       UE
	LIRE_J1:
		la $a0, joueur1
		li $v0, 4
		syscall
		li $v0, 5
		syscall
		addi $t1,$v0, -1                # scanf t1 (on fait -1 pour collé a la case de la grille qui est de 0 à 41)
		addi $t3, $0, -1
		bgt $t1, $t3, verif_J1		#
		la $a0, erreur			#
		li $v0, 4			#
		syscall				#
		j LIRE_J1			#
		verif_J1:			# On verifie si le nombre est entre 1 et 7
		addi $t2, $0, 7			#            t2 = 7
		bgt  $t2, $t1, PLACER_J1	#
		la $a0, erreur			#
		li $v0, 4			#
		syscall				#
		j LIRE_J1
#	FIN_LIRE_J1:
	PLACER_J1:
	
	addi $s0, $zero, 1	

	addi $t1,$v0, 34                       #-- On donne à $t1 la valeur entrée +34
	add $a1, $a1, $t1		       #-- pour être sur la dernière ligne
	
	TEST_CASE_VIDE1:			#-- On veut voir si la case est vide 
	lb $t6, 0($a1)				#-- on récupère la valeur de cette case (0,1 ou 2)
	beq $t6,0,JOUE1				#-- On regarde si elle est vide (inf ou egal a 0)
	
	ble,$a1,$t5,FULL_COL1

	
	j suite_jeu1
	
	j LIRE_J1
	
	FULL_COL1:
	li, $v0,4
	la $a0,full_col
	syscall
	la $a1,grille
	j LIRE_J1
	
	suite_jeu1: 
	add $t2, $0, $0#
	addi $t7, $0, 7#
	
	
	subi $a1,$a1,7				
	subi $t1,$t1,7
						#-- Si la case n'est pas vide, on retire 7 à $a1 pour se placer au dessus
	j TEST_CASE_VIDE1			#-- et on refait le test jusqu'a avoir la place
					
	
	JOUE1:					#-- Si la case est vide alors on place notre pion
	sb $s0, 0($a1)                          #-- et on revient au debut du tableau tu connais
	jal FCT_CALCUL_JETONS	
	FIN_TOUR1:
	sub $a1, $a1, $t1	
	jal FCT_PRINT
	
	
	FIN_PLACER_J1:
	lw $ra, 0($sp)   # EP
	lw $fp, 4($sp)   #   IL
	addi $sp, $sp, 8 #     OG
	jr $ra           #       UE
	
#<><><><><><><><><><><><><><><><><><> FCT_JouerJ2 <><><><><><><><><><><><><><><><><><><><><>
	
FCT_JouerJ2: #Prend $a1 en entrée et renvoie $a1 modifé
	addi $sp, $sp, -8 # PR
	sw $ra, 0($sp)    #   OL
	sw $fp, 4($sp)    #     OG
	addi $fp, $sp, 8  #       UE
	LIRE_J2:
		la $a0, joueur2
		li $v0, 4
		syscall
		li $v0, 5
		syscall
		addi $t1,$v0, -1               # scanf t1 (on fait -1 pour collé a la case de la grille qui est de 0 à 41)
		addi $t3, $0, -1
		bgt $t1, $t3, verif_J2		#
		la $a0, erreur			#
		li $v0, 4			#
		syscall				#
		j LIRE_J2			#
		verif_J2:			# On verifie si le nombre est entre 1 et 7
		addi $t2, $0, 7			#
		bgt $t2, $t1, PLACER_J2	#
		la $a0, erreur			#
		li $v0, 4			#
		syscall				#
		j LIRE_J2
	PLACER_J2:
	
	addi $s0, $zero, 2	

	addi $t1,$v0, 34                       #-- 
	add $a1, $a1, $t1
	
	
	TEST_CASE_VIDE2:			#-- On veut voir si la case est vide 
	lb $t6, 0($a1)				#-- on récupère la valeur de cette case (0,1 ou 2)
	ble $t6,0,JOUE2				#-- On regarde si elle est vide (inf ou egal a 0)
	
	ble,$a1,$t5,FULL_COL2
	
	j suite_jeu2
	
	FULL_COL2:
	li, $v0,4
	la $a0,full_col
	syscall
	la $a1,grille
	j LIRE_J2
	
	suite_jeu2: 
	add $t2, $0, $0#
	addi $t7, $0, 7#
	
	
	subi $a1,$a1,7				
	subi $t1,$t1,7
						#-- Si la case n'est pas vide, on retire 7 à $a1 pour se placer au dessus
	j TEST_CASE_VIDE2				
	
	JOUE2:	
	sb $s0, 0($a1)  
	jal FCT_CALCUL_JETONS	
				                         
	FIN_TOUR2:
	sub $a1, $a1, $t1	
	jal FCT_PRINT
	
	FIN_PLACER_J2:
	lw $ra, 0($sp)   # EP
	lw $fp, 4($sp)   #   IL
	addi $sp, $sp, 8 #     OG
	jr $ra           #       UE
	
#<><><><><><><><><><><><><><><><><><> FCT_VERIF_DRAW <><><><><><><><><><><><><><><><><><><><><>	

FCT_VERIF_DRAW: # Renvoie $v0 = 1 si egalite, 0 sinon (Prend comme entree $a1)
	addi $sp, $sp, -8 # PR
	sw $ra, 0($sp)    #   OL
	sw $fp, 4($sp)    #     OG
	addi $fp, $sp, 8  #       UE
	
	addi $t2, $0, 7 # Nombre de case = 42 pour critere d'arret
	add $t3, $0, $0 # Comteur
	BLOC_DRAW:
		lb $t1, 0($a1)
		addi $t3, $t3, 1
		beq $t3, $t2 DRAW
		ble $t1, $0, PAS_DE_DRAW
		addi $a1, $a1, 1
		
		PAS_DE_DRAW:
		addi $a1, $a1, 1
		sub $a1, $a1, $t3    #v0 = 0 si pas d'egalite
		li $v1, 0
		j FIN_BLOC_DRAW
		
		DRAW:
		la $a0, draw
		li $v0, 4
		syscall
		li $v1, 1              # v1 = 1 si egalite
		j FIN_BLOC_DRAW
	
	FIN_BLOC_DRAW:
	lw $ra, 0($sp)   # EP
	lw $fp, 4($sp)   #   IL
	addi $sp, $sp, 8 #     OG
	jr $ra           #       UE

#<><><><><><><><><><><><><><><><><><> FCT_CALCUL_NB_JETONS_DEPUIS <><><><><><><><><><><><><><><><><><><><><>	

FCT_CALCUL_JETONS: 
	addi $sp, $sp, -8 # PR
	sw $ra, 0($sp)    #   OL
	sw $fp, 4($sp)    #     OG
	addi $fp, $sp, 8  #       UE
	
	
	li $t8,0          #-- ce registre va compter le nombre de jetons dans une direction
	addi  $a3,$a1,0   #-- $a3 va être l'adresse qui va explorer la grille
	lb $s3, 0($a3)    #-- $s3 recupère la valeur du jeton qu'on vient de poser
	#bge,$a3,$t6,top
	ble $a3,$t4,bot   #-- on compte les cases qu'il y a en dessous de ce qu'on vient de poser

	top:
	subi $a3,$a3,7
	lb $s4, 0($a3)
	bge $s4,$s3,plus 
	j FIN_CALCUL
	
	bot:
	addi $a3,$a3,7   #-- la case juste en dessous
	lb $s4, 0($a3)   
	bge $s4,$s3,plus #-- Si elle a la même valeur alors on comence à compter 
	j FIN_CALCUL
	
	plus:
	addi $t8,$t8,1   #-- on compte et on recommence dans la même direction
	bge $t8,4,WIN_J
	j bot            #-- bon ça marche pas de ouf 
	

	WIN_J:
	la $a0,victoire
	li $v0,4
	syscall

	FIN_CALCUL:
	lw $ra, 0($sp)   # EP
	lw $fp, 4($sp)   #   IL
	addi $sp, $sp, 8 #     OG
	jr $ra           #       UE
	j fin

