org 100h

jmp start

data: db 'Assembly Language - Course, FAST University Peshawar Campus'
msg1end:


data1: db 'I Love Pakistan'
msg2end:

clearscreen:
	mov ah, 06h     ;scroll up function
	xor al, al	;number of lines by which to scroll up
	;mov al, 10
	xor cx, cx	;upper left corner, ch = row, cl=coloumn
	;mov ch, 2
	;mov cl, 6
	mov dx, 184fh	;lower right corner dh=row,  dl=coloumn
	mov bh, 70h	;blackonblack
	int 10h
ret

setmode:
	;mov ax, 003h	; BIOS.setvideomode 80x25 16-colour
	mov al, 03h	; 03h - text mode, 80x25.  16 colors.
	mov ah, 00h	; funtion of ->set mode
	int 10h		; interupt to BIOS Display memory service
ret

setcursor:
	;mov dx, 0C23h	;DH is row (12), DL is coloumn (35)
	mov dh, 13	;row no 12
	mov dl, 35	;coloumn no 35
	mov bh, 0	;DisplayPage
	mov ah, 02h	;BIOS.SetCursorPosition (set cursor)
	int 10h		;interupt to BIOS Display memory service
	mov ah, 00
	int 16h
ret


printchr:
	mov cx, 10	; ReplicationCount
	mov bx, 0004h	; BH is DisplayPage (0)

	; BL is Attribute (BrightWhiteOnGreen)

	mov ah, 09h	;BIOS.WriteCharacterAndAttribute

	; Al is ASCII ("*")

	mov al, 2ah	; 2a == * , Character to be display
	int 10h
ret

; //print a string on screen
printstr:
	mov cx, msg1end - data ;calculate msg size
	;mov bx, 0001h 	; BH is DisplayPage (0), BL is Attribute
	mov al, 1
	mov bh, 0
	mov bl, 07	; color the text and background
	mov dh, 5	; row number 5
	mov dl, 13	;coloumn no 13
	push cs
	pop es
	mov bp, data
	mov ah, 13h	; To print string on screen we use
	int 10h

	; mov ah, 00h	;BIOS.WaitKeyboardKey
	; int 16h	; ->Ax
ret


setBorderColourL:
;//Left side coloumn
	mov ah, 06h	;scroll up function
	xor al, al	;number of lines by which to scroll up
	xor cx, cx	;upper left corner, ch = row, cl=coloumn
	;mov dx, 3501H 	;lower right corner DH=row, DL=coloumn
	mov dh, 24
	mov dl, 01
	mov bh, 05fh	;WhiteonMagenta
	int 10h

ret


setBorderColourR:
;//Right side coloumn
	mov ah, 06h	;scroll up function
	xor al, al	;number of lines by which to scroll up
	;xor cx, cx	;upper left corner, ch = row, cl=coloumn
	mov ch, 0
	mov cl, 78
	;mov dx, 3501H 	;lower right corner DH=row, DL=coloumn
	mov dh, 24
	mov dl, 79
	mov bh, 05fh	;WhiteonMagenta
	int 10h

ret


setBorderColourT:
;//top side row
	mov ah, 06h	;scroll up function
	xor al, al	;number of lines by which to scroll up
	xor cx, cx	;upper left corner, ch = row, cl=coloumn,  (00h)
	;mov ch, 0
	;mov cl, 78
	;mov dx, 3501H 	;lower right corner DH=row, DL=coloumn
	mov dh, 0
	mov dl, 79
	mov bh, 05fh	;WhiteonMagenta
	int 10h

ret


setBorderColourB:
;//Bottom side row
	mov ah, 06h	;scroll up function
	xor al, al	;number of lines by which to scroll up
	;xor cx, cx	;upper left corner, ch = row, cl=coloumn
	mov ch, 24	; 18h in hex
	mov cl, 0
	;mov dx, 3501H 	;lower right corner DH=row, DL=coloumn
	mov dh, 24
	mov dl, 79
	mov bh, 05fh	;WhiteonMagenta
	int 10h

ret


drawRectangle:
	mov ah, 06h	;scrolll down ftn
	xor al, al	;number of lines by which to scroll up
	mov ch, 7	;upper left corner, ch = row
	mov cl, 20 	;upper left corner CL=coloumn
	mov dh, 15	;lower right corner DH=row, DL=coloumn
	mov dl, 60	;lower right corner DH=row, DL=coloumn
	mov bh, 0dfh
	int 10h
	;//print msg in rectangle
	mov cx, msg2end - data1 ;calculate msg size
	; Bh is display page (0) , bl is attribute (BrightWight)
	mov al, 1
	mov bh, 0
	mov bl, 07	;color the text and background
	mov dh, 11	;row no 12
	mov dl, 31	;coloumn no 20
	push cs
	pop es
	mov bp, data1
	mov ah, 13h	; To print string on screen we use
	int 10h	
ret


start:
call clearscreen
call setcursor
call printstr
call setBorderColourL
call setBorderColourR
call setBorderColourT
call setBorderColourB
call drawRectangle
;call printchr

mov ax, 0x4c00
int 0x21