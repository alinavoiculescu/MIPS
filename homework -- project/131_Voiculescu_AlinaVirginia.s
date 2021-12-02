.data
	G:   .space 1600
	roles: .space 80
	queue: .space 80
	visited: .space 80
	str: .space 100	
	n:	  .space 4			# numarul de linii = numarul de coloane
	nrMuchii: .space 4			# numarul de muchii de citit
	ch: .byte 'j'
	strsp:	  .asciiz " "
	strnl:	  .asciiz "\n"
	msg1: .asciiz " host index "
	msg2: .asciiz " switch index "
	msg3: .asciiz "\nswitch malitios index "
	msg4: .asciiz " controller index "
	msg5: .asciiz " switch malitios index "
	msg6: .asciiz "switch malitios index "
	msg7: .asciiz "host index "
	Yes: .asciiz "\nYes"
	No: .asciiz "\nNo"
	colon: .asciiz ":"
	semicolon: .asciiz ";"
.text

main:
	li $v0, 5				# apel sistem READ WORD
	syscall
	
	sw $v0, n				# val. citita este in $v0 si o mut in n

	li $v0, 5				# apel sistem READ WORD
	syscall

	sw $v0, nrMuchii			# val. citita este in $v0 si o mut in nrMuchii

	lw $t0, nrMuchii			# iau nrMuchii in $t0
	lw $t6, n				# punem n in $t6
	li $t1, 0				# pe post de i din for-ul de mai sus
	li $s5, 0
for_edges:
	bge $t1, $t0, end_matrix		# execut cat timp i < nrMuchii, i.e. cat timp $t1 < $t0
						# deci ies cand $t1 >= $t0
	li $v0, 5
	syscall
	move $t2, $v0				# $t2 este acum "left"
	
	li $v0, 5
	syscall
	move $t3, $v0				# $t3 este acum "right"

	# calculam, pentru inceput, left * n in $t4
	mul $t4, $t2, $t6			# $t4 = $t2 (left) * $t6 (n)
	# la rezultat, adaugam right
	add $t4, $t4, $t3			# $t4 = $t4 + $t3 (right)
	# il inmultim cu 4
	mul $t4, $t4, 4				# $t4 = $t4 * 4

	# trebuie acum ca matrix($t4) sa fie egal cu 1
	li $t5, 1
	sw $t5, G($t4)

	# analog pentru right, refolosim $t4
	mul $t4, $t3, $t6
	add $t4, $t4, $t2
	mul $t4, $t4, 4
	sw $t5, G($t4)

	addi $t1, 1				# $t1 := $t1 + 1 i.e. i++
	j for_edges

end_matrix:	#se refac registrii
	move $t1, $t0	#in $t0 e nr nodurilor
	move $t0, $t6	#in $t1 e nr muchiilor
	sub $t2,$t0,1	#in $t2 e nr noduri-1
	li $t3, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t7, 0
	li $t8, 0
	li $t9, 0

prelucare_roles:
	bge $t3, $t0, cerinta		#cand terminam prelucrarea rolurilor, sarim la eticheta cerinta
	mul $t4, $t3, 4		#$t4 e index, merge din 4 in 4

	li $v0,5
	syscall

	move $t5, $v0		#$t5 este, pe rand, roles[i]
	sw $t5, roles($t4)

	add $t3, $t3, 1

	j prelucare_roles

cerinta:
	li $v0,5
	syscall

	beq $v0, 1, nota5
	beq $v0, 2, nota7
	beq $v0, 3, nota10

nota5:
	li $t3, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t7, 0
	li $t8, 0
	li $t9, 0
	j for_roles

for_roles:
	bge $t3, $t0, et_exit		#cand am terminat verificarea rolurilor, sarim la et_exit

	mul $t4,$t3,4		#$t3 e indexul, $t4 e indexul*4

	lw $t5, roles($t4)	#roles[4*index]

	beq $t5, 3, verif		#daca $t5 e switch malitios, adica daca e egal cu 3, sari la verif

	add $t3,$t3,1
	j for_roles

for_columns:
	bge $t7, $t0, cont_for_roles

	mul $t1, $t3, $t0		#G[$t1] este G[i][j], j ul fiind $t7
	add $t1, $t1, $t7
	mul $t1, $t1, 4

	lw $t8, G($t1)
	beq $t8, 1, if_j

	add $t7, $t7, 1

	j for_columns	

cont_for_roles:
	add $t3, $t3, 1
	j for_roles

cont_for_columns:
	add $t7, $t7, 1
	j for_columns

afisare1:
	la $a0, msg6
	li $v0, 4
	syscall

	move $a0, $t3
	li $v0,1
	syscall

	la $a0, colon
	li $v0, 4
	syscall

	j for_columns

verif:
	li $t7, 0
	add $t6, $t6, 1
	beq $t6, 1, afisare1

afisare_1:
	la $a0, msg3
	li $v0, 4
	syscall

	move $a0, $t3
	li $v0,1
	syscall

	la $a0, colon
	li $v0, 4
	syscall

	j for_columns

afisare_2.1:
	la $a0, msg1
	li $v0, 4
	syscall	

	move $a0, $t7
	li $v0,1
	syscall

	la $a0, semicolon
	li $v0, 4
	syscall

	j cont_for_columns

afisare_2.2:
	la $a0, msg2
	li $v0, 4
	syscall	

	move $a0, $t7
	li $v0,1
	syscall

	la $a0, semicolon
	li $v0, 4
	syscall

	j cont_for_columns

afisare_2.3:
	la $a0, msg5
	li $v0, 4
	syscall	

	move $a0, $t7
	li $v0,1
	syscall

	la $a0, semicolon
	li $v0, 4
	syscall

	j cont_for_columns

afisare_2.4:
	la $a0, msg4
	li $v0, 4
	syscall	

	move $a0, $t7
	li $v0,1
	syscall	

	la $a0, semicolon
	li $v0, 4
	syscall	

	j cont_for_columns
if_j:
	mul $t9, $t7, 4
	lw $t9, roles($t9)
	beq $t9, 1, afisare_2.1
	beq $t9, 2, afisare_2.2
	beq $t9, 3, afisare_2.3
	beq $t9, 4, afisare_2.4

nota7:
	li $t2, 0
	li $t3, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t7, 0
	li $t8, 0
	li $t9, 0
	j BFS

BFS:
	sw $0, queue($t2)
	add $t2, $t2, 1
	li $t7, 1
	sw $t7, visited($0)
	j while1

while1:
	beq $t3, $t2, YesOrNo
	mul $t4, $t3, 4
	lw $t5, queue($t4)
	add $t3, $t3, 1
	mul $t4, $t3, 4
	j if1

if1:
	mul $t8, $t5, 4
	lw $s2, roles($t8)
	beq $t7, $s2, verifi
	j cont_while1

verifi:
	add $t9, $t9, 1
	beq $t9, $t7, afisarenosp
	j afisaresp

afisarenosp:
	la $a0,msg7
	li $v0, 4
	syscall

	move $a0, $t5
	li $v0, 1
	syscall

	la $a0, semicolon
	li $v0, 4
	syscall

	j cont_while1

afisaresp:
	la $a0,msg1
	li $v0, 4
	syscall

	move $a0, $t5
	li $v0, 1
	syscall

	la $a0, semicolon
	li $v0, 4
	syscall

	j cont_while1

cont_while1:
	li $t6, 0
	j while2

while2:
	bge $t6, $t0, while1

	mul $t9, $t5, $t0
	add $t9, $t9, $t6
	mul $t9, $t9, 4

	lw $s3, G($t9)
	beq $t7, $s3, if3

	j cont_while2

cont_while2:
	add $t6, $t6, 1
	j while2

if3:
	mul $s0, $t6, 4
	lw $s4, visited($s0)
	beq $t7, $s4, cont_while2
	mul $s1, $t2, 4
	sw $t6, queue($s1)
	add $t2, $t2, 1
	sw $t7, visited($s0)
	j cont_while2

YesOrNo:
	bge $s5, $t0, YES
	mul $s6, $s5, 4
	lw $s7, visited($s6)
	beq $0, $s7, NO
	add $s5, $s5, 1
	j YesOrNo
	
YES:
	la $a0, Yes
	li $v0, 4
	syscall

	j et_exit

NO:
	la $a0, No
	li $v0, 4
	syscall

	j et_exit

nota10:
	li $t1, 0
	li $t2, 0
	li $t3, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t7, 0
	li $t8, 0
	li $t9, 0
	li $s0, 0
	li $s1, 0
	li $s2, 0
	li $s3, 0
	li $s4, 0
	li $s5, 0
	li $s6, 0
	li $s7, 0
	j citire

citire:
	li $v0, 5
	syscall
	move $s1, $v0

	li $v0,5
	syscall
	move $s2, $v0

	li $v0, 8

	la $a0, str
	li $a1, 20

	move $s4, $a0
	syscall

	li $t4, 1

	li $s5, 3

	j verific1

#trb sa fac for j in range $t0, daca G[host1][j]=1, verific daca roles[4*j]==3 si pt host 2 la fel
#daca da, e nesigur

verific1:
	bge $t1, $t0, verific2		#for j in range ($t0), j fiind $t1

	mul $t2, $s1, $t0		#G[host1][j] --> G[$t2]
	add $t2, $t2, $t1
	mul $t2, $t2, 4

	lw $t3, G($t2)			# $t3 == G($t2)
	beq $t3, $t4, verifmalitios1	#daca G[host1][j]==1, verif daca e malitios

	add $t1, $t1, 1			#daca nu e malitios, crestem j ul
	j verific1

verifmalitios1:
	mul $t5, $t1, 4			#roles[4*j]
	lw $t6, roles($t5)		#roles[4*j]==$t6

	beq $t6, $s5, rest1		#daca roles[4*j]==3, e nesigur si sarim la nesigur

	add $t1, $t1, 1			#daca nu, crestem j ul
	j verific1

verific2:
	bge $t7, $t0, rest2		#for j in range ($t0), j fiind $t7

	mul $t8, $s2, $t0		#G[host2][j] --> G[$t8]
	add $t8, $t8, $t7
	mul $t8, $t8, 4

	lw $t9, G($t8)			#G[$t8]==$t9
	beq $t9, $t4, verifmalitios2	#daca G[host2][j]==1, verificam daca e nesigur

	add $t7, $t7, 1
	j verific2

verifmalitios2:
	mul $s0, $t7, 4		#roles[4*j]
	lw $s3, roles($s0)	#roles[4*j]==$s3

	beq $s3, $s5, rest1	#daca roles[4*j]==3, sarim la rest1

	add $t7, $t7, 1		#incrementam j ul
	j verific2

rest1:
	li $t0, 0
	li $t1, 0
	li $t2, 0
	li $t3, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t7, 0
	li $t8, 0
	li $t9, 0
	li $s0, 0
	li $s1, 0
	li $s2, 0
	li $s3, 0
	li $s5, 0
	li $s6, 0
	li $s7, 0
	j nesigur

rest2:
	li $t0, 0
	li $t1, 0
	li $t2, 0
	li $t3, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t7, 0
	li $t8, 0
	li $t9, 0
	li $s0, 0
	li $s1, 0
	li $s2, 0
	li $s3, 0
	li $s5, 0
	li $s6, 0
	li $s7, 0
	j sigur

nesigur:
	li $t0, 0
	lb $t1, str($t0)
	lb $t2, ch
	j loop_nesigur

loop_nesigur:
	beq $t1, $0, et_exit
	
	bge $t1, $t2, caz2
	add $t1, $t1, 16

	move $a0, $t1
	li $v0, 11
	syscall

	add $t0, $t0, 1
	lb $t1, str($t0)

	j loop_nesigur

caz2:
	sub $t1, $t1, 10
	
	move $a0, $t1
	li $v0, 11
	syscall

	add $t0, $t0, 1
	lb $t1, str($t0)

	j loop_nesigur

sigur:
	li $t3, 0
	lb $t4, str($t3)
	lb $t5, ch
	j loop_sigur

loop_sigur:
	beq $t4, $0, et_exit

	move $a0, $t4
	li $v0, 11
	syscall

	add $t3, $t3, 1
	lb $t4, str($t3)

	j loop_sigur

et_exit:
	li $v0,10
	syscall