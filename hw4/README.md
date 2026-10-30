# 作业 4：乘法指令和过程调用

## 文件

- `MULT.ASM`：双循环输出九九乘法表，行号从 9 递减至 1，列号从 1 递增至当前行号。
- `CHECK.ASM`：检查题图中的完整 9×9 字节表，报告错误坐标，不修改原表。
- `IO.INC`：十进制输出、字符输出和换行过程。
- `MULT.c`、`CHECK.c`：对应的 C 实现；`CHECK.c` 可分别编译为全局数组和局部数组版本。
- `*_HOST64.txt`：由 C 源码实际编译得到的目标文件反汇编，关键指令附中文注释。
- `*_EXPECTED.txt`：预期输出。

## DOS 汇编运行

在 hw4 目录中使用 MASM 与 LINK：

```text
masm MULT.ASM;
link MULT.OBJ;
MULT
masm CHECK.ASM;
link CHECK.OBJ;
CHECK
```

也可以用兼容 MASM 的 JWasm 直接生成 DOS EXE：

```text
jwasm -mz MULT.ASM
jwasm -mz CHECK.ASM
```

源码使用 8086 指令和 DOS `int 21h`，需在 DOS 或兼容环境中运行。注释采用 UTF-8；老版工具若不识别该编码，可在本地转换注释编码后编译。

### 过程和寄存器

`MULT.ASM` 主过程用 BX 保存行号、DI 保存列号，通过 `call print_entry` 输出一项。`mul bl` 将 AL 中的列号与 BL 中的行号相乘，结果放在 AX；两个因子均不大于 9。输出过程保存并恢复所用的 AX、DX，数字输出过程另行保存 BX、CX；DI 始终不改动。

`CHECK.ASM` 主过程用 BH、BL 保存行列号，DS:SI 指向当前表项。每项占一个字节，访问顺序对应 `table + (行号 - 1) * 9 + (列号 - 1)`。用 `mul bl` 计算正确值后与 `[si]` 比较；不相等时调用 `report_error`。所有过程均以 `ret` 返回，压栈和出栈成对。

五个错误坐标为 `(1,1)`、`(2,3)`、`(4,5)`、`(6,6)`、`(8,8)`，对应正确值为 1、6、20、36、64。坐标从 1 开始，先输出行号，再输出列号。

## C 版本

```sh
cc -std=c11 -Wall -Wextra -O0 MULT.c -o mult
cc -std=c11 -Wall -Wextra -O0 CHECK.c -o check-global
cc -std=c11 -Wall -Wextra -O0 -DLOCAL_TABLE CHECK.c -o check-local
```

两个纠错版本共用检查逻辑和初始化数据，仅改变数组的存储位置。输出均与 `CHECK_EXPECTED.txt` 一致。

### 反汇编对照

随附反汇编使用 Apple Clang、macOS x86-64、`-O0`，采用 AT&T 语法，源操作数在前。它们是目标文件的真实反汇编，保留重定位记录，最终调用地址由链接器填入；不能直接当作 DOS/8086 源码运行。

复现方法（macOS，进入 hw4 目录）：

```sh
cc -arch x86_64 -O0 -c MULT.c -o MULT.o
cc -arch x86_64 -O0 -c CHECK.c -o CHECK_GLOBAL.o
cc -arch x86_64 -O0 -DLOCAL_TABLE -c CHECK.c -o CHECK_LOCAL.o
objdump -dr MULT.o
objdump -dr CHECK_GLOBAL.o
objdump -dr CHECK_LOCAL.o
```

- 乘法表中的 `imull` 对应 `row * col`；`callq` 和 `retq` 对应函数调用与返回。
- 全局版本通过 `_table` 符号引用数据区中的数组，进入 main 时无需复制整张表。
- 局部版本在栈上分配数组空间，通过 `memcpy` 将 81 字节初始化常量复制到局部数组；访问时以栈内地址为基址。当前编译器还加入了栈保护检查。
- 二维数组按行连续存放，`imulq $0x9` 计算行偏移，`movzbl` 读取一个无符号字节。
- `cmpl`、条件跳转和回跳组成双循环；乘积相等时跳过 `report_error`。

## 验证

C 的三种构建均通过严格警告检查，运行输出逐字匹配预期。两个 ASM 程序经 JWasm 组装，均为零错误、零警告；生成的 DOS EXE 经 Unicorn 16 位指令仿真，模拟所用 DOS 输出及退出服务，输出与预期一致，退出状态为零且栈平衡。该检查未在完整 DOS 系统中运行。
