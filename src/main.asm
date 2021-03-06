extern parse_ui
extern print_ui
extern print_nl

extern problem_jump_table

section .data
prompt: db "Running problem "
prompt_len: equ $-prompt

section .text

global _start
_start:
	pop rsi
	pop rsi
.L1:
	pop rsi
	test rsi,rsi
	jz .quit

	call parse_ui
	cmp rax,527
	ja .L1
	mov r12,rax

	mov rax,1
	mov rdi,1
	mov rsi,prompt
	mov rdx,prompt_len
	syscall

	mov rax,r12
	call print_ui
	call print_nl

	call [problem_jump_table + r12*8]
	call print_ui
	call print_nl

	jmp .L1

.quit:
	mov rax,60
	mov rdi,0
	syscall
