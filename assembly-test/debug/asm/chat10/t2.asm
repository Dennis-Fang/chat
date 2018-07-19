assume cs:code

code segment
_start:
        mov ax,0
		call s
		inc ax
	s:	pop ax
code ends
end _start	