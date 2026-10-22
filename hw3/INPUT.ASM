; 输入 1～100 的十进制整数 N，输出 1 到 N 的和。
.8086
.MODEL SMALL
.STACK 100h

.DATA
prompt DB 'N (1-100): $'
bad DB 'Invalid input. Use 1-100.',13,10,'$'
; 缓冲区容量含回车，最多输入 79 个字符。
buffer DB 80,0,80 DUP (0)
.CODE
main PROC
    mov ax, @data
    mov ds, ax
ask_again:
    mov dx, OFFSET prompt
    mov ah, 09h
    int 21h
    mov BYTE PTR buffer+1, 0
    mov dx, OFFSET buffer
    mov ah, 0Ah             ; 缓冲键盘输入，DOS 处理退格
    int 21h
    mov dl, 13
    mov ah, 02h
    int 21h
    mov dl, 10
    int 21h
    xor cx, cx
    mov cl, buffer+1        ; 输入长度，不含回车
    cmp cx, 1
    jb invalid
    cmp cx, 3
    ja invalid              ; 限制长度，避免乘法溢出
    mov si, OFFSET buffer+2
    xor ax, ax              ; 保存解析结果
parse_digit:
    mov bl, [si]
    cmp bl, '0'
    jb invalid
    cmp bl, '9'
    ja invalid
    sub bl, '0'
    xor bh, bh
    mov dx, 10
    mul dx                  ; 原值乘 10，最大为 990
    add ax, bx
    inc si
    loop parse_digit
    cmp ax, 1
    jb invalid
    cmp ax, 100
    ja invalid
    mov cx, ax
    xor ax, ax
sum_loop:
    add ax, cx
    loop sum_loop
    call print_u16
    mov ax, 4C00h
    int 21h
invalid:
    mov dx, OFFSET bad
    mov ah, 09h
    int 21h
    jmp ask_again
main ENDP
INCLUDE PRINT.INC
END main
