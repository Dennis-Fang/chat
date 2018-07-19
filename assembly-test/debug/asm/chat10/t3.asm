assume cs:code

code segment
_start:
         mov ax,0
		 call far ptr s
		 inc ax
	s:   pop ax
		 add ax,ax
		 pop bx
		 add ax,bx
code ends

end _start		 