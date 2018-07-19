assume cs:code

code segment

_start:
	mov ax,4240h
	mov dx,000fh
	mov cx,0ah
	call divdw
	
	
	;子程序描述  
	;名称：divdw  
	;功能：进行不会产生溢出的除法运算，被除数dword型，除数word型，结果为dword型  
	;参数：（ax）=被除数低16位、（dx）=被除数高16位、（cx）=除数  
	;返回：（dx）=结果的高16位、（ax）=结果低16位、（cx）=余数  
	;实验提示：  
	;X：被除数  
	;N：除数  
	;H：X高16  
	;L：X低16  
	;int（）：描述性运算符，取商  
	;rem（）：描述性运算符，取余  
	;公式：X/N=int（H/N）*65536+[rem（H/N）*65536+L]/N
	;16位除法 dx保存余数，ax保存商
	divdw:
		push ax
		mov ax,dx
		mov dx,0
		div cx
		mov si,ax
		pop ax
		div cx      ;因为dx保存着H/N的余数，可以做公式后面运算的高16位
		mov cx,dx
		mov dx,si
		
code ends

end _start				
				