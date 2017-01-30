#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <signal.h>

static size_t pointer_count = 0;

static void handler(int sig, siginfo_t *si, void *uc);

int main(int argc, char **argv) {
    size_t buffersize;
    if (argc >= 2) {
        buffersize = atoi(argv[0]);
    } else {
        buffersize = 5 * 1024 * 1024;
    }

    // allocate buffer
    size_t **buffer = malloc(buffersize * sizeof(size_t*));
    printf("buffer start: %p\n", buffer);
    printf("buffer   end: %p\n", buffer + buffersize);

    puts("initializing with pointers to next...");
    // fill with pointers-to-next
    for (size_t i=0; i<buffersize; i++) {
        buffer[i] = (size_t*) &buffer[i+1];
    }
    // set last one to point to first
    buffer[buffersize-1] = (size_t*) buffer;

    puts("randomizing buffer...");
    // permute buffer
    for (size_t i=0; i<10*buffersize; i++) {
        size_t idx = rand() % buffersize;

        // start with a -> b -> c -> d
        size_t *a= (size_t*) &buffer[idx];
        size_t *b= (size_t*) *a;
        size_t *c= (size_t*) *b;
        size_t *d= (size_t*) *c;

        // end with a -> c -> b -> d
        *a = (size_t) c;
        *c = (size_t) b;
        *b = (size_t) d;
    }

    // install handler
    struct sigaction sa;
    sa.sa_flags = SA_SIGINFO;
    sa.sa_sigaction = handler;
    if (sigaction(SIGUSR1, &sa, NULL) == -1) {
        perror("sigaction");
    }
    // start timer
    timer_t timerid;
    struct sigevent sev;
    struct itimerspec its;
    sigset_t mask;
    // block signal
    sigemptyset(&mask);
    sigaddset(&mask, SIGUSR1);
    if (sigprocmask(SIG_SETMASK, &mask, NULL) == -1) {
        perror("sigprocmask");
    }
    // create signal handler timer
    sev.sigev_notify = SIGEV_SIGNAL;
    sev.sigev_signo = SIGUSR1;
    if (timer_create(CLOCK_REALTIME, &sev, &timerid) == -1) {
        perror("timer_create");
    }
    // start timer
    its.it_value.tv_sec = 1;
    its.it_value.tv_nsec = 0;
    its.it_interval.tv_sec = its.it_value.tv_sec;
    its.it_interval.tv_nsec = its.it_value.tv_nsec;
    if (timer_settime(timerid, 0, &its, NULL) == -1) {
        perror("timer_settime");
    }
    // start timer
    if (sigprocmask(SIG_UNBLOCK, &mask, NULL) == -1) {
        perror("sigprocmask");
    }


    // follow pointer chain
    puts("starting pointer traversal..");
    size_t *ptr = buffer[0];
    for (;;) {
        ptr = (size_t*) *ptr;
        ptr = (size_t*) *ptr;
        ptr = (size_t*) *ptr;
        ptr = (size_t*) *ptr;
        pointer_count += 4;
    }
    return 0;
}

static void handler(int sig, siginfo_t *si, void *uc) {
    printf("%i memory accesses per second\n", pointer_count);
    pointer_count = 0;
}
