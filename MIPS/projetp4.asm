#-- Code d'un puissance 4 en langage assembleur MIPS --#
#-- sur le simulateur Mars4_5                        --#

#<><><><><><><><><><><><><><><><><><><><><><><> DONNÉES <><><><><><><><><><><><><><><><><><><><><><>#

.data		# réinitialiser à chaque fois
#Pour print le jeu
ligneH:		.asciiz "|\n+---+---+---+---+---+---+---+\n"
numColonne:	.asciiz "  1   2   3   4   5   6   7  \n"
saut:		.asciiz "\n"
erreur:		.asciiz "Choisissez un nombre en 1 et 7\n"
joueur1:	.asciiz "\nAu tour du joueur O : "
joueur2:	.asciiz "\nAu tour du joueur X : "
full_col:       .asciiz "\nVa jouer ailleurs : "
draw:		.asciiz "\nPersonne n'a gagné"
victoire_J1:	.asciiz "\nVictoire du joueur 1\n"
victoire_J2:	.asciiz "\nVictoire du joueur 2 \n"
recommencer:	.asciiz "\nRecommencer (Y/n) : "
respecte:	.asciiz "\nEntrez une des deux options :Y ou n\n"
Y:		.ascii "Y"
n:		.ascii "n"


# Dans la grille : Il y'a 3 contenus possible par case
# 0 = CASE VIDE
# 1 = Jeton 1 (O)
# 2 = Jeton 2 (X)
grille:		.space 42 # Car la grille contient 42 cases (6 lignes 7 colonnes)
#					          : [ 0, 1 , .. , 6] Ligne 1
						  #[ :, : , .. , : ] Ligne i
						  #[35, 36, .. , 41] Ligne 6
#Jeton des joueurs
J1a:		.asciiz "| O "
J2a:		.asciiz "| X "
videa:		.asciiz	"|   "
J1b:		.asciiz "| O |\n"
J2b:		.asciiz "| X |\n"
videb:		.asciiz "|   |\n"

#<><><><><><><><><><><><><><><><><><><><><><><>< PROGRAMME <><><><><><><><><><><><><><><><><><><><><><><><><><>#
	.text
main:

	la $a2, grille				#----
	jal FCT_REFRESH_A2                      #
	addi $s0, $zero, 0 			# Initialisation des registres et de la grille,
	addi $t5,$a2,6 				# 
	jal FCT_PRINT				# Affichage dans la console
	li $s5,0				#----
	TOUR_J1:
		jal FCT_JouerJ1			#-- Joueur 1 joue
		jal FCT_BRUIT_PION		#-- Fait un bruit quand un pion est posé 
		jal FCT_VERIF_DRAW		#-- Vérification s'il n'ya pas de match nul
		#li $t0, 1
		beq $v1, 1, drawPartie
		beq $s5,1,victoire1		#-- $s5 a été modifiée à partir du pion posé le joueur 1
		j TOUR_J2			#-- ce qui signifie qu'il a gagné

	TOUR_J2:
		jal FCT_JouerJ2			#-- Joueur 2 joue
		jal FCT_BRUIT_PION		#-- Fait un bruit quand un pion est posé (Pour le style)
		jal FCT_VERIF_DRAW		#-- Retourne (v0=) 1 si égalité, 0 sinon
		li $t0, 1 			#-- Retourne (s5=) 1 si victoire sinon 0
		beq $v1, $t0, drawPartie
		beq $s5,1,victoire2		#-- On bascule alors sur l'étiquette dédiée 
		j TOUR_J1


#============== Etiquettes de fin de jeu ================#

	replay: #-- MATCH NUL
	
	la $a0, recommencer                           # Demande à l'utilisateur s'il veut recommencer la partie
	li $v0, 4                                    
	syscall
	li $v0, 12
	syscall
	addi $a0, $v0, 0
	li $t0, 110                                  # 110 pour Y (Dans la table ascii)
	li $t1, 89				    # 89 pour n
	beq $a0, $t0, fin
	beq $a0, $t1, main
	la $a0, respecte                           # Si aucun des deux caractère (Y/n) n'est entré , on recommence
	li $v0, 4
	syscall
	j replay                                   
	
	drawPartie:
	la $a0, draw                              # Aucun des deux joueurs n'a gagné, la grille est complète
	li $v0, 4                                 
	syscall
	jal FCT_BRUIT_DRAW
	j replay
	
	victoire1:                                 #-- VICTOIRE JOUEUR 1
	la $a0, victoire_J1     #
	li $v0, 4
	syscall
	jal FCT_BRUIT_VICTOIRE
	j replay
	
	victoire2:                                  #-- VICTOIRE JOUEUR 2
	la $a0, victoire_J2
	li $v0, 4
	syscall
	jal FCT_BRUIT_VICTOIRE
	j replay
	
	fin:                                        #-- fin du programme si l'utilisateur choisi de ne pas recommencer
	li $v0, 10
	syscall

#<><><><><><><><><><><><><><><><<><><><><<><><><>><><>><><> FONCTIONS <><><><><><<><>><><><><><><><><><><><><><><><><><><><><><>#



#<><><><><><><><><><><><><><><><><><> FCT_PRINT <><><><><><><><><><><><><><><><><><><><><>

FCT_PRINT: #-- Prend $a2 (registre du debut de la grille) en entrée et ne renvoie rien, 
	   #-- elle permet d'afficher le jeu dans la console, avec le contenu de chaque case
	addi $sp, $sp, -8 # PR
	sw $ra, 0($sp)    #   OL
	sw $fp, 4($sp)    #     OG
	addi $fp, $sp, 8  #       UE
	
	addi $t2, $0, 0                                 #-- $t2: registre qui permet de ompter les ligne
	PRINT:
		la $a0, ligneH                           
		li $v0, 4
		syscall                                 #-- Ce bloc affiche les séparateurs de lignes              
		addi $t2, $t2, 1
		beq $t2, 7, FIN_PRINT                   #-- limite du nombre de lignes
		subi $t0, $0, 1                         #-- $t0 compteur de la grille  initialisé à -1 à chaque ligne  
		
		PRINT_LIGNE:
			beq $t0, 6, FIN_PRINT_LIGNE         # On verifie si on peut encore ajouter une case à la ligne
			addi $t0, $t0, 1
			lb $t1, 0($a2)                      #-- $t1 recupère et stock la valeur de la case ) l'adresse de $a2
			
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
	FIN_PRINT:                                             #-- Fin de la fonction print, on affiche les numeros de colonnes
	la $a0, numColonne
	li $v0, 4
	syscall
	addi $a2, $a2, -42 # On remet la grille a2 au debut pour recommencer le meme procesus
	
	lw $ra, 0($sp)   # EP
	lw $fp, 4($sp)   #   IL
	addi $sp, $sp, 8 #     OG
	jr $ra           #       UE
	
#<><><><><><><><><><><><><><><><><><> FCT_JouerJ1 <><><><><><><><><><><><><><><><><><><><><>#	

FCT_JouerJ1:                                  #--       Prend $a2 (la grille) en entrée et renvoie $a2 modifé
	addi $sp, $sp, -8 # PR
	sw $ra, 0($sp)    #   OL
	sw $fp, 4($sp)    #     OG
	addi $fp, $sp, 8  #       UE
	LIRE_J1:
		la $a0, joueur1
		li $v0, 4
		syscall
		li $v0, 5                       #- $v0 recupère la valeur entrée par le joueur (entre 1 et 7)
		syscall                         
		addi $t1,$v0, -1                #  $t1 recupère la valeur dans la case  
		addi $t3, $0, -1                #  (on fait -1 pour coller a la case de la grille qui est de 0 à 41)
		bgt $t1, $t3, verif_J1		#  si $t1 > -1 ($v0 plus grand que 0 strictement donc) on verifie l'autre condition
		la $a0, erreur			#
		li $v0, 4			#
		syscall				#
		j LIRE_J1			#
		verif_J1:			# On verifie si le nombre est plus petit que 7
		addi $t2, $0, 7			#            t2 = 7 > t3 = colonne choisie
		bgt  $t2, $t1, PLACER_J1	# Les conditions sont respectées, on peut passer à l'étiquette de placement
		la $a0, erreur			#
		li $v0, 4			#
		syscall				#
		j LIRE_J1

	PLACER_J1:
	
	addi $s0, $zero, 1                     # $s0 prend la valeur 1 correspondant au joueur 1

	addi $t1,$v0, 34                       #-- On donne à $t1 la valeur entrée +34
	add $a2, $a2, $t1		       #-- pour être sur la dernière ligne
	
	TEST_CASE_VIDE1:		       #-- On veut voir si la case est vide 
	lb $t6, 0($a2)		               #-- on récupère la valeur de cette case (0,1 ou 2)
	beq $t6,0,JOUE1			       #-- On regarde si elle est vide (inf ou egal a 0)
	
	ble,$a2,$t5,FULL_COL1                  #-- si la colonne est pleine ($a2 plus petit que le debut de la grille +7)

	
	j suite_jeu1                           #-- si non on tente de placer le pion 
		
	j LIRE_J1
	
	FULL_COL1:                             #-- affiche un message d'erreur et demande de rejouer
	li, $v0,4
	la $a0,full_col
	syscall
	la $a2,grille
	j LIRE_J1
	
	suite_jeu1:                             #--  on reinitialise les registres
	add $t2, $0, $0#
	addi $t7, $0, 7#
	
						#-- On se place une ligne plus haut sur la même colonne
	subi $a2,$a2,7				
	subi $t1,$t1,7
						#-- Si la case n'est pas vide, on retire 7 à $a2 pour se placer au dessus
	j TEST_CASE_VIDE1			#-- et on refait le test jusqu'a avoir la place
					
	
	JOUE1:					#-- Si la case est vide alors on place notre pion
	sb $s0, 0($a2)                          
	jal FCT_CALCUL_JETONS	
	FIN_TOUR1:                              #-- et on revient au debut du tableau pour afficher la grille
	sub $a2, $a2, $t1	
	jal FCT_PRINT
	
	
	FIN_PLACER_J1:
	lw $ra, 0($sp)   # EP
	lw $fp, 4($sp)   #   IL
	addi $sp, $sp, 8 #     OG
	jr $ra           #       UE
	
#<><><><><><><><><><><><><><><><><><> FCT_JouerJ2 <><><><><><><><><><><><><><><><><><><><><>
	
FCT_JouerJ2:                                  #-- Même fonctionnement que pour la fonction FCT_JouerJ1
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

FCT_VERIF_DRAW:                                #-- Vérification si match nul, (Prend comme entree $a2)
					       #-- renvoie dans $v0 la valeur 1 si match nul, 0 sinon
	addi $sp, $sp, -8 # PR                 #-- vérifie le contenue des cette premières cases de la grille ($a2 à $a2 +7)
	sw $ra, 0($sp)    #   OL	       #-- si aucune case n'est vide ça implique que toute la grilles est complète
	sw $fp, 4($sp)    #     OG             #-- on place la valeur 1 dans $v1
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

#<><><><><><><><><><><><><><><><><><> FCT_CALCUL_NB_JETONS <><><><><><><><><><><><><><><><><><><><><>	

#-- Elle prend en paramètres $a2 (case du jeton) ,$v0 (colonne placée ), et renvoie $s5 (0 ou 1) donnant la victoire ou non

#-- Cette fonction reconnait une victoire seulement lorsque le dernier pions placé est à l'extrémité de la rangée de 4.

FCT_CALCUL_JETONS: #-- Cette fonction calcule le nombre de jetons dans toute les directions
		   #-- en partant du jetons qu'on vient de poser, elle est appelée à chaque tour


					
	addi $sp, $sp, -8 # PR
	sw $ra, 0($sp)    #   OL
	sw $fp, 4($sp)    #     OG
	addi $fp, $sp, 8  #       UE
	
	#-- Récupération des données du jeu en cours	

	li $t8,0         	 #-- ce registre va compter le nombre de jetons dans une direction
	addi $a3,$a2,0           #-- $a3 est une copie de l'adresse actuelle, elle nous permet d'explorer la grille
	lb $s3, 0($a2)           #-- $s3 recupère la valeur du jeton qu'on vient de poser
				 #-- cette valeur sera conservée pour les comparaisons
	
	#-- A chaque jeton posé, on compte toujours le nombre de jetons en dessous
	
	#-- Compte du nombre de jetons sous le dernier joué
	
	calcul_vers_bas: 
	addi $t8,$t8,1               # $t8 est incrémenté à chaque fois qu'un jeton identique est rencontré
	bge $t8,4,WIN                # s'il est superieur ou egal à 4, il y'a victoire 
	addi $a3,$a3,7               # on regarde la case en dessous du jeton posé
	lb $s4, 0($a3)               # par défaut les cases supérieures à 42 contiennent la valeur 0
	beq,$s3,$s4,calcul_vers_bas  # si jetons identique alors on incrémente    
	
	CASE : 
	beq $v0,1,COL1             #-- Instructions switch, branchement sur la colonne correspondant
	beq $v0,2,COL1	           
	beq $v0,3,COL1		   #-- Nous avons réalisé ici un cas pour chaque colonne, mais cela ne fonctionne pas
	beq $v0,4,COL4             #-- commme attendu, les lignes de codes 535 à 688 ne sont pas utilisées, mais vous pouvez
	beq $v0,5,COL7             #-- voir le raisonnement que nous avons eu 
	beq $v0,6,COL7
	beq $v0,7,COL7
		                     


COL4 :                    
	right4:            #-- Compte du nombre de jetons à droite
	addi $t8,$t8,1     #-- on incrémente directement $t8 car on compte le jeton de départ
	bge $t8,4,WIN      #-- lorsqu'on a 4 jetons alignés, le dernier joueur gagne la partie
	addi $a3,$a3,1
	lb $s4, 0($a3)
	beq,$s3,$s4,right4 #-- s'il y a moins de 4 jetons alignés sur la droite, on s'arrete au jetons le plus eloignés
	
	li $t8,0
	addi $a3,$a2,0        
	                              #-- Compte du nombre de jetons à gauche à partir de ce jetons
	left4:
	addi $t8,$t8,1
	bge $t8,4,WIN
	subi $a3,$a3,1
	lb $s4, 0($a3)
	beq,$s3,$s4,left4
	
	
	li $t8,0
	addi $a3,$a2,0
	#-- Compte du nombre de jetons sur la diagonale haute gauche
	top_left4:
	addi $t8,$t8,1
	bge $t8,4,WIN
	subi $a3,$a3,8
	lb $s4, 0($a3)
	beq,$s3,$s4,top_left4
	#--
	li $t8,0
	addi $a3,$a2,0	
	#-- Diagonale haute droite (-6)
	top_right4:
	addi $t8,$t8,1
	bge $t8,4,WIN
	subi $a3,$a3,6
	lb $s4, 0($a3)
	beq,$s3,$s4,top_right4
	#--
	li $t8,0
	addi $a3,$a2,0	
	#-- Diagonale basse gauche (+6)
	bot_left4:
	addi $t8,$t8,1
	bge $t8,4,WIN
	addi $a3,$a3,6
	lb $s4, 0($a3)
	beq,$s3,$s4,bot_left4
	#--
	li $t8,0
	addi $a3,$a2,0	
	#-- Diagonale basse droite (+8)
	bot_right4:
	addi $t8,$t8,1
	bge $t8,4,WIN
	subi $a3,$a3,8
	lb $s4, 0($a3)
	beq,$s3,$s4,bot_right4
	
	#--
	j FIN_CALCUL

	

COL1: #-- Le jetons se trouve dans la première colonne, on regarde uniquement à droite	
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
	
	j FIN_CALCUL	
			
COL7:	#-- Le jetons se trouve dans la dernière colonne, on vérifie seulement les cases à gauche	
	
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
####################################################################################################################

COL2:
	li $t9, 2
	j comptage_partie_gauche
#---------				
COL3:
	li $t9, 3
	j comptage_partie_gauche
#---------
COL5:
	li $t9, 3
	j comptage_partie_droite
#---------
COL6:										
	li $t9, 2
	j comptage_partie_droite
comptage_partie_gauche :
 
	left2:
	addi $t8,$t8,1
	beq $t8,$t9,retour_l
	subi $a3,$a3,1
	lb $s4, 0($a3)
	beq,$s3,$s4,left2
	
	li $t8,0
	addi $a3,$a2,0
	j top_left2
	retour_l :
	li $t8,0 
	right2:
	addi $t8,$t8,1     #-- on incrémente directement $t8 car on compte le jeton de départ
	bge $t8,4,WIN      #-- lorsqu'on a 4 jetons alignés, le dernier joueur gagne la partie
	addi $a3,$a3,1
	lb $s4, 0($a3)
	beq,$s3,$s4,right2
	
	
	#-- Compte du nombre de jetons à gauche
	
	#-- Compte du nombre de jetons sur la diagonale haute gauche
	top_left2:
	addi $t8,$t8,1
	beq $t8,$t9,retour_tl
	subi $a3,$a3,8
	lb $s4, 0($a3)
	beq,$s3,$s4,top_left2
	
	addi $a3,$a2,0
	li $t8,0
	j bot_left2
	#--
	retour_tl:
	li $t8,0   #-- On regarde ligne-haut-bas vers le mur puis on reviens dans l'ordre
	bot_right2:
	addi $t8,$t8,1
	addi $a3,$a3,8
	lb $s4, 0($a3)
	beq,$s3,$s4,bot_right2
	#--
	li $t8,0
	addi $a3,$a2,0	
	#-- Diagonale basse droite (+8)
	bot_left2:
	addi $t8,$t8,1
	beq $t8,$t9,retour_bl
	addi $a3,$a3,6
	lb $s4, 0($a3)
	beq,$s3,$s4,top_left2
	#--
	retour_bl:
	li $t8,0   #-- On regarde ligne-haut-bas vers le mur puis on reviens dans l'ordre
	top_right2:
	addi $t8,$t8,1
	subi $a3,$a3,6
	lb $s4, 0($a3)
	beq,$s3,$s4,top_right2

	j FIN_CALCUL

comptage_partie_droite :
 
	right_2:
	addi $t8,$t8,1          #-- On commence par regarder à droite jusqu'a la limite de grille
	beq $t8,$t9,retour_r    #-- $t9 correspond à cette limite, ensuite on revient dans la direction opposée
	addi $a3,$a3,1
	lb $s4, 0($a3)          
	beq,$s3,$s4,right_2
	j retour_r             #-- une fois le premier jetons non identique (ou cas vide) renconctré, on compte
	                       #-- dans la direction opposée
	li $t8,0
	addi $a3,$a2,0
	j top_right_2
	
	retour_r :         #
	li $t8,0 
	left_2:
	addi $t8,$t8,1     #-- on incrémente directement $t8 car on compte le jeton de départ
	bge $t8,4,WIN      #-- lorsqu'on a 4 jetons alignés, le dernier joueur gagne la partie
	subi $a3,$a3,1
	lb $s4, 0($a3)
	beq,$s3,$s4,left_2
	
	
	#-- Compte du nombre de jetons à gauche
	
	
	li $t8,0
	addi $a3,$a2,0
	#-- Compte du nombre de jetons sur la diagonale haute gauche
	top_right_2:
	addi $t8,$t8,1
	beq $t8,$t9,retour_tr
	subi $a3,$a3,6
	lb $s4, 0($a3)
	beq,$s3,$s4,top_right_2
	#--
	li $t8,0
	addi $a3,$a2,0	
	j bot_right_2
	retour_tr:
	li $t8,0
	#-- Diagonale basse gauche (+6)
	bot_left_2:
	addi $t8,$t8,1
	bge $t8,4,WIN
	addi $a3,$a3,6
	lb $s4, 0($a3)
	beq,$s3,$s4,bot_left_2
	#--
	li $t8,0
	addi $a3,$a2,0	
	#-- Diagonale basse droite (+8)
	
	
	bot_right_2:
	addi $t8,$t8,1
	beq $t8,$t3,retour_br
	subi $a3,$a3,8
	lb $s4, 0($a3)
	beq,$s3,$s4,bot_right_2
	#--
	li $t8,0
	addi $a3,$a2,0	
	retour_br:
	top_left_2:
	li $t8,0
	addi $t8,$t8,1
	bge $t8,4,WIN
	subi $a3,$a3,8
	lb $s4, 0($a3)
	beq,$s3,$s4,top_left_2
	
###########################################################################################################################
																																																																																		
	j FIN_CALCUL
	

	WIN:
	li $s5,1        #-- On place dans ce registre la valeur 1, pour indiquer        
			#-- que le dernier à avoir joué à gagner, retour au main 
	FIN_CALCUL:
	lw $ra, 0($sp)   # EP
	lw $fp, 4($sp)   #   IL
	addi $sp, $sp, 8 #     OG
	jr $ra           #       UE
	

	
	
	
#<><><><><><><><><><><><><><><><><><> FCT_REFRESH_A2 <><><><><><><><><><><><><><><><><><><><><>	

FCT_REFRESH_A2: # Entrée : a2, Sortie a2 , affecte à toutes les cases la valeur 0
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



#-- Les fonctions suivantes ermettant de jouer des sons lors des différentes actions est issues placer un pion , match nul ou victoire

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
