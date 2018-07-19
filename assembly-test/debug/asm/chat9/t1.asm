assume cs:code

data segment
    db 0
;	dw _start
	dw offset _start ;貌似不加offset也是对的 -_-!
data ends

code segment

_start:
        mov ax,data
		mov ds,ax
		mov bx,0
		jmp word ptr [bx+1]
		
code ends

end _start		