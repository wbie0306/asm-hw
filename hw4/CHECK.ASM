; 逐行检查完整的 9×9 表，输出错误位置（从 1 开始）。
.8086
.MODEL SMALL
.STACK 100h
.DATA
table DB 7,2,3,4,5,6,7,8,9
      DB 2,4,7,8,10,12,14,16,18
      DB 3,6,9,12,15,18,21,24,27
      DB 4,8,12,16,7,24,28,32,36
      DB 5,10,15,20,25,30,35,40,45
      DB 6,12,18,24,30,7,42,48,54
      DB 7,14,21,28,35,42,49,56,63
      DB 8,16,24,32,40,48,56,7,72
      DB 9,18,27,36,45,54,63,72,81
header DB 'x y',13,10,'$'
error_text DB ' error',13,10,'$'
done_text DB 'accomplish!',13,10,'$'
.CODE
main PROC
    mov ax, @data
    mov ds, ax
    mov dx, OFFSET header
    mov ah, 09h
    int 21h
    mov si, OFFSET table    ; DS:SI 顺序遍历每个字节
    mov bh, 1               ; BH 保存行号
check_row:
    mov bl, 1               ; BL 保存列号
check_col:
    mov al, bh
    mul bl                  ; 行号乘列号
    cmp al, [si]
    je check_next
    call report_error
check_next:
    inc si
    inc bl
    cmp bl, 9
    jbe check_col
    inc bh
    cmp bh, 9
    jbe check_row
    mov dx, OFFSET done_text
    mov ah, 09h
    int 21h
    mov ax, 4C00h
    int 21h
main ENDP

; 使用主过程的 BH、BL，保留 AX、DX 和行列计数。
report_error PROC NEAR
    push ax
    push dx
    xor ax, ax
    mov al, bh
    call print_u16
    mov dl, ' '
    call put_char
    mov al, bl
    xor ah, ah
    call print_u16
    mov dx, OFFSET error_text
    mov ah, 09h
    int 21h
    pop dx
    pop ax
    ret
report_error ENDP
INCLUDE IO.INC
END main
