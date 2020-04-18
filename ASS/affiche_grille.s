#Permet d'afficher la grille#
.data
tab : .asciiz "|   "
tab2 : .asciiz "+---"
jump : .asciiz "|\n"

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
	    bge $t4,12, end
	    li $v0 4
	    la $a0, jump
	    addi $t4, $t4,1
	    li $t5 0
            syscall
            j re
            
        re : 
        	bge $t5,7,saut2
     		addi $t5,$t5,1
    		li   $v0 4
        	la $a0, tab2
        	syscall
        	j re
        	
       saut2 :
	    bge $t4,12, end
	    li $v0 4
	    la $a0, jump
	    addi $t4, $t4,1
	    li $t5 0
            syscall
            j colonne
          
       end :
       		li $v0 10
            	syscall

