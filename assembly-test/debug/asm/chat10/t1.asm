assume cs:code

stack segment
    db 16 dup (0)
stack ends

code segment
_start:
        mov ax,stack
        mov ss,ax
        mov sp,16
        mov ax,1000
        push ax
        mov ax,0
        push ax
        retf
code ends
end _start		