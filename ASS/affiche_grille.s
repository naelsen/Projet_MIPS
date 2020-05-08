#Permet d'afficher la grille#
.data


tab : .asciiz "|    "
tab2 : .asciiz "+----"
jump : .asciiz "|\n"

col : .word 1,2,3,4,5,6,7
space : .asciiz "  | "
bar: .asciiz "| "
J1 : .asciiz "X"

.text

main :  
	la $t3,col
	j grille
	
grille: 
	colonne:        # Affiche les 7 cases d'une meme ligne
        	bge $t5,7,interligne
        	#bge $t5,4,ligne
     		addi $t5,$t5,1
    		li   $v0 4
        	la $a0, tab
        	syscall
        	j colonne
        	
	interligne :  #saute une ligne 
	    bge $t4,13, end
	   # bge $t4,7,jeton
	    li $v0 4
	    la $a0, jump
	    addi $t4, $t4,1
	    li $t5 0
            syscall
            j ligne
            
        ligne : # affichage du grillage
        	bge $t5,7,saut2
     		addi $t5,$t5,1
    		li   $v0 4
        	la $a0, tab2
        	syscall
        	j ligne
        	
       jeton:  # Si la case correspond au jeton, on affiche X ou O
       		addi $t5,$t5,1
       		addi $t4,$t4,1
       		la $a0, J1
       		li $v0 4
       		syscall
        	j colonne
       
       saut2 :  # Saut de ligne et retour à l'affichage des colonnes
	    bge $t4,6, sauter
	    li $v0 4
	    la $a0, jump
	    li $t5 0
            syscall
            j colonne
            
       base : 
	    bge $t0,7,end	
       	    lw $t6, 0($t3)
	    addi $v0, $zero, 1
	    add $a0,$t6,$zero
	    syscall 
	    la $a0 space
	    li $v0 4
	    syscall
	    addi $t3,$t3,4
	    addi $t0,$t0,1
    	    j base
    	    
       sauter :
            li $v0 4
	    la $a0, jump
	    syscall
	    la $a0, bar
	    syscall
	    j base 
          
       end :   #Fin de l'affichage
       		li $v0 10
            	syscall

