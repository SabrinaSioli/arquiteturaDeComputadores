    org 0x7c00
    bits 16
 
    mov ax, 0
    mov ds, ax
    cli
    ; VGA - 256 cores
    mov al, 0x13
    int 0x10

    ; 320 x 200 = 64000

    mov ax, 0xA000
    mov es, ax

    mov cx, 64000
    mov di, 0

    mov bl, 0
    mov si, 320

    call mudar_paleta

loop:
    mov [es:di], bl
    inc di

    mov dx, 0
    mov ax, di
    div si

    cmp dx, 0
    je mudar
    
    dec cx
    jnz loop
    hlt

mudar:
    add bl, 1
    dec cx
    jnz loop
    hlt


mudar_paleta:
    pushad

	mov al, 0       ; quero mudar a cor 0
	mov dx, 0x03C8  ; mude a cor da paleta
	out dx, al      ; mude a cor 0
	
	mov dx, 0x03C9  ; mude a cor daquela posicao na tabela
    mov cl, 0

loop1:
    cmp cl, 64
    je loop2_init

    ; R
	mov al, cl
	out dx, al
	
    ; G
	mov al, 0
	out dx, al
    
    ; B
	mov al, 0
	out dx, al

    inc cl

    jmp loop1

loop2_init:
    mov cl, 1
    jmp loop2

loop2:
    cmp cl, 64
    je loop3_init

    ; R
	mov al, 0
	out dx, al
	
    ; G
	mov al, cl
	out dx, al
    
    ; B
	mov al, 0
	out dx, al  

    inc cl

    jmp loop2   

loop3_init:
    mov cl, 1
    jmp loop3

loop3:
    cmp cl, 64
    je loop4_init
    ; R
	mov al, 0
	out dx, al
	
    ; G
	mov al, 0
	out dx, al
    
    ; B
	mov al, cl
	out dx, al

    inc cl
    jmp loop3

loop4_init:
    mov cl, 1
    jmp loop4

loop4:
    cmp cl, 64
    je fim_paleta
    ; R
	mov al, cl
	out dx, al
	
    ; G
	mov al, cl
	out dx, al
    
    ; B
	mov al, 0
	out dx, al

    inc cl
    jmp loop4

fim_paleta:
    popad
    ret

times 510 - ($-$$) db 0
dw 0xaa55