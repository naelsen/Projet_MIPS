	.data
ligneH : .asciiz "\n+---+---+---+---+---+---+---+\n|"
ligneV : .asciiz "|   |   |   |   |   |   |   |\n"
lV:      .asciiz "   |"
numColonne : .asciiz "  1   2   3   4   5   6   7  \n"
nbColonne : .word 6
J1 : .asciiz " O |"

	.text
main :
	jal FCT_PRINT
	li $v0, 10
	syscall


#<><><><><><><><><><><><><><><><><><> FCT_PRINT <><><><><><><><><><><><><><><><><><><><><>
# On affiche le jeu
FCT_PRINT :
	addi $sp, $sp, -8 # PR
	sw $ra, 0($sp)    #   OL
	sw $fp, 4($sp)    #     OG
	addi $fp, $sp, 8  #       UE
	addi $t0, $0, 0
	addi $t5 ,$0,0
	lw $t1, nbColonne
	la $a0, numColonne
	li $v0, 4
	syscall
	
	PLACE_PION: 
		li $v0, 5
		syscall                                #-- J'ai utilisé une boucle pour afficher les cases une par une
		addi $t7,$v0,-1                        #-- J'ai essayé de créer la fonction pour choisir une case ou placer le pion
		j PRINT_FOR
	
	PRINT_FOR :
		beq $t2, 6, PRINT_END
		addi $t2, $t2,1
		
		
		PRINT_LH:
			la $a0, ligneH
			li $v0, 4
			syscall
			addi $t5, $0,0
			beq $t2,6, JOUER		
		PRINT_CASE:
			beq $t5,7,PRINT_FOR
			la $a0, lV
			li $v0, 4
			syscall
			addi $t5, $t5, 1
			j PRINT_CASE
		JOUER : 
			beq $t5,7,PRINT_FOR
			beq $t5, $t7 ,PLACER_PION
			la $a0, lV
			li $v0, 4
			syscall
			addi $t5, $t5, 1
			j JOUER
			
		PLACER_PION : 
			la $a0, J1
			li $v0, 4
			syscall
			addi $t5, $t5, 1
			j JOUER	
		
	PRINT_END:
	la $a0, ligneH
	li $v0, 4
	syscall
	la $a0, numColonne
	li $v0, 4
	syscall
END_FCT :
	lw $ra, 0($sp)   # EP
	lw $fp, 4($sp)   #   IL
	addi $sp, $sp, 8 #     OG
	jr $ra           #       UE
