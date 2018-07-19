assume cs:code,ds:data

data segment
 db 'BaSic'
 db 'iNfOrMatIon'
data ends

code segment
_start:
        mov ax,data
        mov ds,ax
        
		mov bx,0
		mov cx,5
	s:
        mov al,[bx]	
		and al,223
		mov [bx],al
		inc bx
		loop s
	
	    mov cx,11
	s0:
        mov al,[bx]
        or  al,32
        mov [bx],al
        inc bx
		loop s0
	
	    mov ax,4c00h
		int 21h
code ends
end _start		

 