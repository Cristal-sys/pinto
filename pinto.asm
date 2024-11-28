%include "linux64.inc"

section .data
	message db "Voce foi trolado"
	filename db "pinto.txt",0,0
section .bss
	pos resb 1
	names resb 11
section .text
	global _start

_start:
	mov rdi, filename                  ; Load address of filename into rdi
        mov rsi, names                     ; Load address of names into rsi
        call strcpy   

	mov byte [pos], 0
	
_loop:
	mov byte [names+9], 0
	inc byte [pos]
	mov rax, [pos]
	add byte [names+9], al

	mov rax, SYS_OPEN
	mov rdi, names
	mov rsi, O_CREAT+O_WRONLY
	mov rdx, 0644o
	syscall

	push rax
	mov rdi, rax
	mov rax, SYS_WRITE
	mov rsi, message
	mov rdx, 16
	syscall

	mov rax, SYS_CLOSE
	pop rdi
	syscall
	
	cmp byte [pos], 100
	jl _loop

	exit

; Helper function: strcpy (copy string from rdi to rsi)
strcpy:
        .repeat:
            mov al, byte [rdi]             ; Load byte from source
            mov byte [rsi], al             ; Store byte at destination
            inc rdi                        ; Increment source pointer
            inc rsi                        ; Increment destination pointer
            test al, al                    ; Check if end of string (null byte)
            jnz .repeat                     ; Repeat until null byte is found
            ret

