assume cs:code

code segment
_start:
	;复制0类型中断出来程序
	mov ax,cs
	mov ds,ax
	mov si,offset int0
	mov ax,0
	mov es,ax
	mov di,200h
	mov cx,offset endint0-offset int0
	cld
	movsb
	
	;设置中断向量
	mov ax,0
	mov es,ax
	mov word ptr es:[0*4],200h
	mov word ptr es:[0*4+2],0
	;程序结束
	mov ax,4c00h
	int 21
	;中断处理程序
	int0:
		jmp short startin0
		db 'divide error!'
	startin0:
		mov ax,cs
		mov ds,ax
		mov si,202h
		mov ax,0b800h
		mov es,ax
		mov di,16*120+36*2
		mov cx,13
		s:
			mov al,[si]
			mov es:[di],al
			inc si
			add di,2
			loop s
		
		mov ax,4c00h
		int 21
	endint0:
		nop
code ends
end _start		

 