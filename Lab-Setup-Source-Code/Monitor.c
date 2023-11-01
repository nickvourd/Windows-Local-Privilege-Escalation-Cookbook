#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main() {
    FILE *fptr;
    char filename[] = "process_log.txt";
    char c;
    time_t t;
    struct tm *tm_info;

    // Open file for appending
    fptr = fopen(filename, "a");

    if (fptr == NULL) {
        printf("Cannot open file \n");
        exit(0);
    }

    // Get current time
    time(&t);
    tm_info = localtime(&t);

    // Write timestamp to the file
    fprintf(fptr, "\nList of processes on the system\n");
    fprintf(fptr, "Timestamp: %s", asctime(tm_info));

    // Run system command to get all processes
    fprintf(fptr, "List of processes on the system:\n");
    system("tasklist");
    fprintf("\n");

    // Close file
    fclose(fptr);

    printf("Data appended to %s\n", filename);

    return 0;
}
