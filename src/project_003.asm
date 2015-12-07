global project_003
extern print_array_ui
extern insertion_sort

section .data
	array dq 17,14,27,23654,273

section .text
project_003:
	mov rsi,array
	mov rdx,5
	call insertion_sort

	mov rsi,array
	mov rdx,5
	call print_array_ui

	mov rax,7821378213
	ret
