#include <stdio.h>

/* 与题图一致，故意保留五处错误。 */
#define TABLE_DATA { \
    {7,2,3,4,5,6,7,8,9}, \
    {2,4,7,8,10,12,14,16,18}, \
    {3,6,9,12,15,18,21,24,27}, \
    {4,8,12,16,7,24,28,32,36}, \
    {5,10,15,20,25,30,35,40,45}, \
    {6,12,18,24,30,7,42,48,54}, \
    {7,14,21,28,35,42,49,56,63}, \
    {8,16,24,32,40,48,56,7,72}, \
    {9,18,27,36,45,54,63,72,81} }

#ifndef LOCAL_TABLE
/* 全局数组具有静态存储期，数据放在程序的数据区。 */
unsigned char table[9][9] = TABLE_DATA;
#endif

static void report_error(unsigned int row, unsigned int col)
{
    printf("%u %u error\n", row, col);
}

int main(void)
{
#ifdef LOCAL_TABLE
    /* 局部数组具有自动存储期，进入 main 时初始化。 */
    unsigned char table[9][9] = TABLE_DATA;
#endif
    unsigned int row, col;
    puts("x y");
    for (row = 1; row <= 9; ++row) {
        for (col = 1; col <= 9; ++col) {
            if (table[row - 1][col - 1] != row * col)
                report_error(row, col);
        }
    }
    puts("accomplish!");
    return 0;
}
