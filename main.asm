	.macro printf(%text)
		li $v0,4
		la $a0,%text
		syscall 
	.end_macro 
.data  
linhas:.asciiz "insert the number of rows greater or equal than 2\n"
colunas:.asciiz"insert the number of columns greater or equal than 4\n"
ganhar:.asciiz "\nYOU WON!! || KEY -> "
perder:.asciiz "\nGAME OVER!! || KEY -> "
opcoes:.asciiz "\n\t\t\t\t-----> Vew Points: PRESS p, End Game: PRESS e, Restar Game: r <-----\n"
opcoes2:.asciiz "per"
possiblidades:.asciiz "BGRYWO"
str1: 	.asciiz "  insert a string with the following characters EX: BRWO "
str2: .asciiz "Insert a correct sequence\n"
str3:.asciiz "Do you want to change the alfabet or use the standard one(BGRYWO) to change 0?"
str4:.asciiz"how many initials u want?"
str5:.asciiz"Insert the initials no duplicates"
newLine:.asciiz "\n"
r:.asciiz "|R-"
w:.asciiz "|W-"
	.align 2
possiblidade:.word 0 #guarda endereco de possiblidades
numpossiblidade:.word 0 #guarda o numero
chave:.word 0 #char alocar espaco vai ser o numero de colunas
insercao:.word 0 #char    alocar espaco vai ser o numero de colunas	
tabuleiro:.word 0 #char alocar espaco para o tabuleiro vai ser colunas*linhas
tabuleiro_2:.word 0#alocar espaco vai ser linhas *2
vectorA:.word 0 #alocar espaco vai ser colunas	
.text
.globl main
 main:
add $s0,$0,$0 #variavel do ciclo
add $s1,$0,$0 #count_jogadas
add $s2,$0,$0 #pontuacao
add $s3,$0,$0 #numero linhas
add $s4,$0,$0 # numero colunas

ifmain: #ciclo para verificar se o numero de linhas inserido e maior ou igual a 2
printf(linhas)
li $v0,5
syscall
blt $v0,2,ifmain
move $s3,$v0
ifmain2:#ciclo para verificar se o numero e colunas inserido e maior ou igual a 4
printf(colunas)
li $v0,5
syscall
blt $v0,4,ifmain2
move $s4,$v0

#funcoes para alocar espaco
move $a0,$s4
move $a1,$s3
jal ALOCAR_TABULEIRO
move $a0,$s3
jal ALOCAR_TABULEIRO2
move $a0,$s4
jal ALOCAR_CHAVE_INSERCAO
move $a0,$s4
jal ALOCAR_VETORA
printf(str3)
li $v0,5
syscall
beqz $v0,MUDAR_POSSIBLIDADES#se for 0 vai mudar as possiblidades
la $t0,possiblidades
sw $t0,possiblidade
li $t0,6
sw $t0,numpossiblidade
END_MUDAR_POSSIBLIDADES:
move $a0,$s1
move $a1,$s2
move $a2,$s3
move $a3,$s4
jal JOGO
li $v0,10
syscall
MUDAR_POSSIBLIDADES:	#funcao para mudar as possiblidades default
printf(str4)	
li $v0,5		#le um inteiro ( "how many initials u want?" )
syscall
move $t0,$v0		#t0 = v0 = numero
sw $t0,numpossiblidade	#guarda o conteudo de t0 em numpossiblidade
addi $a0,$t0,1
li $v0,9		#allocate heap memory (v0 contains address of allocated memory)
syscall
sw $v0,possiblidade
lw $t1,possiblidade
printf(str5)
li $v0,8		#read String ( "Insert the initials no duplicates" )
move $a0,$t1
addi $a1,$t0,1
syscall
printf(newLine) 
LOOPVERIFICAR_POS:
li $s5,0
LOOPVERIFICAR_POS1:
lw $t0,numpossiblidade
beq $s5,$t0,END_MUDAR_POSSIBLIDADES
addi $s6,$s5,1
LOOPVERIFICAR_POS2:
lw $t0,numpossiblidade
beq $s6,$t0,LOOPVERIFICAR_POS1_FIM
lw $t1,possiblidade
add $t2,$t1,$s5 #i
add $t3,$t1,$s6 #j
lb $t2,($t2)
lb $t3,($t3)
beq $t2,$t3,MUDAR_POSSIBLIDADES
addi $s6,$s6,1
j LOOPVERIFICAR_POS2
j END_MUDAR_POSSIBLIDADES
LOOPVERIFICAR_POS1_FIM:
addi $s5,$s5,1
j LOOPVERIFICAR_POS1

ALOCAR_TABULEIRO:#funcao para alocar memoria para o tabuleiro recebe em a0 colunas e a1 linhas
mul $a0,$a0,$a1 #colunas*linhas
li $v0,9		#allocate heap memory
syscall
sw $v0,tabuleiro
jr $ra
ALOCAR_TABULEIRO2:#funcao recebe em a0 o numero de linhas e aloca espaco para o tabuleiro2 
sll $a0,$a0,1
li $t0,4
mul $a0,$a0,$t0
li $v0,9		#allocate heap memory
syscall
sw $v0,tabuleiro_2
jr $ra
ALOCAR_CHAVE_INSERCAO:#funcao que recebe em a0 o numero de colunas e aloca espaco para a chave e a isnercao
addi $a0,$a0,1
li $v0,9		#allocate heap memory
syscall
sw $v0,chave
lw $t0,chave
li $v0,9		#allocate heap memory
syscall
sw $v0,insercao
jr $ra
ALOCAR_VETORA:#funcao recebe em ao o numero de colunas e aloca espaco e inicializa tudo a -1
move $t0,$a0
sll $a0,$a0,2
li $v0,9		#allocate heap memory
syscall
sw $v0,vectorA
lw $t1,vectorA
li $t2,-1
add $t5,$0,$0
ALOCAR_VETORA_LOOP: 
beq $t5,$t0,ALOCAR_VETORA_LOOP_END
sll $t3,$t5,2
add $t3,$t1,$t3
sw $t2,($t3)
addi $t5,$t5,1
j ALOCAR_VETORA_LOOP
ALOCAR_VETORA_LOOP_END:
jr $ra
LIMPAR_TABULEIROS:#funcao que limpa os tabuleiros em a0 colunas a1 linhas
addi $sp,$sp,-12
sw $s0,($sp)
sw $s1,4($sp)
sw $s2,8($sp)
add $s0,$0,$0
mul $s1,$a0,$a1 
sll $s2,$a1,1
lw $t0,tabuleiro_2
LIMPLOOP:#loop para limpar o tabuleiro de inteiros
beq $s0,$s2,ENDLIMPLOOP
sll $t1,$s0,2
add $t1,$t0,$t1
sw $0,($t1)
addi $s0,$s0,1
j LIMPLOOP
ENDLIMPLOOP:
add $s0,$0,$0
lw $t0,tabuleiro
LIMPLOOP2:#loop para limpar o tabuleiro de carateres
beq $s0,$s1,ENDLIMPLOOP2
add $t1,$t0,$s0
sb $0,($t1)
addi $s0,$s0,1
j LIMPLOOP2
ENDLIMPLOOP2:
lw $s0,($sp)
lw $s1,4($sp)
lw $s2,8($sp)
addi $sp,$sp,12
jr $ra



JOGO:
#funcao que recebe o count_jogadas em a0 e a pontuacao em a1 as linhas em a2 e as colunas em a3 
#esta funcao pega nas outras funcoes todas e faz com que o jogo funcione 
#tambem e responsavel por acabar o jogo recomeca-lo e mostrar a pontuacao
addi $sp,$sp,-24
sw $s0,($sp)
sw $s1,4($sp)
sw $s2,8($sp)
sw $s3,12($sp)
sw $s4,16($sp)
sw $ra,20($sp)
add $s0,$0,$0 #variavel do ciclo 
move $s1,$a0 #count jogadas
move $s2,$a1 #pontuacao
move $s3,$a2 #linhas
move $s4,$a3 #colunas
SORTEIALOOP:
#ciclo para sortear a cominacao
jal SORTEIA
lw $t0,chave
add $t0,$s0,$t0
sb $v0,($t0)
addi $s0,$s0,1
bne $s0,$s4,SORTEIALOOP


JOGOLOOP: 
#ciclo que esta sempre a ler verificar e comparar a sequencia e imprimir o tabuleiro ate a combinacao
#ser certa ou acabar as 10 jogadas
lw $a0,chave
li $v0,4		#print string
syscall
printf(newLine)
JOGOVER:
#ciclo para verificar a sequencia a funcao esta sempre neste ciclo ate por uma sequencia que e valida
move $a0,$s4
jal lerS
lw $a0,insercao
move $a1,$s4
jal verS 
bne $v0,0,JOGOVER
move $a0,$s4
lw $a1,chave
lw $a2,insercao
move $a3,$s1
jal COMPARARSEQUENCIA
move $a0,$s1
move $a1,$s4
lw $a2,tabuleiro_2
lw $a3,insercao
jal IMPRIMIRTAB
move $a0,$s1
move $a1,$s2
move $a2,$s3
move $a3,$s4
jal FIMDEJOGO
bge $v0,0,ENDJOGOLOOP
addi $s1,$s1,1
j JOGOLOOP
ENDJOGOLOOP:
move $s2,$v0
JOGOLOOP2: #ciclo para estar sempre a perguntar pela pontuacao ,acabar ou recomecar o jogo
printf(opcoes)
la $t0,opcoes2
lb $t1,($t0)
li $v0,12		#read character
syscall
move $t2,$v0
printf(newLine)
beq $t1,$t2,JOGOPONTOS
lb $t1,1($t0)
beq $t1,$t2,JOGOACABAR
lb $t1,2($t0)
beq $t1,$t2,JOGORECOMECAR
j JOGOLOOP2
JOGOPONTOS:
move $a0,$s2
li $v0,1		#print integer
syscall
printf(newLine)
j JOGOLOOP2
JOGORECOMECAR:
jal LIMPAR_TABULEIROS
add $s1,$0,$0
move $a0,$s1
move $a1,$s2
move $a2,$s3
move $a3,$s4
lw $s0,($sp)
lw $s1,4($sp)
lw $s2,8($sp)
lw $s3,12($sp)
lw $s4,16($sp)
lw $ra,20($sp)
addi $sp,$sp,24
j JOGO
JOGOACABAR:
lw $s0,($sp)
lw $s1,4($sp)
lw $s2,8($sp)
lw $s3,12($sp)
lw $s4,16($sp)
lw $ra,20($sp)
addi $sp,$sp,24
jr $ra


#inicio do sorteio

SORTEIA:
#envia como retorno o endereco do caracter
#chama a sorteianum recebe o numero e soma esse numero ao endereco de memoria da possiblidades para ter um carater
	addi $sp,$sp,-4
	sw $ra,0($sp)
	jal SORTEIANUM
	lw $t0,possiblidade
	add $t0,$t0,$v0  #numero passado pela sorteinum
	lb $v0,($t0)
	lw $ra,0($sp)
	addi $sp,$sp,4
	jr $ra		

SORTEIANUM: 
#sorteia um numero de 0 a 5 e retorna esse numero
	li $v0,42			#random int range
	lw $a1,numpossiblidade	
	syscall
	move $v0,$a0
	jr $ra
#fim do sorteio

#ler sequencia
lerS:	
#funcao que le a sequencia inserida pelo utilizador e guarda em insercao em a0 recebe colunas

	addi $t0,$a0,1
	li $v0,4			#printf String
	lw $a0,possiblidade		#$a0 = address of null-terminated string to print
	syscall
	printf(str1)			
	printf(newLine)
	li $v0,8			#read string ( "  insert a string with the following characters EX: BRWO " )
	lw $a0,insercao
	move $a1,$t0
	syscall
	printf(newLine)
	jr $ra
#fim da ler sequencia

	
COMPARARSEQUENCIA:
#recebe como argumento ao = colunas | a1 = chave e | a2 = insercao | a3 = count_jogadas 
#funcao void que guarda os valores de countR e countW no tabuleiro 
#dos count
addi $sp,$sp,-20
sw $s0,($sp)
sw $s1,4($sp)
sw $s2,8($sp)
sw $s3,12($sp)
sw $s4,16($sp)
add $s0,$0,$0 #variavel do loop i
add $s1,$0,$0 #countR
add $s2,$0,$0 #countW
add $s3,$0,$0 #variavel do loop j
lw $s4,vectorA
CMPLOOP1:#loop que esta resonsavel por ver o countR
bge $s0,$a0,CMPENDLOOP1
add $t0,$a1,$s0
add $t1,$a2,$s0
lb $t0,($t0)
lb $t1,($t1)
bne $t0,$t1,CMPELSE1
sll $t0,$s0,2
add $t0,$t0,$s4
sw $s0,($t0)
addi $s1,$s1,1
addi $s0,$s0,1
j CMPLOOP1
CMPENDLOOP1:
add $s0,$0,$0
CMPLOOP2:#loop que esta responsavel por ver o countW
bge $s0,$a0,CMPENDLOOP2
add $s3,$0,$0
CMPLOOP3:
bge $s3,$a0,CMPENDLOOP3
sll $t0,$s0,2
add $t0,$t0,$s4
lw $t0,($t0)
beq $t0,$s0,CMPIF2
add $t0,$s0,$a1
lb $t0,($t0)
add $t1,$s3,$a2
lb $t1,($t1)
beq $t0,$t1,CMPIF3
addi $s3,$s3,1
j CMPLOOP3
CMPENDLOOP3:
addi $s0,$s0,1
j CMPLOOP2
CMPENDLOOP2:
lw $t3,tabuleiro_2
sll $t0,$a3,1
sll $t1,$t0,2
add $t1,$t1,$t3
sw $s1,($t1)
addi $t0,$t0,1
sll $t1,$t0,2
add $t1,$t1,$t3
sw $s2,($t1)
lw $t1,vectorA
li $t2,-1
add $s0,$0,$0
CMPLOOP4: #voltar a por o vetor a direito
beq $s0,$a0,CMPENDLOOP4
sll $t3,$s0,2
add $t3,$t1,$t3
sw $t2,($t3)
addi $s0,$s0,1
CMPENDLOOP4:
lw $s0,($sp)
lw $s1,4($sp)
lw $s2,8($sp)
lw $s3,12($sp)
lw $s4,16($sp)
addi $sp,$sp,20

jr $ra 

CMPIF2:
addi $s0,$s0,1
j CMPLOOP2
CMPIF3:
sll $t0,$s3,2
add $t0,$t0,$s4
lw $t0,($t0)
bne $t0,$s3,CMPIF4
CMPIF4:
sll $t0,$s0,2
add $t0,$t0,$s4
sw $s3,($t0)
addi $s2,$s2,1
addi $s0,$s0,1
j CMPLOOP2
CMPELSE1:
addi $s0,$s0,1
j CMPLOOP1


#inicio imprimir tabuleiro
IMPRIMIRTAB:#recebe como argumneto a0 = count_jogadas | a1 =  colunas | a2 = tab2 | a3 = insercao
#imrpime o tabuleiro de carateres e o tabuleiro de inteiros para os pinos vermelhos e brancos
#imprime o tabuleiro atual por exemplo:se o count for 2 imorime a jogada 0,1,2
addi $sp,$sp,-20
sw $s0,($sp)
sw $s1,4($sp)
sw $s2,8($sp)
sw $s3,12($sp)
sw $s4,16($sp)
add $s0,$0,$0 #i
move $s2,$a0 #countjogadas
addi $s3,$s2,1
lw $s4,tabuleiro
IMPRIMIRTABLOOP1:#loop para cada jogada
bge $s0,$s3,IMPRIMIRTABENDLOOP1
add $s1,$0,$0 #j
IMPRIMIRTABLOOP2:#loop para imprimir os 4 carateres da insercao da jogada
bge $s1,$a1,IMPRIMIRTABENDLOOP2
sll $t1,$s2,2
add $t1,$t1,$s1
add $t1,$t1,$s4
add $t2,$a3,$s1
lb $t2,($t2)
sb $t2,($t1)
sll $t1,$s0,2
add $t1,$t1,$s1
add $t1,$t1,$s4
lb $a0,($t1)
li $v0,11
syscall
addi $s1,$s1,1
j IMPRIMIRTABLOOP2
IMPRIMIRTABENDLOOP2: #imprime o tabuleiro dos inteiros o countR e countW
sll $t0,$s0,1
sll $t0,$t0,2
add $t1,$t0,$a2
lw $t0,($t1)
lw $t1,4($t1)
printf(r)
move $a0,$t0
li $v0,1
syscall
printf(w)
move $a0,$t1
li $v0,1
syscall
printf(newLine)
addi $s0,$s0,1
j IMPRIMIRTABLOOP1

IMPRIMIRTABENDLOOP1:
lw $s0,($sp)
lw $s1,4($sp)
lw $s2,8($sp)
lw $s3,12($sp)
lw $s4,16($sp)
addi $sp,$sp,20
jr $ra

#fim imprimir tab



#inicio da fim de jogo 
FIMDEJOGO:#recebe em a0 o countjogadas e em a1 a pontuacao em a2 as linhas em a3 as colunas retorna -1 ou retorna a pontuacao se acabou
#funcao que verifica se o jogo ja acabou ou por ter passado das 10 jogadas ou por ter acertado a combinacao
#manda uma mensagem a dizer se ganhou ou perdeu e a combinacao
addi $sp,$sp,-20
sw $s0,($sp)
sw $s1,4($sp)
sw $s2,8($sp)
sw $s3,12($sp)
sw $s4,16($sp)
addi $s4,$a2,-1
lw $s0,tabuleiro_2
move $s1,$a0    #count_jogadas
move $s2,$a1     #pontuacao
add $s3,$0,$0    #countR
sll $t0,$s1,1
sll $t0,$t0,2
add $t0,$s0,$t0
lw $t0,($t0)
move $s3,$t0
beq $t0,$a3,FIMDEJOGOIF1
beq $s1,$s4,FIMDEJOGOIF2
lw $s0,($sp)
lw $s1,4($sp)
lw $s2,8($sp)
lw $s3,12($sp)
lw $s4,16($sp)
addi $sp,$sp,20
li $v0,-1
jr $ra
FIMDEJOGOIF1:
printf(ganhar)
lw $a0,chave
li $v0,4
syscall
printf(newLine)
addi $s2,$s2,12 
move $v0,$s2
lw $s0,($sp)
lw $s1,4($sp)
lw $s2,8($sp)
lw $s3,12($sp)
lw $s4,16($sp)
addi $sp,$sp,20
jr $ra
FIMDEJOGOIF2:
printf(perder)
lw $a0,chave
li $v0,4
syscall
printf(newLine)
addi $s2,$s2,-3
li $t0,3
mul $t0,$s3,$t0
add $s2,$s2,$t0
bge $s2,0,FIMDEJOGOIF3
add $s2,$0,$0
FIMDEJOGOIF3:
move $v0,$s2
lw $s0,($sp)
lw $s1,4($sp)
lw $s2,8($sp)
lw $s3,12($sp)
lw $s4,16($sp)
addi $sp,$sp,20
jr $ra 

#fim da fim de jogo

#inicio ver sequencia			
verS:				#recebe como argumento o endereço de inserção e em a1 as colunas
#verifica se a sequencia inserida esta de acordo com os parametros retorna 1 se nao for e 0 se estiver de acordo
	addi $sp,$sp,-12
	sw $s0,0($sp)
	sw $s1,4($sp)
	sw $s2,8($sp)
	sw $s3,12($sp)
	lw $s1,possiblidade
	lw $t6,numpossiblidade
	add $s0,$0,$0		#s0 = 0 = i variavel de ciclo
	add $s2,$0,$0		#s2 = 0
	add $s3,$0,$0		#s3 = 0 
	move $t0,$s1		#t0 = s1 = endereço de possiblidades
	move $t1,$a0		#t1 = a0 = endereço de inserçao
verSLOOP:
	add $t2,$s2,$t0		#t2 = t0[s2] == 24 = possiblidades[s2]
	lb $t3,($t2)
	add $t4,$s3,$t1		#t4 = t1[s3] == t4 = inserçao[s3]
	lb $t5,($t4)
	beq $t5,$t3,cmpeq	#if t5 != t3 jump to cmpne
	beq $s2,$t6,endVerSLOOP2
	addi $s2,$s2,1		#se nao forem iguais significa que o caracter inserçao[s3] nao é igual a possiblidades[s2] ou seja incrementamos t3 para ver se na proxima posiçao estes ja sao iguais, como pretendido
	beq $s0,$a1,endVerSLOOP1	#if i == 4 (fim do ciclo), significa que todas os caracteres de insercao sao possiblidades, ou seja, return 0 tudo okay
	j verSLOOP
cmpeq:				
	addi $s3,$s3,1		#se forem iguais significa que insercao[s3] corresponde a uma opçao valida, ou seja testamos a proximo possicao a ver se o mesmo acontece
	addi $s0,$s0,1		#incrementa a variavel de ciclo
	add $s2,$0,$0		#s2 = 0 para começar na posicao 0 no veter possiblidades
	j verSLOOP
endVerSLOOP1:
	lw $s0,0($sp)
	lw $s1,4($sp)
	lw $s2,8($sp)
	lw $s3,12($sp)
	addi $sp,$sp,12
	add $v0,$0,$0		#return 0 if i == 4, o que significa que todas as posicoes de insercao sao validas
	jr $ra
endVerSLOOP2:
        printf(str2)
	lw $s0,0($sp)
	lw $s1,4($sp)
	lw $s2,8($sp)
	lw $s3,12($sp)
	addi $sp,$sp,12
	addi $v0,$0,1		#return 1 if s2 == 6, o que significa que todas as possiblidades foram testadas
	jr $ra
	
	#verificar sequencia
