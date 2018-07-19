assume cs:code

data segment
	db 10 dup(0)
data ends	
code segment

_start:
	mov ax,12666
	mov bx,data
	mov ds,bx
	mov si,0
	call dtoc
	
	;mov dh,8
	;mov dl,3
	;mov cl,2
	;call show_str  ;见同目录下的t7.asm
	
	dtoc:
		mov bx,10
		con:
			mov dx,0
			div bx
			mov cx,ax
			add dx,30h
			mov [si],dl
			inc si
			jcxz fin
			jmp con
		fin:
			ret	
code ends

end _start				