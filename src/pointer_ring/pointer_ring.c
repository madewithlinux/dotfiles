#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <signal.h>

/*

gcc -O3 pointer_ring.c -o pointer_ring_c -lrt
gcc -O3 -g3 -ggdb pointer_ring.c -o pointer_ring -lrt

./pointer_ring 4096000 99999999
./pointer_ring 4294967296 99999999

*/

int main(int argc, char **argv) {
    size_t pointer_count = 0;
    size_t buffersize;
    size_t iterations;
    if (argc >= 3) {
        buffersize = atoll(argv[1]);
        iterations = atoll(argv[2]);
    } else {
        /* buffersize = 5 * 1024 * 1024; */
        return 1;
    }

    // allocate buffer
    size_t *buffer = malloc(buffersize * sizeof(size_t));
    printf("buffer start: %p\n", buffer);
    printf("buffer   end: %p\n", buffer + buffersize);

    puts("initializing with pointers to next...");
    // fill with pointers-to-next
    for (size_t i=0; i<buffersize; i++) {
        buffer[i] = i+1;
    }
    // set last one to point to first
    buffer[buffersize-1] = 0;

    puts("randomizing buffer...");
    // permute buffer
    for (size_t i=0; i<10*buffersize; i++) {
        size_t idx1 = rand() % buffersize;
        size_t idx2 = rand() % buffersize;

        // start with:
        // a -> b -> c
        // d -> e -> f
        size_t a = buffer[idx1];
        size_t b = buffer[a];
        size_t c = buffer[b];
        size_t d = buffer[idx2];
        size_t e = buffer[d];
        size_t f = buffer[e];

        // end with:
        // a -> e -> c
        // d -> b -> f
        buffer[a] = e;
        buffer[d] = b;
        buffer[b] = f;
        buffer[e] = c;
    }

    struct timespec start;
    struct timespec end;
    memset(&start, 0, sizeof(struct timespec));
    memset(&end, 0, sizeof(struct timespec));
    clock_gettime(CLOCK_MONOTONIC, &start);


    // follow pointer chain
    puts("starting pointer traversal..");
    size_t idx = buffer[0];
    for (size_t i=0; i<iterations; i++) {
        idx = buffer[idx];
        /* printf("value: %zx\n", idx); */
    }
    // print final value to prevent it from being optimized out entirely
    printf("final value: %zx\n", idx);

    clock_gettime(CLOCK_MONOTONIC, &end);
    double nanoseconds = end.tv_nsec - start.tv_nsec;
    nanoseconds += 1e9 * (1.0*end.tv_sec - 1.0*start.tv_sec);
    printf("nanoseconds: %f\n", nanoseconds);

    return 0;
}

