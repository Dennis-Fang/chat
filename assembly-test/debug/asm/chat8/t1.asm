assume cs:code,ds:data

data segment
 dd 100001
 dw 100
 dw 0
data ends

code segment
_start:
		mov ax,data
		mov ds,ax
		mov bx,0
		mov ax,ds:0[bx]
		mov dx,ds:[bx+2]
		div word ptr ds:[bx+4]
		mov ds:[6],ax

	    mov ax,4c00h
		int 21h
code ends
end _start		

 