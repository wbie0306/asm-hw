; 1 到 100 的和为 5050，即 13BAh。
; 8 位无符号数范围为 0～255，无法存放结果。
; 16 位有符号数和无符号数均可存放结果。
; 用 AX 累加，完成后输出。
.8086
.MODEL SMALL
.STACK 100h

.CODE
main PROC
    xor ax, ax
    mov cx, 100
sum_loop:
    add ax, cx              ; 从 100 累加到 1
    loop sum_loop
result_ready:               ; 累加结果：AX = 13BAh（5050）

    call print_u16
    mov ax, 4C00h
    int 21h
main ENDP
INCLUDE PRINT.INC
END main
