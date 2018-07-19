assume cs:code

code segment

_start:
        mov ax,2000h
		mov ds,ax
		mov bx,0
	s:
        mov cl,[bx]
        mov ch,0
        inc cx ;loop指令是先cx的值减1，再判断cx是否为0，不为0执行loop，为0执行下一条指令，所以cx要先加1
        inc bx
        loop s
    ok:
	    dec bx
        mov dx,bx
        mov ax,4c00h
        int 21h
code ends

end _start		