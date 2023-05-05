#include <stdio.h>
#include <stdlib.h>
#include "../../../runtime/intrinsics/vx_intrinsics.h"
#include "vx_vec_systolic_matmul.h"

//---------------------------------------------------------------
/* matmulint32
 * # matrix multiplication routine of 32-bit integers
 * # currently support only square matrices
 * # void matmulint32(size_t n, const int*x, const int*y, int*z)
 * # { for (size_t row=0; row<n; row++) {
            for (size_t col = 0; col < n; col++) {
                for (size_t k = 0; k < n; k++) {
                    z[row][col] += x[row][k] * y[k][col]
                }
            }
        }
    } */
//---------------------------------------------------------------

int main()
{
    vx_tmc(1);

    int n = 4; //SIZE

    int *a = (int*)malloc(sizeof(int) * n); 
    int *b = (int*)malloc(sizeof(int) * n); 
    int *c = (int*)malloc(sizeof(int) * n); 

    // Initialize values for array members.  
    // for (int i = 0; i < n; ++i) {
    //    a[i] = i * 2 + 0;
    //    b[i] = i * 2 + 1;
    //    c[i] = 0;
    // }
    // Initialize values for array members.  
    for (size_t row = 0; row < n; ++row) {
        for (size_t col = 0; col < n; ++col) {
            a[row][col] = row * 2 + 0;
            b[row][col] = col * 3 + 1;
            c[row][col] = 0;
        }
    }

#if 0
    printf("vvaddint...\na[%d]: ", n);
    for(int i = 0; i < n; ++i) printf("%d ", a[i]);
    printf("\nb[%d]: ", n);
    for(int i = 0; i < n; ++i) printf("%d ", b[i]);
    printf("\nc[%d] = a[%d] + b[%d]: ", n, n, n);
    for(int i = 0; i < n; ++i) printf("%d ", c[i]);
#endif

    vx_systolic_matmulint32(n, a, b, c);

    for (size_t row = 0; row < n; ++row) {
        for (size_t col = 0; col < n; ++col) {
            for (size_t k = 0; k < n; ++k) {
                if (c[row][col] != (a[row][k] * b[k][col])) {
                    printf("\n<matmulint32> FAILED at <row: %d>, <col: %d>! \n", row, col);
                    return 1;
                }
            }
        }
    }
    printf("\nPASSED.......................... <matmulint32> \n");

    free(a); free(b); free(c);

    vx_tmc(0);

    return 0;
}
