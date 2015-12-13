global problem_007

n: equ 10001
len: equ 1000
section .bss
primes: resq len

section .text
prime_sieve:
	cld
	mov rax,0ffffffffffffffffh
	mov rdi,primes
	mov rcx,len
	rep stosq

	mov r15,len*64

	xor r8,r8
	xor r9,r9
	mov r10,1
.L1:	add r9,4
	add r10,2
	add r8,r9

	cmp r8,r15
	jae .quit

	mov r11,r8
.L2:	mov rax,r11
	mov rbx,r11

	shr rax,6
	and rbx,03fh
	btr [primes+8*rax],rbx

	add r11,r10
	cmp r11,r15
	jb .L2
	jmp .L1

.quit:	ret

problem_007:
	call prime_sieve

	mov rsi,primes
	cld
	xor rbx,rbx
	xor r8,r8

.L1:	lodsq
	xor rcx,rcx

.L2:	inc r8
	bt rax,rcx
	jnc .skip

	inc rbx
	cmp rbx,n
	je .done

.skip:	inc rcx
	test rcx,64
	jz .L2
	jmp .L1

.done:	lea rax,[2*r8-1]
	ret
