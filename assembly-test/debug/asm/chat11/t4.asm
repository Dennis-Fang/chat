assume cs:code

data segment
	db "Bdginner's All-purpose Symbolic Instruction Code.",0
data ends

code segment
_start:
		mov ax,data
		mov ds,ax
		mov si,0
		call letterc
		
		mov ax,4c00h
		int 21h
	letterc:
		mov al,[si]
		cmp al,61h
		jna s
		cmp al,7ah
		jnb s
		and al,11011111b
		mov [si],al
		inc si
		jmp short letterc
		
		s:
			cmp al,0
			je s1
			inc si
			jmp short letterc
		s1:
			ret
code ends
end _start	