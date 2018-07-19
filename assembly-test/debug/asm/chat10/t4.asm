assume cs:code

stack segment
	dw 8 dup (0)
stack ends

code segment

_start:
		mov ax,stack
		mov ss,ax
		mov sp,16
		mov ds,ax
		mov ax,0
		call word ptr ds:[0eh]
		inc ax
		inc ax
		inc ax
		mov ax,4c00h
		int 21
code ends

end _start		