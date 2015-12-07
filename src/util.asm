global print_ui
global print_nl
global print_i
global gcd
global parse_ui

section .data
nl: db 10
minus: db '-'
section .bss
buffer:resb 18

section .text
parse_ui:
	xor rax,rax
	mov r9,10
.L1:
	mov r8b,[rsi]
	inc rsi
	test r8b,r8b
	jz .quit
	and r8,0Fh
	mul r9
	add rax,r8
	loop .L1

.quit:
	ret

gcd:
	test rdi,rdi
	jz .quit
	xor rdx,rdx
	div rdi
	mov rax,rdi
	mov rdi,rdx
	jmp gcd
.quit:
	ret

print_nl:
	mov rax,1
	mov rdx,1
	mov rdi,1
	mov rsi,nl
	syscall
	ret

print_i:
	cmp rax,0
	jge .L2
	neg rax
	mov r8,rax
	mov rax,1
	mov rsi,minus
	mov rdx,1
	mov rdi,1
	syscall
	mov rax,r8
.L2:
	call print_ui
	ret

print_ui:
	mov rsi,buffer+17
	xor r8,r8
	mov r9,10
.L1:
	xor rdx,rdx
	div r9
	inc r8
	or rdx,030h
	mov [rsi],dl
	dec rsi
	test rax,rax
	jnz .L1

	inc rsi
	mov rax,1
	mov rdi,1
	mov rdx,r8
	syscall
	ret
