assume cs:code,ds:data

data segment
	;字符空间
	db 'welcome to masm!'
	;属性空间
	db 22h,24h,71h
data ends

code segment

_start:
        mov ax,data
		mov ds,ax
		mov ax,0b800h
		mov es,ax
		mov bx,1984
		mov cx,3
		mov di,0
	s:	mov dx,cx
	    mov cx,16
		mov si,0
	s0: mov al,[si]
        mov ah,[di+16]
		mov es:[bx],ax
		inc si
		add bx,2
		loop s0
		
		add bx,3968
		mov cx,dx
		inc di
		loop s
		
		mov ax,4c00h
		int 21h
code ends

end _start		