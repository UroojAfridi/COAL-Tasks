[org 0x0100]

    jmp start

message:     db   'p200192'  
length:      dw   7
value: dw 0
msg2: dw 2

printchr:	
	loop1:

	mov  dh, [msg2]
	mov  dl, 0
    	mov  bh, 00h
    	mov  ah, 02h
    	inc dh
	mov [msg2], dh
    	int  10h
	
	mov cx, [value]
	mov bx, 000fh
	mov ah, 09h
	mov al, 2Ah
	inc cx
	mov [value], cx
	int 10h
	
	mov cx, [value]
	cmp cx, 5
	jne loop1
	
	mov dl, 7
	mov [msg2], dl
	mov cx, 5
	mov [value], cx
		
	loop2:

	mov  dh, [msg2]
	mov  dl, 0
    	mov  bh, 00h
    	mov  ah, 02h
    	inc dh
	mov [msg2], dh
    	int  10h
	
	mov cx, [value]
	mov bx, 000fh
	mov ah, 09h
	mov al, 2Ah
	dec cx
	mov [value], cx
	int 10h
	
	mov cx, [value]
	cmp cx, 1
	jne loop2

ret

clrscr:     
    push es
    push ax
    push di
    mov  ax, 0xb800
    mov  es, ax
    mov  di, 0

    nextloc:
        mov  word [es:di], 0x0720
        add  di, 2
        cmp  di, 4000
        jne  nextloc

    pop  di 
    pop  ax
    pop  es
    ret

setcursor:
	    
    mov  dx, 0C24h    
    mov  bh, 00h      
    mov  ah, 02h     
    int  10h	
   
ret 


start: 
call clrscr 

mov  ax, 0xb800         ; video memory base
mov  es, ax             ; cannot move to es through IMM
mov  di, 0              ; top left location 



;---for first portion----
nextpos: 
    mov  word [es:di], 0x0020     ;; 00 for balck, 20 for space
  
    add  di, 2
    cmp  di, 1920
    jne  nextpos


call printchr

;---for second portion----

mov  di, 1920             ; top left location 

nextpos2: 
    mov  word [es:di], 0xd720     

    add  di, 2
    cmp  di, 4000
    jne  nextpos2

rollno:	

mov ax, message 
    push ax 
    push word [length]
    call printstr
    call setcursor 


;--------termination code--------
  ; wait for keypress 
    mov ah, 0x1        ; input char is 0x1 in ah 
    int 0x21 
    
    mov  ax, 0x4c00
    int  0x21
;---------------code for rollno starts here-----------
printstr:
    push bp
    mov  bp, sp
    push es
    push ax
    push cx 
    push si 
    push di 

    mov ax, 0xb800 ; video memory base
    mov es, ax 
    mov di, 1992   ;line no            
    mov si, [bp + 6]
    mov cx, [bp + 4]
    mov ah, 0x0f ; only need to do this once 

    nextchar: 
        mov al, [si]
        mov [es:di], ax 
        add di, 2 
        add si, 1   

        ; alternatively 
        loop nextchar 

    pop di 
    pop si 
    pop cx 
    pop ax 
    pop es 
    pop bp 
    ret 4
;---------------code for rollno end here-----------

;-----termination----
    ; wait for keypress 
    ;mov ah, 0x1        ; input char is 0x1 in ah 
    ;int 0x21 
    
    ;mov  ax, 0x4c00
    ;int  0x21

;-----termination----