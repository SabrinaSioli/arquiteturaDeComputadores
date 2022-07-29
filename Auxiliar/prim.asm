    org 0x7c00
    bits 16
 
    mov ax, 0
    mov ds, ax

    int 0x13
	
	mov ah, 0x02   ;leia setores
	mov al, 3      ;1 setor deve ser lido
	mov cl, 2      ;a partir do setor 2
	mov ch, 0      ;cilindro 0
	mov dh, 0      ;cabeÃ§ote 0
	mov bx, 0x7e00 ;endereÃ§o de destino
	
	int 0x13

    cli
    ; VGA - 256 cores
    mov al, 0x13
    int 0x10

    ; 320 x 200 = 64000

desenhar:
    mov ax, 0xA000
    mov es, ax

    mov cx, 64000
    mov di, 0

    mov dl, 15
    mov si, 0
    mov bp, 0

loop1:
    mov si, 320
    call get_num  ; ax = numero
    cmp ax, 0
    je final
    push dx
    mul si
    pop dx
    add ax, bp
    mov di, ax
    inc bp
    mov [es:di], dl
    
    jmp loop1

; RETORNA NO AX O NUMERO, O ADDR PRECISA ESTAR EM BX

get_num:
    push di
    push dx
    push cx
    mov di, bx
    mov ax, 0
    mov cx, 10

loop_num:
    mov bl, [di]
    cmp bl, 44
    je fim_num
    cmp bl, 32
    je fim_num
    mul cl
    sub bl, 48
    add al, bl
    inc di
    jmp loop_num

fim_num:
    inc di
    mov bx, di
    pop cx
    pop dx
    pop di
    ret

;; O NUMERO PRECISA ESTAR EM DX
print_n:
        pushad

         mov di, 0x5750
         mov [ds:di], byte 0
         dec di
         mov bx, 10 ; bx = dividor
         mov ax, dx ; ax = dividendo
loop_n:
         mov dx, 0
         cmp ax, 0
         je fim_n
         div bx     ; ax / bx .. o quociente fica em ax, e o resto fica em dx
         add dx, 48
         mov [ds:di], dl
         dec di
         jmp loop_n

fim_n:   
         inc di
         mov si, di
         call prints
         mov si, new_line
         call prints

         popad
         ret

; A MEMORIA PRECISA ESTAR EM SI
prints: push si
        push ax
        push cx
        push bx

        mov ah, 0x0e
loop:	lodsb
        cmp al, 0
        je fims
        int 0x10
        jmp loop

fims:
        pop bx
        pop cx
        pop ax
        pop si
        ret

final:
    hlt

new_line:  db 10, 13, 0
times 510 - ($-$$) db 0
dw 0xaa55