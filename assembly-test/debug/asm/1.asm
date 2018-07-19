.model small
.stack
.data
    message   db "Hello world!", "$"
.code

_main   proc

    mov   ax,seg message
    mov   ds,ax

    mov   ah,09
    lea   dx,message
    int   21h

    mov   ax,4c00h
    int   21h

_main   endp
end _main