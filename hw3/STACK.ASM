; 用栈中的局部字变量保存累加值。
.8086
.MODEL SMALL
.STACK 100h

.CODE
main PROC
    push bp
    mov bp, sp
    sub sp, 2               ; 在 SS:[BP-2] 预留一个字
    mov WORD PTR [bp-2], 0  ; BP 寻址默认使用栈段
    mov cx, 100
sum_loop:
    add WORD PTR [bp-2], cx
    loop sum_loop
result_ready:               ; 累加结果：SS:[BP-2] = 13BAh
    mov ax, [bp-2]
    mov sp, bp              ; 释放局部变量空间
    pop bp

    call print_u16
    mov ax, 4C00h
    int 21h
main ENDP
INCLUDE PRINT.INC
END main
