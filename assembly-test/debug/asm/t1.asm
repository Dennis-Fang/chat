assume cs:codesg

codesg segment
_start: mov ax,2000H
    mov ss,ax
    mov sp,0
    add sp,10
    pop ax
    pop bx
    push ax
    push bx
    pop ax
    pop bx

    mov ax,4c00H
    int 21H

codesg ends

end _start