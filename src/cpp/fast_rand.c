#include <stdlib.h>
#include <time.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <pthread.h>
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

uint32_t pcg32_random_r(pcg32_random_t *rng) {
    uint64_t oldstate = rng->state;
    // Advance internal state
    rng->state = oldstate * 6364136223846793005ULL + (rng->inc | 1);
    // Calculate output function (XSH RR), uses old state for max ILP
    uint32_t xorshifted = (uint32_t) (((oldstate >> 18u) ^ oldstate) >> 27u);
    uint32_t rot = (uint32_t) (oldstate >> 59u);
    return (xorshifted >> rot) | (xorshifted << ((-rot) & 31));
}

void write_random_data() {
    const size_t pagesize = (const size_t) getpagesize();
    const size_t buffer_size = pagesize;

    pcg32_random_t rng = {0};
    rng.state = (uint64_t) time(0);
    rng.inc = (uint64_t) (time(0) * time(0));

    uint8_t *buf = NULL;
    posix_memalign((void **) &buf, pagesize, buffer_size);
    if (buf == NULL) {
        puts("could not allocate memory");
        abort();
    }
    uint32_t *rand_ints = (uint32_t *) buf;

    for (;;) {
        for (size_t i = 0; i < (buffer_size / sizeof(uint32_t)); i++) {
            rand_ints[i] = pcg32_random_r(&rng);
        }
        write(STDOUT_FILENO, buf, sizeof(uint32_t) * buffer_size);
    }
}

int main(int argc, char const *argv[]) {
    if (isatty(fileno(stdout))) {
        printf("Will not write output to terminal!\n");
        printf("usage: %s > [output file]\n", argv[0]);
        printf("usage: %s | COMMAND\n", argv[0]);
        return 1;
    }

    size_t cores = (size_t) sysconf(_SC_NPROCESSORS_ONLN);
    pthread_t thread = {0};
    // magic number is magic. Make sure it's >1 though
    for (size_t i=0; i < (cores/4 | 1); i++) {
        pthread_create(&thread, 0, (void *(*)(void *)) &write_random_data, NULL);
    }
    pthread_join(thread, NULL);
    return 0;
}