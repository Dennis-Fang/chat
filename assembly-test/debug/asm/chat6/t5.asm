assume cs:code

a segment
    dw 1,2,3,4,5,6,7,8,9,0ah,0bh,0ch,0dh,0eh,0fh,0ffh
a ends

b segment
    dw 0,0,0,0,0,0,0,0
b ends

code segment

_start: mov ax,a
        mov es,ax
		add ax,1
        mov ss,ax
        mov sp,16

        mov ax,b
        mov ds,ax
        
        mov bx,0
		mov cx,8
	s:	push es:[bx]
	    inc bx
		inc bx
		loop s
		
		mov bx,0
		mov cx,8
	s0: pop ds:[bx]
        inc bx
		inc bx
        loop s0

        mov ax,4c00h
        int 21h
code ends
end _start		
     	  