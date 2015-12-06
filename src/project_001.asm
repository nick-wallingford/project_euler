global project_001

extern print_ui
extern print_nl

section .data
jump_table:
	dq rem_0    ; Is a jump table really the best way to solve this problem?
	dq rem_1    ; I dunno. But I want to use a jump table to implement
	dq rem_2    ; problem selection.
	dq rem_3
	dq rem_4    ; Now I know how to do a jump table.
	dq rem_5
	dq rem_6
	dq rem_7
	dq rem_8
	dq rem_9
	dq rem_10
	dq rem_11
	dq rem_12
	dq rem_13
	dq rem_14

section .text
project_001:
	xor rbx,rbx  ; sum
	mov rcx,15   ; divisor
	xor r8,r8    ; counter
L1:
	xor rdx,rdx
	mov rax,r8
	div rcx
	jmp [jump_table+rdx*8]
rem_0:
rem_3:
rem_5:
rem_6:
rem_9:
rem_10:
rem_12:
	add rbx,r8
rem_1:
rem_2:
rem_4:
rem_7:
rem_8:
rem_11:
rem_13:
rem_14:
	inc r8
	cmp r8,1000
	jb L1

	mov rax,rbx
	call print_ui
	call print_nl
	ret
