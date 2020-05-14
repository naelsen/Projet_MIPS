		########################################################################
		#--- UPDATE~ Les fonction de comptage du nombre de jetons sont finis---#
#  AISSAM :	#--          le jeu s'arrete quand il y'a un gagnant normalement    ---#
		#--           j'ai testé, il manque les cas ou on pose le pions ente---#
		#--        2 pions identique (il faut compter dans les 2 directions ---#
		#----------------------------------------------------------------------#
		#--- LA SUITE~ Maintenant il faut bien commenter le code en détail  ---#
		#---           et aussi voir si les registres utilisés sont adaptés ---#
		#---           parce que je les ai choisis nimporte comment moi     ---#
		#---           vois dans ma fonction qui retourne $s5 par exemple   ---#
		########################################################################

		########################################################################
# NAEL :	#--- Le probleme de decalage des pion il se trouvais dans la fct    ---#
		#---                    verif draw.        			    ---#
		#---  La fonction REFRESH_A2 elle bug jsp pk mais si elle marche    ---#
		#---        on peut recommencer les parties correctement,	    ---#
		#--- 		donc on aura juste besoin des verifs                ---#
		#---                     et c'est fini				    ---#
		#---    (Et j'ai remplacé tout les $a1 par des $a2, 	 	    ---#
		#---         pose pas de question y'aura pas de reponses)	    ---#
		########################################################################


		# Du coup le probleme que t'avais c'était l'adresse de $a2 qu'il fallait
.data		# réinitialiser à chaque fois
#Pour print le jeu
ligneH:		.asciiz "|\n+---+---+---+---+---+---+---+\n"
numColonne:	.asciiz "  1   2   3   4   5   6   7  \n"
saut:		.asciiz "\n"
erreur:		.asciiz "Choisissez un nombre en 1 et 7\n"
joueur1:	.asciiz "\nAu tour du joueur O : "
joueur2:	.asciiz "\nAu tour du joueur X : "
full_col:       .asciiz "\nVa jouer ailleurs : "
draw:		.asciiz "\nPersonne n'a gagné (honte a vous)"
victoire_J1:	.asciiz "\nVictoire du joueur 1: félicitation joueur 1 (joueur 2 t'es claqué)\n"
victoire_J2:	.asciiz "\nVictoire du joueur 2 : t'as dead ça chakal\n"
recommencer:	.asciiz "\nRecommencer (Y/n) : "
respecte:	.asciiz "\nOn ta dis Y ou n, allez recommence\n"
Y:		.ascii "Y"
n:		.ascii "n"


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

	la $a2, grille				# a2 Grille
	jal FCT_REFRESH_A2
	addi $s0, $zero, 0
	addi $t5,$a2,6
	jal FCT_PRINT
	TOUR_J1:
		jal FCT_JouerJ1			#-- Joueur 1 joue
		jal FCT_BRUIT_PION		#-- Fait un bruit quand un pion est posé (Pour le style)
		jal FCT_VERIF_DRAW		#-- Retourne (v0=) 1 si égalité, 0 sinon
		li $t0, 1
		beq $v1, $t0, drawPartie
		beq $s5,1,victoire1		#-- $s5 a été modifiée à partir du pion posé le joueur 1
		j TOUR_J2			#-- ce qui signifie qu'il a gagné

	TOUR_J2:
		jal FCT_JouerJ2			#-- Joueur 2 joue
		jal FCT_BRUIT_PION		#-- Fait un bruit quand un pion est posé (Pour le style)
		jal FCT_VERIF_DRAW		#-- Retourne (v0=) 1 si égalité, 0 sinon
		li $t0, 1
		beq $v1, $t0, drawPartie
		beq $s5,1,victoire2		#-- On bascule alors sur l'étiquette dédiée 
		j TOUR_J1


#============== Etiquettes de fin de jeu ================#

	replay: #-- MATCH NUL
	
	la $a0, recommencer
	li $v0, 4
	syscall
	li $v0, 12
	syscall
	addi $a0, $v0, 0
	li $t0, 110                                  # 110 pour Y (Dans la table ascii)
	li $t1, 89				    # 89 pour n
	beq $a0, $t0, fin
	beq $a0, $t1, main
	la $a0, respecte
	li $v0, 4
	syscall
	j replay
	
	drawPartie:
	la $a0, draw     #
	li $v0, 4
	syscall
	jal FCT_BRUIT_DRAW
	j replay
	
	victoire1: #-- VICTOIRE JOUEUR 1
	la $a0, victoire_J1     #
	li $v0, 4
	syscall
	jal FCT_BRUIT_VICTOIRE
	j replay
	
	victoire2: #-- VICTOIRE JOUEUR 2
	la $a0, victoire_J2
	li $v0, 4
	syscall
	jal FCT_BRUIT_VICTOIRE
	j replay
	
	fin:
	li $v0, 10
	syscall

#<><><><><><><><><><><><><><><><><><> FCT_PRINT <><><><><><><><><><><><><><><><><><><><><>
FCT_PRINT: #Prend $a2 en entrée et ne renvoie rien
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
			lb $t1, 0($a2)                                #t1 Valeur de la case
			
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
			addi $a2, $a2, 1                             # a2 + 1      (7 fois dans cette boucle qui est elle meme dans la boucle de 6)
			j PRINT_LIGNE
		FIN_PRINT_LIGNE:
		j PRINT
	FIN_PRINT:
	la $a0, numColonne
	li $v0, 4
	syscall
	addi $a2, $a2, -42 # On remet la grille a2 au debut pour recommencer le meme procesus
	lw $ra, 0($sp)   # EP
	lw $fp, 4($sp)   #   IL
	addi $sp, $sp, 8 #     OG
	jr $ra           #       UE
	
#<><><><><><><><><><><><><><><><><><> FCT_JouerJ1 <><><><><><><><><><><><><><><><><><><><><>	

FCT_JouerJ1: #Prend $a2 en entrée et renvoie $a2 modifé
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
	add $a2, $a2, $t1		       #-- pour être sur la dernière ligne
	
	TEST_CASE_VIDE1:			#-- On veut voir si la case est vide 
	lb $t6, 0($a2)				#-- on récupère la valeur de cette case (0,1 ou 2)
	beq $t6,0,JOUE1				#-- On regarde si elle est vide (inf ou egal a 0)
	
	ble,$a2,$t5,FULL_COL1

	
	j suite_jeu1
	
	j LIRE_J1
	
	FULL_COL1:
	li, $v0,4
	la $a0,full_col
	syscall
	la $a2,grille
	j LIRE_J1
	
	suite_jeu1: 
	add $t2, $0, $0#
	addi $t7, $0, 7#
	
	
	subi $a2,$a2,7				
	subi $t1,$t1,7
						#-- Si la case n'est pas vide, on retire 7 à $a2 pour se placer au dessus
	j TEST_CASE_VIDE1			#-- et on refait le test jusqu'a avoir la place
					
	
	JOUE1:					#-- Si la case est vide alors on place notre pion
	sb $s0, 0($a2)                          #-- et on revient au debut du tableau tu connais
	jal FCT_CALCUL_JETONS	
	FIN_TOUR1:
	sub $a2, $a2, $t1	
	jal FCT_PRINT
	
	
	FIN_PLACER_J1:
	lw $ra, 0($sp)   # EP
	lw $fp, 4($sp)   #   IL
	addi $sp, $sp, 8 #     OG
	jr $ra           #       UE
	
#<><><><><><><><><><><><><><><><><><> FCT_JouerJ2 <><><><><><><><><><><><><><><><><><><><><>
	
FCT_JouerJ2: #Prend $a2 en entrée et renvoie $a2 modifé
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
	add $a2, $a2, $t1
	
	
	TEST_CASE_VIDE2:			#-- On veut voir si la case est vide 
	lb $t6, 0($a2)				#-- on récupère la valeur de cette case (0,1 ou 2)
	ble $t6,0,JOUE2				#-- On regarde si elle est vide (inf ou egal a 0)
	
	ble,$a2,$t5,FULL_COL2
	
	j suite_jeu2
	
	FULL_COL2:
	li, $v0,4
	la $a0,full_col
	syscall
	la $a2,grille
	j LIRE_J2
	
	suite_jeu2: 
	add $t2, $0, $0#
	addi $t7, $0, 7#
	
	
	subi $a2,$a2,7				
	subi $t1,$t1,7
						#-- Si la case n'est pas vide, on retire 7 à $a2 pour se placer au dessus
	j TEST_CASE_VIDE2				
	
	JOUE2:	
	sb $s0, 0($a2)  
	jal FCT_CALCUL_JETONS	
				                         
	FIN_TOUR2:
	sub $a2, $a2, $t1	
	jal FCT_PRINT
	
	FIN_PLACER_J2:
	lw $ra, 0($sp)   # EP
	lw $fp, 4($sp)   #   IL
	addi $sp, $sp, 8 #     OG
	jr $ra           #       UE
	
#<><><><><><><><><><><><><><><><><><> FCT_VERIF_DRAW <><><><><><><><><><><><><><><><><><><><><>	

FCT_VERIF_DRAW: # Renvoie $v0 = 1 si egalite, 0 sinon (Prend comme entree $a2)
	addi $sp, $sp, -8 # PR
	sw $ra, 0($sp)    #   OL
	sw $fp, 4($sp)    #     OG
	addi $fp, $sp, 8  #       UE
	
	addi $t2, $0, 8 # Nombre de case = 42 pour critere d'arret
	add $t3, $0, $0 # Comteur
	BLOC_DRAW:
		lb $t1, 0($a2)
		addi $t3, $t3, 1
		beq $t3, $t2 DRAW
		beq $t1, $0, PAS_DE_DRAW
		addi $a2, $a2, 1
		j BLOC_DRAW
		PAS_DE_DRAW:
		addi $a2, $a2, 1
		sub $a2, $a2, $t3    #v0 = 0 si pas d'egalite
		li $v1, 0
		j FIN_BLOC_DRAW
		
		DRAW:
		sub $a2, $a2, $t3##
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

FCT_CALCUL_JETONS: #-- Cette fonction calcule le nombre de jetons dans toute les directions
		   #-- en partant du jetons qu'on vient de poser, elle est appelée à chaque tour

	addi $sp, $sp, -8 # PR
	sw $ra, 0($sp)    #   OL
	sw $fp, 4($sp)    #     OG
	addi $fp, $sp, 8  #       UE
	
	#-- Récupération des données du jeu en cours	

	li $t8,0         	 #-- ce registre va compter le nombre de jetons dans une direction
	addi $a3,$a2,0           #-- $a3 est une copie de l'adresse actuelle, elle nous permet d'explorer 
	lb $s3, 0($a3)           #-- $s3 recupère la valeur du jeton qu'on vient de poser
				 #-- cette valeur sera conservée pour les comparaisons
	
	#-- A chaque jeton posé, on compte toujours le nombre de jetons en dessous
	
	#-- Compte du nombre de jetons sous le dernier joué
	bot: 
	addi $t8,$t8,1
	bge $t8,4,WIN
	addi $a3,$a3,7
	lb $s4, 0($a3)
	beq,$s3,$s4,bot		    
	
	blt $v0,4,DROITE             #-- Le jeton se trouve dans la moitié gauche de la grille 
	bgt $v0,4,GAUCHE	     #-- Le jeton se trouve du coté droit (voir commentaire sur etiquette)
	
				     #-- Aucun des deux branchement est réalisé, ça veut dire qu'on s'est placé 
		                     #-- sur la colonne du milieu, on doit donc faire tous les tests
		                     
	#-- Ces deux lignes essentielles reinitialisent 
	#-- le compte dès qu'on croise un jeton différent.	                     
	li $t8,0  
	addi $a3,$a2,0

####===!!!Les instruction suivantes sont réalisées uniquement lorsqu'on se trouve sur la colonne du milieu (4)!!!===####

	#-- Compte du nombre de jetons à droite
	right:
	addi $t8,$t8,1     #-- on incrémente directement $t8 car on compte le jeton de départ
	bge $t8,4,WIN      #-- lorsqu'on a 4 jetons alignés, le dernier joueur gagne la partie
	addi $a3,$a3,1
	lb $s4, 0($a3)
	beq,$s3,$s4,right
	
	
	li $t8,0
	addi $a3,$a2,0
	#-- Compte du nombre de jetons à gauche
	left:
	addi $t8,$t8,1
	bge $t8,4,WIN
	subi $a3,$a3,1
	lb $s4, 0($a3)
	beq,$s3,$s4,left
	
	
	li $t8,0
	addi $a3,$a2,0
	#-- Compte du nombre de jetons sur la diagonale haute gauche
	top_left:
	addi $t8,$t8,1
	bge $t8,4,WIN
	subi $a3,$a3,8
	lb $s4, 0($a3)
	beq,$s3,$s4,top_left
	#--
	li $t8,0
	addi $a3,$a2,0	
	#-- Diagonale haute droite (-6)
	top_right:
	addi $t8,$t8,1
	bge $t8,4,WIN
	subi $a3,$a3,6
	lb $s4, 0($a3)
	beq,$s3,$s4,top_right
	#--
	li $t8,0
	addi $a3,$a2,0	
	#-- Diagonale basse gauche (+6)
	bot_left:
	addi $t8,$t8,1
	bge $t8,4,WIN
	addi $a3,$a3,6
	lb $s4, 0($a3)
	beq,$s3,$s4,bot_left
	#--
	li $t8,0
	addi $a3,$a2,0	
	#-- Diagonale basse droite (+8)
	bot_right:
	addi $t8,$t8,1
	bge $t8,4,WIN
	subi $a3,$a3,8
	lb $s4, 0($a3)
	beq,$s3,$s4,bot_right
	#--




DROITE: #-- Le jetons se trouve dans les 3 premières colonnes, on regarde uniquement  à droite	
	li $t8,0
	addi $a3,$a2,0
	right1:
	addi $t8,$t8,1
	bge $t8,4,WIN
	addi $a3,$a3,1
	lb $s4, 0($a3)
	beq,$s3,$s4,right1
	#--
	li $t8,0
	addi $a3,$a2,0
	top_right1:
	addi $t8,$t8,1
	bge $t8,4,WIN
	subi $a3,$a3,6
	lb $s4, 0($a3)
	beq,$s3,$s4,top_right1
	#--
	li $t8,0
	addi $a3,$a2,0
	bot_right1:
	addi $t8,$t8,1
	bge $t8,4,WIN
	subi $a3,$a3,8
	lb $s4, 0($a3)
	beq,$s3,$s4,bot_right1
		
			
GAUCHE:	#-- Le jetons se trouve dans les 3 dernières colonnes, on vérifie seulement les cases à gauche	

	li $t8,0
	addi $a3,$a2,0
	left1:
	addi $t8,$t8,1
	bge $t8,4,WIN
	subi $a3,$a3,1
	lb $s4, 0($a3)
	beq,$s3,$s4,left1
	#--	
	li $t8,0
	addi $a3,$a2,0	
	top_left1:
	addi $t8,$t8,1
	bge $t8,4,WIN
	subi $a3,$a3,8
	lb $s4, 0($a3)
	beq,$s3,$s4,top_left1
	#--  
	li $t8,0
	addi $a3,$a2,0
	bot_left1:
	addi $t8,$t8,1
	bge $t8,4,WIN
	addi $a3,$a3,6
	lb $s4, 0($a3)
	beq,$s3,$s4,bot_left1	
											
	j FIN_CALCUL
	

	WIN:
	li $s5,1        #-- On place dans ce registre la valeur 1, pour indiquer        
			#-- qu'un des deux joueurs à gagner, retour au main 
	FIN_CALCUL:
	lw $ra, 0($sp)   # EP
	lw $fp, 4($sp)   #   IL
	addi $sp, $sp, 8 #     OG
	jr $ra           #       UE
	#j replay
	
#<><><><><><><><><><><><><><><><><><> FCT_REFRESH_A2 <><><><><><><><><><><><><><><><><><><><><>	

FCT_REFRESH_A2: # Entrée : a2, Sortie a2
	li $t0, 0
	li $t1, -1
	li, $t2, 41
	REFRESHH:
	beq $t1, $t2, FIN_REFRESH
	addi $t1, $t1, 1
	sb $t0, 0($a2)
	addi $a2, $a2, 1
	j REFRESHH
	FIN_REFRESH:
	sub $a2, $a2, $t2
	addi $a2, $a2, -1
	jr $ra


#<><><><><><><><><><><><><><><><><><> FCT_BRUIT_PION <><><><><><><><><><><><><><><><><><><><><>	

FCT_BRUIT_PION:
	addi $sp, $sp, -8 # PR
	sw $ra, 0($sp)    #   OL
	sw $fp, 4($sp)    #     OG
	addi $fp, $sp, 8  #       UE
	BRUIT_PION:
		addi $t2, $a2, 0
		addi $t3, $a3, 0
		li $v0, 31 
		li $a0, 102
		li $a1, 250
		li $a2, 9
		li $a3, 100
		syscall
		addi $a2, $t2, 0
		addi $a3, $t3, 0
	FIN_BRUIT_PION:
	lw $ra, 0($sp)   # EP
	lw $fp, 4($sp)   #   IL
	addi $sp, $sp, 8 #     OG
	jr $ra           #       UE
	
	
#<><><><><><><><><><><><><><><><><><> FCT_BRUIT_VICTOIRE <><><><><><><><><><><><><><><><><><><><><>	

FCT_BRUIT_VICTOIRE:
	addi $sp, $sp, -8 # PR
	sw $ra, 0($sp)    #   OL
	sw $fp, 4($sp)    #     OG
	addi $fp, $sp, 8  #       UE
	BRUIT_VICTOIRE:
		addi $t2, $a2, 0
		addi $t3, $a3, 0
		add $t0,$0,$0		#-- Compteur
		addi $t1,$0,3		#-- Nombre de ding

		li $a2, 56		# Instru
		li $a3, 127
		DING_DING:
			addi $t0, $t0, 1
			beq $t0,$t1,FIN_DING
			#BRUIT
			li $a0, 76	#PITCH
			li $a1, 150
			li $v0, 31
			syscall
	
			#PAUSE
			li $a0, 180
			li $v0, 32
			syscall
			#BRUIT
			li $a0, 67	#PITCH
			li $a1, 150
			li $v0, 31
			syscall
	
			#PAUSE
			li $a0, 180
			li $v0, 32
			syscall
			j DING_DING
		FIN_DING:
		#BRUIT FINAL
		li $a0, 71
		li $a1, 1000
		li $v0, 31
		syscall
		# On restaure les grilles
		addi $a2, $t2, 0
		addi $a3, $t3, 0
	FIN_BRUIT_VICTOIRE:
	lw $ra, 0($sp)   # EP
	lw $fp, 4($sp)   #   IL
	addi $sp, $sp, 8 #     OG
	jr $ra           #       UE
	
	
	
FCT_BRUIT_DRAW:
	addi $sp, $sp, -8 # PR
	sw $ra, 0($sp)    #   OL
	sw $fp, 4($sp)    #     OG
	addi $fp, $sp, 8  #       UE
	BRUIT_DRAW:
		addi $t2, $a2, 0
		addi $t3, $a3, 0
		add $t0,$0,$0		#-- Compteur
		addi $t1,$0,3		#-- Nombre de ding

		li $a2, 56		# Instru
		li $a3, 127
		DING_DONG:
			addi $t0, $t0, 1
			beq $t0,$t1,FIN_DONG
			#BRUIT
			li $a0, 59	#PITCH
			li $a1, 300
			li $v0, 31
			syscall
	
			#PAUSE
			li $a0, 350
			li $v0, 32
			syscall
			#BRUIT
			li $a0, 63	#PITCH
			li $a1, 300
			li $v0, 31
			syscall
	
			#PAUSE
			li $a0, 400
			li $v0, 32
			syscall
			j DING_DONG
		FIN_DONG:
		#BRUIT FINAL
		li $a0, 70
		li $a1, 1000
		li $v0, 31
		syscall
		# On restaure les grilles
		addi $a2, $t2, 0
		addi $a3, $t3, 0
	FIN_BRUIT_DRAW:
	lw $ra, 0($sp)   # EP
	lw $fp, 4($sp)   #   IL
	addi $sp, $sp, 8 #     OG
	jr $ra           #       UE