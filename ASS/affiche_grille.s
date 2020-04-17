#Permet d'afficher la grille#
.data
tab : .asciiz "   |"
tab2 : .asciiz "+---"
jump : .asciiz "\n"

.text
main :  
	j ligne
	
ligne: 
	colonne:        
        	bge $t5,7,saut
     		addi $t5,$t5,1
    		li   $v0 4
        	la $a0, tab
        	syscall
        	j colonne
	saut :
	    bge $t4,6, end
	    li $v0 4
	    la $a0, jump
	    addi $t4, $t4,1
	    li $t5 0
            syscall
            j while
          
       end :
       		li $v0 10
            	syscall

