    org 0x7c00
    bits 16
    mov ax, 0
    mov ds, ax
    cli

    mov ax, perg
    call prints
    mov ax, 0x7e00
    call gets
    call stringi

    push ax
    mov ax, perg2
    call prints
    mov ax,0x7e06
    call gets
    call stringi
    push ax

    mov ax, perg3
    call prints
    mov ax,0x7e0c
    call gets
    call stringi
    push ax
    
    mov dx, 0x3C8
    mov al, 0
    out dx, al
    mov dx, 0x3C9
    pop ax ;azul
    pop bx ;verde
    pop cx ;vermelho
    push ax ;azul
    push bx ;verde
    push cx ;vermelho
    pop ax
    out dx, al
    pop ax
    out dx, al
    pop ax
    out dx, al
    hlt

stringi:
    push si
    push bx
    push dx
    mov si, ax
    mov bx, 10
    mov ax, 0
    .loop:
    lodsb
    or al,al
    jz .ret
    sub al, '0'
    push ax
    mov ax,dx
    mul bx
    mov dx,ax
    pop ax
    add dx,ax
    jmp .loop
    .ret:
    mov ax,dx
    pop dx
    pop bx
    pop si
    ret

gets:
    push ax
    push di
    mov di, ax
    .loop2: mov ah, 0
    int 0x16
    cmp al, 13
    je .ret2
    mov [ds:di], al
    inc di
    mov ah, 0x0e
    int 0x10
    jmp .loop2
    .ret2: mov ah, 0x0e
    int 0x10
    mov al, 10
    int 0x10
    mov [ds:di], byte 0
    pop di
    pop ax
    ret

printi:
    push dx
    push ax 
    push bx
    mov bx, 10
    push 0
    .to_str:
    mov dx, 0
    div bx
    add dx, '0'
    push dx
    or al, al
    jnz .to_str
    .print_str:
    pop ax
    or al, al
    jz .return
    mov ah, 0x0e
    int 0x10
    jmp .print_str
    .return:
    pop bx
    pop ax
    pop dx
    ret

prints: push ax
    push si
    mov si, ax
    mov ah, 0x0e
    .loop1: lodsb
    or al, al
    jz .ret1
    int 0x10
    jmp .loop1
    .ret1: pop si
    pop ax
    ret

perg: db "Digite um numero:", 10, 13, 0
perg2: db "Digite um numero:", 10, 13, 0
perg3: db "Digite um numero:", 10, 13, 0
times 510 - ($-$$) db 0
dw 0xaa55