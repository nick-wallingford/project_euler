global project_002
section .text
project_002:
	mov rax,2 ; sum
	mov rbx,2 ; rbx = F(n-6). Seed with F(2)
	mov rcx,8 ; rcx = F(n-3). Seed with F(5)
L1:                         ; Every third Fibonacci number is even. All other Fibonnaci numbers are odd.
	lea rdx,[rbx+4*rcx] ; F(n) = 4*F(n-3) + F(n-6)
	mov rbx,rcx
	mov rcx,rdx

	add rax,rbx ; update sum.

	cmp rdx,4000000
	jbe L1

	ret
