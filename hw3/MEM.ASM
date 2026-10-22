; 用数据段中的字变量直接累加。
.8086
.MODEL SMALL
.STACK 100h

.DATA
total DW 0
.CODE
main PROC
    mov ax, @data
    mov ds, ax
    mov cx, 100
sum_loop:
    add total, cx
    loop sum_loop
result_ready:               ; 结果按小端顺序存放：BA 13
    mov ax, total

    call print_u16
    mov ax, 4C00h
    int 21h
main ENDP
INCLUDE PRINT.INC
END main
