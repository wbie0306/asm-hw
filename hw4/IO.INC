; 输出 DL 中的字符，保留 AX。
put_char PROC NEAR
    push ax
    mov ah, 02h
    int 21h
    pop ax
    ret
put_char ENDP

; 输出 AX 中的无符号十进制数，保留通用寄存器。
print_u16 PROC NEAR
    push ax
    push bx
    push cx
    push dx
    mov bx, 10
    xor cx, cx
io_divide:
    xor dx, dx
    div bx
    push dx
    inc cx
    or ax, ax
    jnz io_divide
io_emit:
    pop dx
    add dl, '0'
    call put_char
    loop io_emit
    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_u16 ENDP

; 输出回车和换行，保留 DX。
newline PROC NEAR
    push dx
    mov dl, 13
    call put_char
    mov dl, 10
    call put_char
    pop dx
    ret
newline ENDP
