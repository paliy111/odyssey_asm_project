IDEAL
MODEL small
STACK 100h
DATASEG
arr1 db 10 dup (?)
sortedarr db 10 dup (?)
k db 10
arr equ bp+6
sizeofarr equ bp+4
two db 2
CODESEG
proc merge_sort
	push bp
	mov bp, sp
	xor ch, ch
	mov bx, [arr]
	mov ax, [sizeofarr]
	cmp ax, 2
	je last2
	cmp ax, 1
	je last1
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
	xor di, di
cmploop:
	mov dl, [bx]
	mov dh, [si]
	cmp dl, dh
	jl smth
	mov [sortedarr+di], dh
	inc bx
	inc di
	cmp di, [sizeofarr]
	jge finish
	jmp cmploop
smth:
	mov [sortedarr+di], dl
	inc bx
	inc di
    cmp di, [sizeofarr]
	jge finish
	jmp cmploop
finish:
	pop bp
	ret 4
last2: ; TODO finish last2 and last1
	pop bp
	ret 4
last1:
	pop bp
	ret 4
endp merge_sort
start:
	mov ax, @data
	mov ds, ax
exit:
	mov ax, 4c00h
	int 21h
END start