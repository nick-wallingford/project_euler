global print_array_ui
global insertion_sort_ui

extern print_ui
extern print_nl

section .text
print_array_ui:
	; Receives:
	;  rsi, the pointer to the array
	;  rdx, the number of elements
	push r12
	push r13

	mov r13,rdx
	mov r12,rsi
.L1:
	mov rax,[r12]
	dec r13
	add r12,8
	call print_ui
	call print_nl
	test r13,r13
	jnz .L1

	pop r13
	pop r12
	ret

insertion_sort_ui:
	; Receives:
	;  rsi, the address of the array
	;  rdx, the element count.
	; Uses: rcx rdi r8 r9 r10
	mov r8,1
	cmp rdx,r8
	jbe .quit

.L1:	lea rdi,[rsi+r8*8]
	mov r9,[rdi]
	mov rcx,r8

.L2:	mov r10,[rdi-8]
	cmp r10,r9
	jbe .L3

	mov [rdi],r10
	sub rdi,8
	loop .L2

.L3:	mov [rdi],r9
	inc r8
	cmp r8,rdx
	jb .L1

.quit:	ret
