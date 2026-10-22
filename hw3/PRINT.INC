; 将 AX 中的无符号数转为十进制输出并换行，支持零。
; 保留 AX、BX、CX、DX；最多压入 5 个数位。
print_u16 PROC NEAR
    push ax
    push bx
    push cx
    push dx
    mov bx, 10
    xor cx, cx
divide_digit:
    xor dx, dx              ; 除法前清零被除数高位
    div bx                  ; AX 存商，DX 存余数（0～9）
    push dx                 ; 先压入低位数字
    inc cx
    or ax, ax
    jnz divide_digit
emit_digit:
    pop dx                  ; 依次弹出，从高位开始输出
    add dl, '0'
    mov ah, 02h
    int 21h
    loop emit_digit
    mov dl, 13
    mov ah, 02h
    int 21h
    mov dl, 10
    int 21h
    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_u16 ENDP
