
// (c) Copyright 2016 Josh Wright
#include <stdlib.h>
#include <time.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
// PRNG with a small output buffer
/*
clang -O3 fast_rand.c -o fast_rand
gcc -O3 fast_rand.c -o fast_rand
 */

// *Really* minimal PCG32 code / (c) 2014 M.E. O'Neill / pcg-random.org
// Licensed under Apache License 2.0 (NO WARRANTY, etc. see website)
typedef struct {
    uint64_t state;
    uint64_t inc;
} pcg32_random_t;
uint32_t pcg32_random_r(pcg32_random_t* rng) {
    uint64_t oldstate = rng->state;
    // Advance internal state
    rng->state = oldstate * 6364136223846793005ULL + (rng->inc | 1);
    // Calculate output function (XSH RR), uses old state for max ILP
    uint32_t xorshifted = ((oldstate >> 18u) ^ oldstate) >> 27u;
    uint32_t rot = oldstate >> 59u;
    return (xorshifted >> rot) | (xorshifted << ((-rot) & 31));
}

int main(int argc, char const* argv[]) {
    if (isatty(fileno(stdout))) {
        printf("Will not write output to terminal!\n");
        printf("usage: %s > [output file]\n", argv[0]);
        printf("usage: %s | COMMAND\n", argv[0]);
        return 1;
    }
    const size_t buffer_size = 1024 * 10;

    pcg32_random_t rng;
    rng.state = time(0);
    rng.inc   = time(0) * time(0);

    // malloc'd arrays are apparently faster than arrays on the stack
    uint8_t* buf = (uint8_t*)malloc(buffer_size * sizeof(uint8_t));
    if (buf == NULL) {
        perror("could not allocate memory");
    }
    uint32_t* rand_ints = (uint32_t*)buf;
    for (;;) {
        for (size_t i = 0; i < (buffer_size / sizeof(uint32_t)); i++) {
            rand_ints[i] = pcg32_random_r(&rng);
        }
        // linux write() function, 1 means stdout
        write(1, buf, sizeof(uint32_t) * buffer_size);
    }
    return 0;
}
