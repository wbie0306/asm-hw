; 按 9 到 1 的行序输出九九乘法表。
.8086
.MODEL SMALL
.STACK 100h
.DATA
title_text DB 'The 9mul9 table:',13,10,'$'
.CODE
main PROC
    mov ax, @data
    mov ds, ax
    mov dx, OFFSET title_text
    mov ah, 09h
    int 21h
    mov bx, 9               ; BL 保存行号
mult_row:
    mov di, 1               ; DI 保存列号
mult_col:
    call print_entry
    inc di
    cmp di, bx
    jbe mult_col
    call newline
    dec bx
    jnz mult_row
    mov ax, 4C00h
    int 21h
main ENDP

; 使用主过程的行列寄存器，返回前恢复所用寄存器。
print_entry PROC NEAR
    push ax
    push dx
    mov ax, bx
    call print_u16
    mov dl, '*'
    call put_char
    mov ax, di
    call print_u16
    mov dl, '='
    call put_char
    mov ax, di
    mul bl                  ; AL 乘行号，结果存入 AX
    call print_u16
    cmp di, bx
    je entry_done
    mov dl, 9               ; 用制表符分隔各项
    call put_char
entry_done:
    pop dx
    pop ax
    ret
print_entry ENDP
INCLUDE IO.INC
END main
