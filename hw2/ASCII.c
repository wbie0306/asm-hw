#include <stdio.h>

int main(void)
{
    int row, col;
    for (row = 0; row < 2; ++row) { /* 观察比较指令和回跳 */
        for (col = 0; col < 13; ++col) {
            /* 观察整数运算及 putchar 的参数。 */
            putchar('a' + row * 13 + col);
            if (col != 12) putchar(' ');
        }
        putchar('\n'); /* 文本流按平台转换换行符 */
    }
    return 0;
}
