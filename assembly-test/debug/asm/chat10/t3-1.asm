assume cs:code

code segment
start:
         mov ax,6
		 call ax
		 inc ax
		 mov bp,sp
		 add ax,[bp]
code ends

end start		 ;end表示程序结束，后面的标识表示程序的第一条指令开始的位置