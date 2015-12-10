extern is_prime
extern print_ui
extern print_nl

global project_003

section .text
project_003:
	mov r14,1000
	xor r15,r15
.L1:
	mov rsi,r15
	call is_prime
	test rax,rax
	jz .L2
	mov rax,r15
	call print_ui
	call print_nl
.L2:
	inc r15
	cmp r15,r14
	jb .L1

	ret
