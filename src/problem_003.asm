extern factor
extern print_ui
extern print_nl

global problem_003

section .data
numbers: dq 13195, 600851475143

section .text
problem_003:
	mov r15,2
.L1:	dec r15
	mov rsi,[numbers + 8*r15]
	call factor

	mov r14,rax
	mov r13,rsi

	test r14,r14
	jz .bad

.L2:	dec r14
	mov rax,[r13 + 8*r14]
	call print_ui
	call print_nl

	test r14,r14
	jnz .L2

	call print_nl

	test r15,r15
	jnz .L1

	xor rax,rax
	ret

.bad:
	mov rax,1234567
	ret
