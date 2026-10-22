#include <stdio.h>

int main(void)
{
    unsigned int i;
    unsigned int total = 0; /* 16 位无符号整数也足够存放结果 */
    for (i = 1; i <= 100; ++i) {
        total += i; /* 用 -O0 观察读写和加法，优化后可能直接得到结果 */
    }
    printf("%u\n", total); /* 库函数将整数转为十进制输出 */
    return 0;
}
