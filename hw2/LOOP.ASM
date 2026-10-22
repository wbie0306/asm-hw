; 每行输出 13 个字母，共两行；内外层循环共用 CX。
.8086
.MODEL SMALL
.STACK 100h
.CODE
main PROC
    mov bl, 'a'             ; 用 BL 保存当前字母
    mov cx, 2               ; 外层循环控制行数
row_start:
    push cx                 ; 保存剩余行数
    mov cx, 13
letter_loop:
    mov dl, bl
    mov ah, 02h
    int 21h
    inc bl
    cmp cx, 1
    je row_end              ; 行末不输出空格
    mov dl, ' '
    mov ah, 02h
    int 21h
row_end:
    loop letter_loop
    mov dl, 13
    mov ah, 02h
    int 21h
    mov dl, 10
    int 21h
    pop cx                  ; 恢复剩余行数
    loop row_start
    mov ax, 4C00h
    int 21h
main ENDP
END main
