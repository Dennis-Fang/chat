assume cs:code

data segment
	db 1,21,22,32,45,67,86,128,30,23,19,158
data ends

code segment
	_start:
		mov ax,data
		mov ds,ax
		mov bx,0
		mov dx,0
		mov cx,12
		s: 	mov al,[bx]
			cmp al,32
			jb s0
			cmp al,128
			ja s0
			inc dx
		s0:	inc bx
			loop s
code ends
end _start			