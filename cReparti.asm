	.data
ligneH : .asciiz "+---+---+---+---+---+---+---+\n"
ligneV : .asciiz "|   |   |   |   |   |   |   |\n"
numColonne : .asciiz "| 1 | 2 | 3 | 4 | 5 | 6 | 7 |\n"
nbColonne : .word 6


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
	lw $t1, nbColonne
	PRINT_FOR :
		slt $t2, $t0, $t1
		beq $t2, $0, PRINT_END
		la $a0, ligneH
		li $v0, 4
		syscall
		la $a0, ligneV
		li $v0, 4
		syscall
		addi $t0, $t0, 1
		j PRINT_FOR
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
