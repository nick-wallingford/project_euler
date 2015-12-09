global pow_mod_m
global is_prime
global factor

section .data
witness: db 2,3,5,7,11,13,17,19,23,29,31,37
witness_len: equ $-witness

section .bss
composite_factors: resq 64
prime_factors: resq 64

section .text
factor:
	; Requires:
	;  rax = number to factor
	; Returns:
	;  rax = number of prime factors
	;  rsi = list of factors (in no particular order)

	mov rcx,rax
	call is_prime
	test al,al
	jnz .cont
	mov rsi,prime_factors
	mov [rsi],rcx
	ret
.cont:
	mov rdi,prime_factors
	xor rcx,rcx

pow_mod_m:
	; Receives:
	;  rax = base
	;  rdi = exponent
	;  rsi = modulus
	; Returns:
	;  rax = (base^exponent)%modulus
	; Requires:
	;  rdx rdi r10

	cmp rsi,1    ; if modulus == 1, return 0
	jne .L0      ; by design, this will raise a divide by zero
	xor rax,rax  ; exception if modulus == 0
	ret

.L0:	xor rdx,rdx   ; base %= modulus
	div rsi
	mov rax,rdx
	mov r10,1    ; result = 1

.L1:	test rdi,1
	jz .L2

	; result = (result * base) % modulus
	xchg rax,r10   ; r10 = base, rax = result
	mul r10        ; rdx:rax = result * base
	div rsi        ; rdx = (result*base) % modulus ; rax gets some garbage we don't care about
	mov rax,r10    ; rax = base
	mov r10,rdx    ; r10 = result

.L2:	shr rdi,1 ; exponent /= 2

	mul rax ; base = (base*base) % modulus
	div rsi
	mov rax,rdx

	test rdi,rdi ; while(exponent != 0)
	jnz .L1

	mov rax,r10
	ret

is_prime:
	; Requires:
	;  rax - number to test for primality

	mov rsi,witness
	xor rbx,rbx
	mov rcx,witness_len
.L1:
	mov bl,[rsi] ; Make sure the number isn't a witness, which are all prime.
	cmp rax,rbx
	je .prime
	inc rsi
	loop .L1

	cmp rax,41  ; All numbers less than 41 that are not a witness are composite.
	jb .composite

	test rax,1  ; All remaining even numbers are composite.
	jz .composite

	mov r9,rax  ; r9 = n = modulus
	mov r11,rax ; r11 = d
	xor bh,bh ; bh = r
	dec r11
	mov r12,r11 ; r12 = n - 1

.L2:                ; write rax - 1 as 2^bh * r11
	inc bh      ; this is trailing zero count of r11
	shr r11,1   ; We don't have the tzcnt instruction, so we do it the old fashioned way.
	test r11,1
	jz .L2

	dec bh      ; bh is the loop limit for the inner loop
	mov bl,witness_len  ; bl is the loop limit for the outer loop.

	mov rsi,witness
	xor cl,cl    ; cl is the loop counter for the outer loop
.L3:
	inc cl
	cmp bl,cl
	je .prime ; If we've check all witnesses, it is prime.

	xor r8,r8
	mov r8b,[rsi]
	mov r10,r11
	inc rsi
	call pow_mod_m

	cmp rax,1
	je .L3
	cmp rax,r12
	je .L3

	xor ch,ch  ; ch is the loop counter for the inner loop
.L4:
	mul rax
	div r9
	mov rax,rdx

	cmp rax,1
	je .composite
	cmp rax,r12
	je .L3

	inc ch
	cmp ch,bh
	jb .L4

	jmp .composite
.prime:
	mov rax,1
	ret

.composite:
	xor rax,rax
	ret
