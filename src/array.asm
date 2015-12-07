global print_array_ui
global insertion_sort

extern print_ui
extern print_nl

section .text
print_array_ui:
	; Receives:
	; rsi, the pointer to the array
	; rdx, the number of elements
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
	ret

insertion_sort:
	; Receives:
	; rsi, the address of the array
	; rdx, the element count.
	mov r8,1
.L1:
	cmp r8,rdx
	je .quit
	mov r9,r8
.L2:
	test r9,r9
	jz .L3
	mov rax,[rsi+r9*8-8]
	mov rcx,[rsi+r9*8]
	cmp rax,rcx
	jbe .L3
	mov [rsi+r9*8-8],rcx
	mov [rsi+r9*8],rax
	dec r9
	jmp .L2
.L3:
	inc r8
	jmp .L1

.quit:	ret
