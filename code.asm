IDEAL
MODEL small
STACK 100h
DATASEG
arr1 db 1 dup ("shalom leha",10,13,"$")
sortedarr db 20 dup (?)
k db 11
arr equ bp+6
sizeofarr equ bp+4
two db 2
CODESEG
proc merge_sort
	push bp
	mov bp, sp
	push ax ; save ax, bx, cx, si
	push bx
	push cx
	push si
	xor ch, ch
	mov bx, [arr]
	mov ax, [sizeofarr]
	cmp ax, 2
	je last2
	cmp ax, 1
	je finish_sort
	mov si, bx
	div [two]
	mov cl, al
	push bx
	push cx
	call merge_sort
	add bl, al
	push bx
	add cl, ah
	push cx
	call merge_sort ;two sorted arrays 1 in the adress si, size al, 2nd in the adress bx size cx
	xor ah, ah
	mov dx, ax
	add dx, si
	add cx, bx ; cx and dx have final adresses for bx and si
	
	xor di, di
cmploop:
	call compare ; compare elements of two arrays
	inc di
    cmp di, [sizeofarr] ; check to finish
	jge last1
	jmp cmploop
last2: ; TODO finish last2 and last1
	mov al, [bx]
	mov ah, [bx+1]
	cmp al, ah
	jge last2g
	jmp finish_sort
last2g:
	ror ax, 8
	mov [bx], al
	mov [bx+1], ah
	jmp finish_sort
last1:
	call copy_array
finish_sort:
	pop si
	pop cx
	pop bx
	pop ax
	pop bp
	ret 4
endp merge_sort
proc copy_array
	push ax
	push bx
	push di
	xor bx, bx
	mov di, [arr]
copy_loop:
	mov al, [sortedarr+bx]
	mov [di+bx], al
	inc bx 
	cmp bx, [sizeofarr]
	jge copy_exit
	jmp copy_loop
copy_exit:
	pop di
	pop bx
	pop ax
	ret
endp copy_array
proc compare ; compare for merge sort ; add output to auxilary space
	push ax
	mov al, [si]
	mov ah, [bx]
	cmp al, ah
	jge greater
less:
	cmp si, dx
	jge greater ; check for overflow of sub array (dx has final adress for si)
	mov [sortedarr+di], al
	inc si
	jmp compare_finish
greater:
	cmp bx, cx
	jge less ; check for overflow of sub array (cx has final adress for bx)
	mov [sortedarr+di], ah
	inc bx
compare_finish:
	pop ax
	ret
endp compare
start:
	mov ax, @data
	mov ds, ax
	mov ah, 9
	xor al, al
	mov dx, offset arr1
	int 21h
	lea bx, [arr1]
	push bx
	mov al, [k]
	xor ah, ah
	push ax
	call merge_sort
	mov ah, 9
	xor al, al
	mov dx, offset arr1
	int 21h
exit:
	mov ax, 4c00h
	int 21h
END start