#define _CRT_SECURE_NO_WARNINGS

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main() {
    FILE* fptr;
    char filename[] = "process_log.txt";
    char tempfilename[] = "temp_process_log.txt";
    char c;
    time_t t;
    struct tm tm_info;
    errno_t err;

    // Open file for appending
    err = fopen_s(&fptr, filename, "a");
    if (err != 0) {
        printf("Cannot open file \n");
        exit(0);
    }

    // Get current time
    time(&t);
    localtime_s(&tm_info, &t);

    // Write timestamp to the file
    fprintf(fptr, "\nList of processes on the system\n");
    fprintf(fptr, "Timestamp: %s", asctime(&tm_info));

    // Run system command to get all processes and save in a temporary file
    system("tasklist > temp_process_log.txt");

    // Append contents of temporary file to the log file
    FILE* tempfptr = fopen(tempfilename, "r");
    if (tempfptr == NULL) {
        printf("Cannot open temporary file \n");
        exit(0);
    }

    while ((c = fgetc(tempfptr)) != EOF) {
        fputc(c, fptr);
    }

    fclose(tempfptr);
    remove(tempfilename);

    // Close file
    fclose(fptr);

    printf("Data appended to %s\n", filename);

    return 0;
}