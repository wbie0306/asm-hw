#include <stdio.h>

/* 独立过程输出一项，参数按值传递。 */
static void print_entry(unsigned int row, unsigned int col)
{
    printf("%u*%u=%u", row, col, row * col);
}

int main(void)
{
    unsigned int row, col;
    puts("The 9mul9 table:");
    for (row = 9; row > 0; --row) {
        for (col = 1; col <= row; ++col) {
            print_entry(row, col);
            if (col < row) putchar('\t');
        }
        putchar('\n');
    }
    return 0;
}
