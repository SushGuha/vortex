#include <stdio.h>
#include <vx_print.h>
#include <vx_intrinsics.h>

int main()
{
	int inMatA[4] = { 99, 100, 101, 102 };
	int inMatB[4] = { 1, 2, 3, 4 };

	vx_printf("Running Test: \n");
	// for (int i = 0; i < 4; i++) {
	// 	vx_printf("%d\n", inMatA[i]);
	// }

	unsigned addrA = 5;
	unsigned addrB = addrA + 5;

	// vx_printf("Writing!\n");
	vx_matst(addrA, inMatA);
	vx_matst(addrB, inMatB);


	int outMatA[4];
	int outMatB[4];
	vx_matld(outMatA, addrA);
	vx_matld(outMatB, addrB);

	// vx_printf("Reading: \n");
	// for (int i = 0; i < 4; i++) {
	// 	vx_printf("%d\n", outMatA[i]);
	// }

	for (int i = 0; i < 4; i++) {
		if (inMatA[i] != outMatA[i] || inMatB[i] != outMatB[i]) {
			vx_printf("ERROR\n");
			return 0;
		}
		vx_printf("PASSED!\n");
		return 0;
	}

	return 0;
}