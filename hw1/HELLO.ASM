; 在 DOS 下编译运行：
;   masm HELLO.ASM;
;   link HELLO.OBJ;
;   HELLO
; 用 debug HELLO.EXE 调试，常用命令：u / t / p / g / q。
; 生成流程：源文件 → 目标文件 → 可执行文件。
.8086
.MODEL SMALL
.STACK 100h
.DATA
greeting DB 'Hello, World!',13,10,'$'
.CODE
main PROC
    mov ax, @data           ; 初始化数据段，DS 初始指向 PSP
    mov ds, ax
    mov dx, OFFSET greeting ; 09h 功能输出 DS:DX 字符串，遇 '$' 结束
    mov ah, 09h
    int 21h
    mov ax, 4C00h           ; 正常退出
    int 21h
main ENDP
END main
