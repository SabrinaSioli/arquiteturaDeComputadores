org 0x7c00
    bits 16

    mov ax, 0
    mov ds, ax
    cli
    
    call stoi
    mov cx, dx
    mov bx, 1
    mov ax, 1
    call fatorial

fatorial : 
    cmp cx, 0
    je caso_especial
    mul bx
    inc bx
    dec cx
    cmp cx, 0
    je achei_fatorial
    call fatorial

caso_especial : 
    mov dx , 1
    call print_n
    mov si, label_fatorial
    call prints
    jmp fimp 

achei_fatorial : 
    mov dx, ax
    call print_n
    mov si, label_fatorial
    call prints
    jmp fimp











;----------------- funçoes auxiliares -------------------
; joga o resultado em dx
stoi:   push ax
        push bx
        push cx

        mov dx, 0
        mov bx, 0

label:
        mov ah, 0 ; call pro interruptor do teclado
        int 0x16
        mov ah, 0x0e
        cmp al, 13
        je fim
        mov bl, al
        sub bx, 48
        imul dx, 10
        add dx, bx
        int 0x10
        jmp label

fim:    
        mov ah, 0x0e
        mov al, 13
        int 0x10
        mov al, 10
        int 0x10
        pop cx
        pop bx
        pop ax
        ret
;-------------------------------------------------------

;; O NUMERO PRECISA ESTAR EM DX
print_n:
         push di
         push dx
         push bx
         push cx
         push ax
         push si

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
         mov ah, 0x0e
         mov al, 13
         int 0x10
         mov al, 10
         int 0x10
         inc di
         mov si, di
         call prints

         pop si
         pop ax
         pop cx
         pop bx
         pop dx
         pop di
         ret
    
;-----------------------------------------------------
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

fimp: hlt

    label_fatorial : db 32, 130, " o fatorial do numero digitado", 0
    times 510 - ($ - $$) db 0
    dw 0xaa55