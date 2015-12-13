global problem_004

section .text
check_palindrome:
	; Receives:
	;  rax - the number the check.
	; Returns:
	;  rax - zero if palindrome, non-zero if non-palindrome.
	; Requires:
	;  rbx rdx r12 r13
	mov rbx,10
	mov r12,rax
	xor r13,r13
.L1:	xor rdx,rdx
	div rbx

	lea r13,[r13+4*r13]  ; r13 *= 5   ; Cheaty way to mul by 10
	shl r13,1            ; r13 *= 2
	add r13,rdx

	test rax,rax
	jnz .L1

	mov rax,r12
	xor rax,r13
	ret

problem_004:
	xor r8,r8   ; Largest currently known palindrome. Zero is trivially a palindrome.
	mov r9,1000 ; First multiplier + 1

.L1:	dec r9
	mov rax,r9 ; Test to see if the current top triple is too small to possibly return a new maximum palindrome.
	mul rax
	cmp rax,r8
	jna .quit

	mov r10,r9 ; Second multiplier
.L2:	dec r10
	mov rax,r10
	mul r9
	cmp rax,r8
	jna .L1

	mov r11,rax
	call check_palindrome
	test rax,rax
	cmovz r8,r11
	jmp .L2

.quit:	mov rax,r8
	ret
