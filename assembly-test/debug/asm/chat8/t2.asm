assume cs:code

data segment
 db '1975','1976','1977','1978','1979','1980','1981','1982'
 db '1983','1984','1985','1986','1987','1988','1989','1990'
 db '1991','1992','1993','1994','1995'
 ;年份
 
 dd 16,22,382,1356,2390,8000,16000,24486,50065,97474,140417,197514
 dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
 ;收入
 
 dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
 dw 11542,14430,15257,17800
 ;员工
data ends

table segment
 db 21 dup (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
table ends

code segment
_start:
        mov ax,data
		mov ds,ax
		mov ax,table
		mov es,ax
		mov bx,0
		mov bp,0
		mov si,84
		mov di,168
		mov cx,21
	s:
        mov ax,[bx+0]
        mov es:[bp+0],ax
		mov ax,[bx+2]
		mov es:[bp+2],ax
		mov al,' '
		mov es:[bp+4],al
		;格式存入年份
		
		mov ax,[bx+si+0]
		mov es:[bp+5],ax
		mov ax,[bx+si+2]
		mov es:[bp+7],ax
		mov al,' '
		mov es:[bp+9],al
		;格式存入收入
		
		mov ax,[di+0]
		mov es:[bp+10],ax
		mov al,' '
		mov es:[bp+12],al
		;格式存入员工
		
		mov ax,0[bx+si]
		mov dx,2[bx+si]
		div word ptr 0[di]
		;计算人均收入
		
		mov es:13[bp],ax
		mov al,' '
		mov es:15[bp],al
		;格式存入人均收入
		
		add bx,4
		add di,2
		add bp,16
		loop s
		
		mov ax,4c00h
		int 21h

code ends

end _start 