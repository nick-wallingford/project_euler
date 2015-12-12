global project_004

section .bss
num_string: resq 1

section .text
check_palindrome:
	mov rdi,num_string
	mov ebx,10

	mov ecx,6
.L1:	xor edx,edx
	div ebx
	mov [rdi],dl
	inc rdi
	loop .L1

	mov al,[num_string+1]
	mov bl,[num_string+4]
	mov ah,[num_string+2]
	mov bh,[num_string+3]
	cmp ax,bx
	jne .false

	mov al,[num_string+5]
	mov bl,[num_string]
	cmp al,bl
	jne .false

	mov al,1
	ret
.false:	xor rax,rax
	ret

project_004:
	xor r8,r8 ; Largest known palindrome
	mov r9d,1000 ; First multiplier + 1

.L1:	dec r9d
	mov eax,r9d ; Test to see if the current top triple is too small to possibly return a new maximum palindrome.
	mul eax
	cmp eax,r8d
	jna .quit

	mov r10d,r9d ; Second multiplier
.L2:	dec r10d
	mov eax,r10d
	mul r9d
	cmp eax,r8d
	jna .L1

	mov r11d,eax
	call check_palindrome
	test al,al
	jz .L2

	mov r8d,r11d
	jmp .L2

.quit:	mov rax,r8
	ret
