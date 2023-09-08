#include <stdio.h>
#include <time.h>

/** Prints the current time in milliseconds. */
int main(void) {
	struct timespec current_time;
	clock_gettime(CLOCK_REALTIME, &current_time);
	printf("%ld\n", current_time.tv_sec * 1000 + current_time.tv_nsec / 1000000);
	return 0;
}
