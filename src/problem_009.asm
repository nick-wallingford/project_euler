global project_009

section .text
project_009:
	; We use Euclid's formula for generating pythagorean triples.
	; a = m^2 - n^2, b = 2mn, c = m^2 + n^2
	; for 1 < n < m, m+n odd.

	; a + b + c = m^2 - n^2 + 2mn + m^2 + n^2 = 2m(m+n)
	; We test for 2km(m+n) = 1000 or km(m+n) = 500
	; for some integer constant k.
	; The k is because Euclid's formula won't find 6^2 + 8^2 = 10^2 or 9^2 + 12^2 = 15^2 etc.

	mov r8,1  ; r8 = m. m is 2 on the first iteration.

.L1:	inc r8
	mov r9,r8 ; r9 = n
	and r9,1
	inc r9    ; This initialization of n ensures m+n is odd.

.L2:	mov rax,r8      ; rax = m
	add rax,r9      ; rax = m + n
	mul r8          ; rax = m(m + n)

	mov rbx,rax
	mov rax,500
	div rbx         ; rax = k, rdx = 500 % m(m+n)

	test rdx,rdx    ; if k is integer, we found a suitable m+n.
	jz .success

	add r9,2
	cmp r9,r8
	jb .L2
	jmp .L1

.success:
	mov rbx,rax ; rbx = k
	mul rbx   ; rax = k^2
	mul rbx   ; rax = k^3
	mul r8    ; rax = mk^3
	mul r9    ; rax = mnk^3
	mov rbx,rax ; rbx = mnk^3

	mov rax,r9  ; rax = n
	mul rax     ; rax = n^2
	shl rbx,1   ; rbx = 2mnk^3
	mul rax     ; rax = n^4
	mov rcx,rax ; rcx = n^4

	mov rax,r8  ; rax = m
	mul rax     ; rax = m^2
	mul rax     ; rax = m^4
	sub rax,rcx ; rax = m^4 - n^4

	mul rbx     ; rax = 2mnk^3(m^4 - n^4) = a*b*c
	ret

	; Note that we never compute a, b, or c.
