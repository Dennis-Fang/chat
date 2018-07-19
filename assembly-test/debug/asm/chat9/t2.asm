assume cs:code

data segment
    dd 12345678h
data ends

code segment

_start:
        mov ax,data
    s:    mov ds,ax
        mov bx,0
;        mov [bx], offset s
        mov [bx], s ;不加offset也是对的
        mov [bx+2],cs
        jmp dword ptr ds:[0]
code ends
end _start		