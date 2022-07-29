
    org 0x7c00
    bits 16

    mov ax, 0
	mov ds, ax
    cli

    call stoi
    mov bx, dx
    mov di, 0
    call count_div
    mov dx, di
    call compara
    jmp halt

;-----------------------------------------------
compara : 
    cmp bx , dx
    je sim
    jmp nao
    
sim : 
    mov si, perfeito
    call prints
    jmp halt

nao : 
    mov si, nperfeito
    call prints
    jmp halt
;----------------------------------------------------
count_div:
        ;pushad
        push ax
        push dx
        push cx
        push bx 

        mov bx, 0
        mov bx, dx ; bx é o nosso numero
        mov cx, 1

loop_div:
        mov dx, 0
        mov ax, 0
        mov ax, bx      ; ax = nosso numero
        cmp ax, cx      ; para quando ax = cx
        je fim_div      ; jump equal
        div cx          ; ax = quociente, dx = resto
        cmp dx, 0       ; verifica se cx divide ax
        je print_div    ; printa o divisor cx
        inc cx          ; itera em cx 
        jmp loop_div

print_div:
        mov dx, cx
        add di, dx
        inc cx
        ;call print_n
        jmp loop_div

fim_div:
        mov dx, bx
       ; call print_n
        pop bx
        pop cx
        pop dx
        pop ax
        ret
;----------------------------------------------------


;----------------- funçoes auxiliares -------------------

;--------------------------------------------------------
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

;---------------------------------
halt: hlt

    perfeito : db 10, 13, 130, " Perfeito", 0
    nperfeito : db 10, 13, " nao eh perfeito", 0
    times 510 - ($ - $$) db 0
    dw 0xaa55