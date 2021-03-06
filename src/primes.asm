extern gcd

global pow_mod_m
global _is_prime
global is_prime

global _factor
global factor

section .data
witness: db 37,31,29,23,19,17,13,11,7,5,3,2
witness_len: equ $-witness
witness_product: equ 7420738134810

section .bss
composite_factors: resq 64
prime_factors: resq 64

section .text
_factor:
factor:
	; Receives:
	;  rsi = number to factor
	; Returns:
	;  rax = number of prime factors
	;  rsi = list of factors (in no particular order)
	; Requires:
	; rax rbx rcx rdx rdi rsi r8 r9 r10 r11 r12 r13 r14

	mov r12,composite_factors ; ptr to top element of composite_factors
	mov r13,prime_factors ; ptr to top element of prime_factors
	xor r14,r14  ; number of prime factors
	mov [r12],rsi

.L1:	mov rsi,[r12]
	call is_prime
	test al,al
	jnz .found_prime

	xor rcx,rcx
.rho_loop:
	dec rcx
	mov rax,rcx
	mov rbx,rsi

	call gcd
	cmp rax,1
	je .rho_loop
	cmp rax,rsi
	je .rho_loop

	; rax is now a non-trivial factor
	mov [r12],rax  ; Push it to the stack.

	xchg rax,rsi   ; Divide our composite by the new non-trivial factor.
	xor rdx,rdx
	div rsi

	add r12,8      ; Increment the stack and push the other non-trivial factor.
	mov [r12],rax
	jmp .L1

.found_prime:
	mov [r13],rsi ; Add prime to the list of primes.
	add r13,8     ; increment prime pointer
	sub r12,8     ; decrement composite pointer.
	inc r14

	cmp r12,composite_factors
	jae .L1       ; Loop while the composite_factors stack is non-empty.

	mov rax,r14
	mov rsi,prime_factors
	ret

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

_is_prime:
is_prime:
	; Receives:
	;  rsi - number to test for primality
	; Returns:
	;  rax - 1 if prime, 0 if composite
	; Requires:
	;  rbx rcx rdx rdi r8 r9 r10 r11

	cmp rsi,1
	jbe .composite ; 0 and 1 are not prime

	mov r8,witness
	mov rcx,witness_len
	xor rbx,rbx

.L1:	mov bl,[r8] ; Make sure the number isn't a witness, which are all prime.
	cmp rsi,rbx

	je .prime
	inc r8
	loop .L1

	cmp rsi,41  ; All numbers less than 41 that are not a witness are composite.
	jb .composite

	mov rbx,rsi  ; This is basically an optimized trial division for the first several primes.
	mov rax,witness_product
	call gcd
	cmp rax,1
	jne .composite

	mov r9,rsi  ; r9 will have a copy of n - 1
	dec r9
	mov r11,r9  ; r11 has (n - 1) will trailing zeroes dropped

.L2:    inc bh      ; calculate tzcnt of n-1. Store tzcnt in bh.
	shr r11,1   ; keep n-1 with trailing zeroes dropped in r11
	test r11,1
	jz .L2

	mov bl,witness_len  ; bl is the loop limit for the outer loop.
	xor cl,cl    ; cl is the loop counter for the outer loop

.L3:	inc cl
	cmp bl,cl
	je .prime ; If we've check all witnesses, it is prime.

	dec r8
	xor rax,rax
	mov rdi,r11
	mov al,[r8]
	call pow_mod_m

	cmp rax,1
	je .L3
	cmp rax,r9
	je .L3

	mov ch,bh  ; ch is the loop counter for the inner loop
	; We need bh - 1 iterations.
	; bh will always be no less than 1, and decrementing the counter in
	; a do-while not-zero loop gives us what we need.

.L4:	mul rax
	div rsi
	dec ch      ; Update loop counter. We do it here.
	mov rax,rdx

	cmp rax,1
	je .composite
	cmp rax,r9
	je .L3

	test ch,ch
	jnz .L4

.composite:
	xor rax,rax
	ret

.prime:
	mov rax,1
	ret
