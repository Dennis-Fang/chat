assume cs:code

data segment
	db 'Welcome to masm!', 0
data ends

code segment

_start:
		mov dh,8
		mov dl,3
		mov cl,2
		mov ax,data
		mov ds,ax
		mov si,0
		call show_str
		
		mov ax,4c00h
		int 21h
	show_str:
				mov ax,0b800h ;显存虚拟内存地址b8000h-bffffh
				mov es,ax
				;计算显存偏移量，行数乘每行列数加最后一行列数
				mov al,79
				mul dh
				mov bx,ax
				mov ah,0
				mov al,dl
				add bx,ax
				call mov_char
				ret
	mov_char:
				push cx ;保存需要不影响原有值的寄存器值				
	change:		mov ch,0
				mov cl,[si]
				jcxz ok
				mov al,[si]
				mov ah,16
				mov word ptr es:[bx],ax
				inc si
				inc bx
				inc bx
				jmp short change
				
	ok:			pop cx
				ret
code ends

end _start				
				