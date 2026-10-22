; 用比较和条件跳转实现相同输出。
.8086
.MODEL SMALL
.STACK 100h
.CODE
main PROC
    mov bl, 'a'
    xor bh, bh              ; 本行已输出的字母数
next_letter:
    mov dl, bl
    mov ah, 02h
    int 21h
    inc bl
    inc bh
    cmp bh, 13
    je newline
    mov dl, ' '
    int 21h
    jmp next_letter
newline:
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    xor bh, bh
    cmp bl, 'z'+1
    jb next_letter
    mov ax, 4C00h
    int 21h
main ENDP
END main
