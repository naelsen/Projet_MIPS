
#.globl FCT_PRINT
.globl main
	
.data

#Pour print le jeu
ligneH:		.asciiz "|\n+---+---+---+---+---+---+---+\n"
numColonne:	.asciiz "  1   2   3   4   5   6   7  \n"
saut:		.asciiz "\n"
joueur1:        .asciiz "Joueur 1 :"


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
	j J1
suite:						# 2 pour une croix (joueur 2)
	jal FCT_PRINT	
	li $v0, 10
	syscall
	
	J1: 
		addi $s0, $zero, 1
		li $v0, 4
		la $a0 ,joueur1
		syscall
		li $v0, 5
		syscall
		addi $t1,$v0, 34
		add $a1, $a1, $t1			# 35 l'indice de la grille tu peux tester d'autre,
		sb $s0, 0($a1)                          # On aurait pu faire aussi sb $s0, 35($a1) au lieu des 3 etapes.
		sub $a1, $a1, $t1			# Mais on peut pas faire ca dans la boucle donc je reste cohérent
		j suite
		
	J2:	
		addi $s0, $zero, 2	
		li $v0, 5
		syscall
		addi $t1,$v0, 34
		add $a1, $a1, $t1			
		sb $s0, 0($a1)                          
		sub $a2, $a2, $t1	
		j suite	
	
#suite:
#	jal FCT_PRINT
	#jal JouerJ1
	#jal FCT_PRINT
	#jal JouerJ2
	#bge $s0,1,J2
	#bge $s0,2,J1
	
FIN :
	li $v0, 10
	syscall
	




#<><><><><><><><><><><><><><><><><><> FCT_PRINT <><><><><><><><><><><><><><><><><><><><><>
FCT_PRINT:
	addi $sp, $sp, -8 # PR
	sw $ra, 0($sp)    #   OL
	sw $fp, 4($sp)    #     OG
	addi $fp, $sp, 8  #       UE
	
	addi $t2, $t2, 0                                  #t2 Compteur ligne
	PRINT:
	la $a0, ligneH
	li $v0, 4
	syscall
	addi $t2, $t2, 1
	beq $t2, 7, FIN_PRINT
	addi $t0, $0, -1   # compteur de la grille         #t0 Compteur colonne
	PRINT_LIGNE:
		beq $t0, 6, FIN_PRINT_LIGNE
		addi $t0, $t0, 1
		lb $t1, 0($a1)                             #t1 Valeur de la case
		
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
	