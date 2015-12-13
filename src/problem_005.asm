global problem_005

section .text
	; This problem relies on the prime factorization of all the numbers below n.
	; We only multiple all the prime powers (including p^1) below n.
	; We multiply those all up and return that product.
	; This problem can trivially be done on a hand calculator with n of only 20.
	; 16 * 9 * 5 * 7 * 11 * 13 * 17 * 19 = 232792560
problem_005:
	; r8 is a bit for the sieve or eratosthenes.
	; We can't conceivably need more bits than this.
	mov r8,0fffffffffffffffch
	mov r9,1 ; r9 is the product of all prime powers so far.
	xor rcx,rcx ; This is the counter.

n: equ 20

.main:	inc rcx
	bt r8,rcx
	jc .prime
.L1	cmp rcx,n
	jb .main

	mov rax,r9   ; *WARNING* returns right here.
	ret

.prime:	mov rax,rcx ; Sieve found a prime.
	mul rax

.wipe_composites:   ; Wipe all multiples of rcx
	cmp rax,n
	ja .find_pp
	btr r8,rax
	add rax,rcx
	jmp .wipe_composites

.find_pp:   ; Now find the highest prime power less than n
	mov rax,rcx
.pp_loop:
	mov rbx,rax ; backup the current prime power.
	mul rcx
	cmp rax,n
	jbe .pp_loop

	imul r9,rbx
	jmp .L1
