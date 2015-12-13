global problem_006

n: equ 100

section .text
problem_006:
	mov rax,(n*(n+1)*(3*n*n-n-2))/12
	ret
