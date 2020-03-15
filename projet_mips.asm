.data
	P1_PAWN   : .byte 'X' #Pion du joueur 1
	P2_PAWN   : .byte 'O' #Pion du joueur 2
	EMPTY     : .byte 'a'  #Case vide du puissance 4 // Mais je test avec a pour verifier l'affichage
	NB_ROWS   : .word 6     #Nombre de lignes du puissance 4
	NB_COLUMN : .word 7     #Nombre de colonnes du puissance 4
	P4        : .space 42   #42 case de 1 octet allouées au jeu,on pourra y placer les pions
	WIN_P1    : .word 0     #Si le joueur 1 gagne alors WIN_P1 passe a 1
	WIN_P2    : .word 0     #Si le joueur 2 gagne alors WIN_P2 passe a 1
	DRAW      : .word 0     #Si égalite alors DRAW passe a 1
	END       : .word 0     #Si END passea a 1 la partie se termine

.text

	main :
		
		la $a1, P4
		jal FCT_SET_P4   # Modifie $a1 en 42 case EMPTY (" ")
		jal FCT_PRINT_P4 # Affiche $a1
		li $v0, 10
		syscall
		
#<><><><><><><><><><><><><><><><><><> FCT_SET_P4 <><><><><><><><><><><><><><><><><><><><><>


	# On rempli le jeu avec EMPTY dans les 42 cases
	FCT_SET_P4 : # Entrée : $a1
		#<><><><<>DEBBUT PROLOGUE<><><><><>
		addi $sp, $sp, -8 # Ajustement $sp
		sw $ra, 0($sp)    # Sauvegarde $ra
		sw $fp, 4($sp)    # Sauvegarde $fp
		addi $fp, $sp, 8  # Ajustement $fp
		#<><><><<>-FIN PROLOGUE-<><><><><>
		
		la $t0, EMPTY          # t0 => " "
		sb $t0, 0($t0)         # t0 = " "
		add $t1, $0, $0        # Compteur boucle : t1 = 0
		addi $t2, $0, 42       # t2 = 42
		SET_P4_FOR :
			slt $t3, $t1, $t2          # Si t1 >= t2(=42)  alors t3 = 0
			beq $t3, $0, END_FCT_SET_P4 # Si t2 = 0 (t1 >= t2) alors on saute a END_FCT_SET_P4
			lb $t0, 0($a1)
			addi $a1, $a1, 1
			addi $t1, $t1, 1
			j SET_P4_FOR
		
	END_FCT_SET_P4 :
		addi $a1, $a1, -42
		#<><><><<>DEBBUT EPILOGUE<><><><><>
		lw $ra, 0($sp)   # Restitution $ra
		lw $fp, 4($sp)   # Restitution $fp
		addi $sp, $sp, 8 # On depile avant de faire le retour
		jr $ra           # Retour fonction appelante
		#<><><><<>-FIN EPILOGUE-<><><><><>
		
#<><><><><><><><><><><><><><><><><><> FCT_PRINT_P4 <><><><><><><><><><><><><><><><><><><><><>

	# On affiche le jeu
	FCT_PRINT_P4 : # Entrée $a1 (~P4)
		addi $sp, $sp, -8 # PR
		sw $ra, 0($sp)    #   OL
		sw $fp, 4($sp)    #     OG
		addi $fp, $sp, 8  #       UE
		
		or $t0, $0, $0         # Compteur boucle : t0 = 0
		addi $t1, $0, 42       # t1 = 41
		PRINT_P4_FOR :
			slt $t2, $t0, $t1      # Si t0 >= t1(=42)  alors t2 = 0
			beq $t2, $0, END_FCT_P4        # # Si t2 = 0 (t0 >= t1) alors on saute a END_FCT_P4
			sb $t3, 0($a1)
			addi $v0, $0, 11
			sb $t3, 0($a1)
			move $a0, $t3
			syscall		#affciher les elements de jeu
			addi $a1, $a1, 1
			addi $t0, $t0, 1
			j PRINT_P4_FOR
	END_FCT_P4 :
		lw $ra, 0($sp)   # EP
		lw $fp, 4($sp)   #   IL
		addi $sp, $sp, 8 #     OG
		jr $ra           #       UE
		
		
		
#<><><><><><><><><><><><><><><><><><> FCT_SET_PAWN <><><><><><><><><><><><><><><><><><><><><>

	# On rempli le jeu à la colonne donne avec le pion donné
	FCT_SET_PAWN : #Entrées $a1 (~P4), , $a1 (~Numero de la colonne), $2 (P1_PAWN ou P2_PAWN)
		addi $sp, $sp, -8 # PR
		sw $ra, 0($sp)    #   OL
		sw $fp, 4($sp)    #     OG
		addi $fp, $sp, 8  #       UE
	
	END_FCT_SET_PAWN :
		lw $ra, 0($sp)   # EP
		lw $fp, 4($sp)   #   IL
		addi $sp, $sp, 8 #     OG
		jr $ra           #       UE