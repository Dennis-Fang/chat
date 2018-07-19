assume cs:code,ds:data

data segment
	;格式化后数据空间
    db 96 dup (0)
	;字符空间
	db 'welcome to masm!'
	;属性空间
	db 22h,24h,71h
data ends

code segment

_start:
        mov ax,data
		mov ds,ax
		mov bx,0
		mov cx,3
		mov di,0
	s:	mov dx,cx
	    mov cx,16
		mov si,0
	s0: mov al,96[si] ;或者[si+96]
        mov ah,[di+112]
		mov [bx],ax
		inc si
		add bx,2
		loop s0
		
		mov cx,dx
		inc di
		loop s
		
		mov ax,4c00h
		int 21h
code ends

end _start		