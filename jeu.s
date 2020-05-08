	.file	"jeu.c"
	.text
	.local	grille
	.comm	grille,42,32
	.section	.rodata
.LC0:
	.string	"clear"
.LC1:
	.string	"  %d "
.LC2:
	.string	"---+"
.LC3:
	.string	" %c "
.LC4:
	.string	" %c |"
	.text
	.type	affiche_grille, @function
affiche_grille:
.LFB5:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	leaq	.LC0(%rip), %rdi
	call	system@PLT
	movl	$10, %edi
	call	putchar@PLT
	movl	$1, -8(%rbp)
	jmp	.L2
.L3:
	movl	-8(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC1(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	addl	$1, -8(%rbp)
.L2:
	cmpl	$7, -8(%rbp)
	jle	.L3
	movl	$10, %edi
	call	putchar@PLT
	movl	$43, %edi
	call	putchar@PLT
	movl	$1, -8(%rbp)
	jmp	.L4
.L5:
	leaq	.LC2(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	addl	$1, -8(%rbp)
.L4:
	cmpl	$7, -8(%rbp)
	jle	.L5
	movl	$10, %edi
	call	putchar@PLT
	movl	$0, -4(%rbp)
	jmp	.L6
.L13:
	movl	$124, %edi
	call	putchar@PLT
	movl	$0, -8(%rbp)
	jmp	.L7
.L10:
	call	__ctype_b_loc@PLT
	movq	(%rax), %rcx
	movl	-4(%rbp), %eax
	movslq	%eax, %rsi
	movl	-8(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	addq	%rax, %rax
	leaq	(%rax,%rsi), %rdx
	leaq	grille(%rip), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movsbq	%al, %rax
	addq	%rax, %rax
	addq	%rcx, %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %eax
	andl	$1024, %eax
	testl	%eax, %eax
	je	.L8
	movl	-4(%rbp), %eax
	movslq	%eax, %rcx
	movl	-8(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	addq	%rax, %rax
	leaq	(%rax,%rcx), %rdx
	leaq	grille(%rip), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	movl	%eax, %esi
	leaq	.LC3(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$124, %edi
	call	putchar@PLT
	jmp	.L9
.L8:
	movl	$32, %esi
	leaq	.LC4(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
.L9:
	addl	$1, -8(%rbp)
.L7:
	cmpl	$6, -8(%rbp)
	jle	.L10
	movl	$10, %edi
	call	putchar@PLT
	movl	$43, %edi
	call	putchar@PLT
	movl	$1, -8(%rbp)
	jmp	.L11
.L12:
	leaq	.LC2(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	addl	$1, -8(%rbp)
.L11:
	cmpl	$7, -8(%rbp)
	jle	.L12
	movl	$10, %edi
	call	putchar@PLT
	addl	$1, -4(%rbp)
.L6:
	cmpl	$5, -4(%rbp)
	jle	.L13
	movl	$1, -8(%rbp)
	jmp	.L14
.L15:
	movl	-8(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC1(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	addl	$1, -8(%rbp)
.L14:
	cmpl	$7, -8(%rbp)
	jle	.L15
	movl	$10, %edi
	call	putchar@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	affiche_grille, .-affiche_grille
	.type	calcule_position, @function
calcule_position:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -20(%rbp)
	movq	%rsi, -32(%rbp)
	movq	-32(%rbp), %rax
	movl	-20(%rbp), %edx
	movl	%edx, (%rax)
	movl	$5, -4(%rbp)
	jmp	.L17
.L20:
	movq	-32(%rbp), %rax
	movl	(%rax), %eax
	movl	-4(%rbp), %edx
	movslq	%edx, %rcx
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	addq	%rax, %rax
	leaq	(%rax,%rcx), %rdx
	leaq	grille(%rip), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$32, %al
	jne	.L18
	movq	-32(%rbp), %rax
	movl	-4(%rbp), %edx
	movl	%edx, 4(%rax)
	jmp	.L19
.L18:
	subl	$1, -4(%rbp)
.L17:
	cmpl	$0, -4(%rbp)
	jns	.L20
.L19:
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	calcule_position, .-calcule_position
	.type	calcule_nb_jetons_depuis_vers, @function
calcule_nb_jetons_depuis_vers:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -40(%rbp)
	movl	%esi, -44(%rbp)
	movl	%edx, -48(%rbp)
	movl	%ecx, %eax
	movb	%al, -52(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$1, -20(%rbp)
	movq	-40(%rbp), %rax
	movl	(%rax), %edx
	movl	-44(%rbp), %eax
	addl	%edx, %eax
	movl	%eax, -16(%rbp)
	movq	-40(%rbp), %rax
	movl	4(%rax), %edx
	movl	-48(%rbp), %eax
	addl	%edx, %eax
	movl	%eax, -12(%rbp)
	jmp	.L22
.L26:
	movl	-16(%rbp), %eax
	movl	-12(%rbp), %edx
	movslq	%edx, %rcx
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	addq	%rax, %rax
	leaq	(%rax,%rcx), %rdx
	leaq	grille(%rip), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	%al, -52(%rbp)
	jne	.L29
	addl	$1, -20(%rbp)
	movl	-16(%rbp), %edx
	movl	-44(%rbp), %eax
	addl	%edx, %eax
	movl	%eax, -16(%rbp)
	movl	-12(%rbp), %edx
	movl	-48(%rbp), %eax
	addl	%edx, %eax
	movl	%eax, -12(%rbp)
.L22:
	leaq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	position_valide
	testl	%eax, %eax
	jne	.L26
	jmp	.L25
.L29:
	nop
.L25:
	movl	-20(%rbp), %eax
	movq	-8(%rbp), %rsi
	xorq	%fs:40, %rsi
	je	.L28
	call	__stack_chk_fail@PLT
.L28:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	calcule_nb_jetons_depuis_vers, .-calcule_nb_jetons_depuis_vers
	.type	calcule_nb_jetons_depuis, @function
calcule_nb_jetons_depuis:
.LFB8:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$40, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -40(%rbp)
	movl	%esi, %eax
	movb	%al, -44(%rbp)
	movsbl	-44(%rbp), %edx
	movq	-40(%rbp), %rax
	movl	%edx, %ecx
	movl	$1, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	calcule_nb_jetons_depuis_vers
	movl	%eax, -20(%rbp)
	movsbl	-44(%rbp), %edx
	movq	-40(%rbp), %rax
	movl	%edx, %ecx
	movl	$0, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	calcule_nb_jetons_depuis_vers
	movl	%eax, %ebx
	movsbl	-44(%rbp), %edx
	movq	-40(%rbp), %rax
	movl	%edx, %ecx
	movl	$0, %edx
	movl	$-1, %esi
	movq	%rax, %rdi
	call	calcule_nb_jetons_depuis_vers
	addl	%ebx, %eax
	leal	-1(%rax), %edx
	movl	-20(%rbp), %eax
	movl	%edx, %esi
	movl	%eax, %edi
	call	umax
	movl	%eax, -20(%rbp)
	movsbl	-44(%rbp), %edx
	movq	-40(%rbp), %rax
	movl	%edx, %ecx
	movl	$1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	calcule_nb_jetons_depuis_vers
	movl	%eax, %ebx
	movsbl	-44(%rbp), %edx
	movq	-40(%rbp), %rax
	movl	%edx, %ecx
	movl	$-1, %edx
	movl	$-1, %esi
	movq	%rax, %rdi
	call	calcule_nb_jetons_depuis_vers
	addl	%ebx, %eax
	leal	-1(%rax), %edx
	movl	-20(%rbp), %eax
	movl	%edx, %esi
	movl	%eax, %edi
	call	umax
	movl	%eax, -20(%rbp)
	movsbl	-44(%rbp), %edx
	movq	-40(%rbp), %rax
	movl	%edx, %ecx
	movl	$-1, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	calcule_nb_jetons_depuis_vers
	movl	%eax, %ebx
	movsbl	-44(%rbp), %edx
	movq	-40(%rbp), %rax
	movl	%edx, %ecx
	movl	$1, %edx
	movl	$-1, %esi
	movq	%rax, %rdi
	call	calcule_nb_jetons_depuis_vers
	addl	%ebx, %eax
	leal	-1(%rax), %edx
	movl	-20(%rbp), %eax
	movl	%edx, %esi
	movl	%eax, %edi
	call	umax
	movl	%eax, -20(%rbp)
	movl	-20(%rbp), %eax
	addq	$40, %rsp
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	calcule_nb_jetons_depuis, .-calcule_nb_jetons_depuis
	.type	coup_valide, @function
coup_valide:
.LFB9:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -4(%rbp)
	cmpl	$0, -4(%rbp)
	jle	.L33
	cmpl	$7, -4(%rbp)
	jg	.L33
	movl	-4(%rbp), %eax
	subl	$1, %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	addq	%rax, %rax
	movq	%rax, %rdx
	leaq	grille(%rip), %rax
	movzbl	(%rdx,%rax), %eax
	cmpb	$32, %al
	je	.L34
.L33:
	movl	$0, %eax
	jmp	.L35
.L34:
	movl	$1, %eax
.L35:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	coup_valide, .-coup_valide
	.section	.rodata
.LC5:
	.string	"%d"
.LC6:
	.string	"%c"
.LC7:
	.string	"Erreur lors de la saisie\n"
	.align 8
.LC8:
	.string	"Erreur lors de la vidange du tampon.\n"
	.text
	.type	demande_action, @function
demande_action:
.LFB10:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$0, -12(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC5(%rip), %rdi
	movl	$0, %eax
	call	__isoc99_scanf@PLT
	cmpl	$1, %eax
	je	.L37
	leaq	-13(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC6(%rip), %rdi
	movl	$0, %eax
	call	__isoc99_scanf@PLT
	cmpl	$1, %eax
	je	.L38
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$25, %edx
	movl	$1, %esi
	leaq	.LC7(%rip), %rdi
	call	fwrite@PLT
	movl	-12(%rbp), %eax
	jmp	.L45
.L38:
	movzbl	-13(%rbp), %eax
	movsbl	%al, %eax
	cmpl	$81, %eax
	je	.L41
	cmpl	$113, %eax
	jne	.L47
.L41:
	movl	$3, -12(%rbp)
	jmp	.L43
.L47:
	movl	$2, -12(%rbp)
	nop
	jmp	.L43
.L37:
	movl	$1, -12(%rbp)
.L43:
	movq	stdin(%rip), %rax
	movq	%rax, %rdi
	call	vider_tampon
	testl	%eax, %eax
	jne	.L44
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$37, %edx
	movl	$1, %esi
	leaq	.LC8(%rip), %rdi
	call	fwrite@PLT
	movl	$0, -12(%rbp)
.L44:
	movl	-12(%rbp), %eax
.L45:
	movq	-8(%rbp), %rdx
	xorq	%fs:40, %rdx
	je	.L46
	call	__stack_chk_fail@PLT
.L46:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	demande_action, .-demande_action
	.type	grille_complete, @function
grille_complete:
.LFB11:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	$0, -8(%rbp)
	jmp	.L49
.L54:
	movl	$0, -4(%rbp)
	jmp	.L50
.L53:
	movl	-4(%rbp), %ecx
	movl	-8(%rbp), %edx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	addq	%rax, %rax
	leaq	(%rax,%rcx), %rdx
	leaq	grille(%rip), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	cmpb	$32, %al
	jne	.L51
	movl	$0, %eax
	jmp	.L52
.L51:
	addl	$1, -4(%rbp)
.L50:
	cmpl	$5, -4(%rbp)
	jbe	.L53
	addl	$1, -8(%rbp)
.L49:
	cmpl	$6, -8(%rbp)
	jbe	.L54
	movl	$1, %eax
.L52:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	grille_complete, .-grille_complete
	.type	initialise_grille, @function
initialise_grille:
.LFB12:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	$0, -8(%rbp)
	jmp	.L56
.L59:
	movl	$0, -4(%rbp)
	jmp	.L57
.L58:
	movl	-4(%rbp), %ecx
	movl	-8(%rbp), %edx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	addq	%rax, %rax
	leaq	(%rax,%rcx), %rdx
	leaq	grille(%rip), %rax
	addq	%rdx, %rax
	movb	$32, (%rax)
	addl	$1, -4(%rbp)
.L57:
	cmpl	$5, -4(%rbp)
	jbe	.L58
	addl	$1, -8(%rbp)
.L56:
	cmpl	$6, -8(%rbp)
	jbe	.L59
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	initialise_grille, .-initialise_grille
	.type	position_valide, @function
position_valide:
.LFB13:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movl	$1, -4(%rbp)
	movq	-24(%rbp), %rax
	movl	(%rax), %eax
	cmpl	$6, %eax
	jg	.L61
	movq	-24(%rbp), %rax
	movl	(%rax), %eax
	testl	%eax, %eax
	jns	.L62
.L61:
	movl	$0, -4(%rbp)
	jmp	.L63
.L62:
	movq	-24(%rbp), %rax
	movl	4(%rax), %eax
	cmpl	$5, %eax
	jg	.L64
	movq	-24(%rbp), %rax
	movl	4(%rax), %eax
	testl	%eax, %eax
	jns	.L63
.L64:
	movl	$0, -4(%rbp)
.L63:
	movl	-4(%rbp), %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	position_valide, .-position_valide
	.type	statut_jeu, @function
statut_jeu:
.LFB14:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movl	%esi, %eax
	movb	%al, -12(%rbp)
	call	grille_complete
	testl	%eax, %eax
	je	.L67
	movl	$2, %eax
	jmp	.L68
.L67:
	movsbl	-12(%rbp), %edx
	movq	-8(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	calcule_nb_jetons_depuis
	cmpl	$3, %eax
	jbe	.L69
	movl	$1, %eax
	jmp	.L68
.L69:
	movl	$0, %eax
.L68:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE14:
	.size	statut_jeu, .-statut_jeu
	.type	umax, @function
umax:
.LFB15:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -4(%rbp)
	movl	%esi, -8(%rbp)
	movl	-4(%rbp), %eax
	cmpl	%eax, -8(%rbp)
	cmovnb	-8(%rbp), %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE15:
	.size	umax, .-umax
	.type	vider_tampon, @function
vider_tampon:
.LFB16:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
.L74:
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	fgetc@PLT
	movl	%eax, -4(%rbp)
	cmpl	$10, -4(%rbp)
	je	.L73
	cmpl	$-1, -4(%rbp)
	jne	.L74
.L73:
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	ferror@PLT
	testl	%eax, %eax
	sete	%al
	movzbl	%al, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE16:
	.size	vider_tampon, .-vider_tampon
	.section	.rodata
.LC9:
	.string	"Joueur %d : "
	.align 8
.LC10:
	.string	"Vous ne pouvez pas jouer \303\240 cet endroit\n"
.LC11:
	.string	"Le joueur %d a gagn\303\251\n"
.LC12:
	.string	"\303\211galit\303\251"
	.text
	.globl	main
	.type	main, @function
main:
.LFB17:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movb	$79, -29(%rbp)
	call	initialise_grille
	call	affiche_grille
.L91:
	cmpb	$79, -29(%rbp)
	jne	.L77
	movl	$1, %eax
	jmp	.L78
.L77:
	movl	$2, %eax
.L78:
	movl	%eax, %esi
	leaq	.LC9(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	leaq	-28(%rbp), %rax
	movq	%rax, %rdi
	call	demande_action
	movl	%eax, -24(%rbp)
	cmpl	$0, -24(%rbp)
	jne	.L79
	movl	$1, %eax
	jmp	.L90
.L79:
	cmpl	$3, -24(%rbp)
	jne	.L81
	movl	$0, %eax
	jmp	.L90
.L81:
	cmpl	$2, -24(%rbp)
	je	.L82
	movl	-28(%rbp), %eax
	movl	%eax, %edi
	call	coup_valide
	testl	%eax, %eax
	jne	.L83
.L82:
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$40, %edx
	movl	$1, %esi
	leaq	.LC10(%rip), %rdi
	call	fwrite@PLT
	jmp	.L91
.L83:
	movl	-28(%rbp), %eax
	leal	-1(%rax), %edx
	leaq	-16(%rbp), %rax
	movq	%rax, %rsi
	movl	%edx, %edi
	call	calcule_position
	movl	-16(%rbp), %eax
	movl	-12(%rbp), %edx
	movslq	%edx, %rcx
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	addq	%rax, %rax
	leaq	(%rax,%rcx), %rdx
	leaq	grille(%rip), %rax
	addq	%rax, %rdx
	movzbl	-29(%rbp), %eax
	movb	%al, (%rdx)
	call	affiche_grille
	movsbl	-29(%rbp), %edx
	leaq	-16(%rbp), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	call	statut_jeu
	movl	%eax, -20(%rbp)
	cmpl	$0, -20(%rbp)
	je	.L85
	cmpl	$1, -20(%rbp)
	je	.L86
	jmp	.L96
.L85:
	cmpb	$79, -29(%rbp)
	jne	.L88
	movl	$88, %eax
	jmp	.L89
.L88:
	movl	$79, %eax
.L89:
	movb	%al, -29(%rbp)
	jmp	.L91
.L86:
	cmpb	$79, -29(%rbp)
	jne	.L92
	movl	$1, %eax
	jmp	.L93
.L92:
	movl	$2, %eax
.L93:
	movl	%eax, %esi
	leaq	.LC11(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	jmp	.L94
.L96:
	cmpl	$2, -20(%rbp)
	jne	.L94
	leaq	.LC12(%rip), %rdi
	call	puts@PLT
.L94:
	movl	$0, %eax
.L90:
	movq	-8(%rbp), %rcx
	xorq	%fs:40, %rcx
	je	.L95
	call	__stack_chk_fail@PLT
.L95:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE17:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
