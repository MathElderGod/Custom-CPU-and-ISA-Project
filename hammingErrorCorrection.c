#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MAX_BIT_LENGTH 16
void promptBinaryString(char *binaryString, int size);
int validBinaryString(char *binaryString);
void clearInputBuffer(void);
void detectHammingError(char *binaryString);
int main(void){
    // Variable declarations for parity bits and binary string
    char binaryString[MAX_BIT_LENGTH + 1];
    int arraySize = sizeof(binaryString);
    promptBinaryString(binaryString, arraySize);
    while(strcmp(binaryString, "quit")){
        if(!validBinaryString(binaryString)){
            promptBinaryString(binaryString, arraySize);
        } else {
            // compare the parity bits
            detectHammingError(binaryString);
            promptBinaryString(binaryString, arraySize);
        }
    }
    return EXIT_SUCCESS;
}
// Function to prompt the user for a binary string
void promptBinaryString(char *binaryString, int size) {
    // Print prompt message
    printf("Enter a 16-bit hamming binary string to detect potential errors (or type quit): ");
    // Read the user input
    fgets(binaryString, size, stdin);
    // Clear the input buffer if the binary string is of maximum length, or
    // remove the newline character otherwise
    if (strcspn(binaryString, "\n") == MAX_BIT_LENGTH) {
        clearInputBuffer();  // Clear the buffer only if 16 characters are
                             // entered
    } else {
        binaryString[strcspn(binaryString, "\n")] =
            '\0';  // Removing newline character if it's present
    }
}
// Function to validate the binary string
int validBinaryString(char *binaryString) {
    // Check the length of the binary string
    if (strlen(binaryString) != MAX_BIT_LENGTH) {
        // Print error message if the length is not valid
        printf("The hamming binary string is not 16 bits long, please try again...\n");
        return 0;
    } else {
        // Check each character of the binary string
        for (int i = 0; i < MAX_BIT_LENGTH; i++) {
            // If any character is not '0' or '1', it's not a valid binary
            // string
            if (binaryString[i] != '1' && binaryString[i] != '0') {
                printf(
                    "you did not enter a valid hamming binary string! Please try "
                    "again...\n");
                return 0;
            }
        }
        // Return 1 if the binary string is valid
        return 1;
    }
}
// Function to clear the input buffer
void clearInputBuffer() {
    int c;
    while ((c = getchar()) != '\n' && c != EOF);  // Clear the input buffer
}
void detectHammingError(char *binaryString){
    int p0IsBad = 0;
    unsigned int incorrectPosition = 0;
    int p1 = 0;
    int p2 = 0;
    int p4 = 0;
    int p8 = 0;
    // calculate the parity of p0
    for (int i = MAX_BIT_LENGTH - 1; i > -1; i--) {
        int digit = (binaryString[i] == '1') ? 1 : 0;
        p0IsBad ^= digit;
    }
    int positionsP1[] = {14, 12, 10, 8, 6, 4, 2, 0};
    int positionsP2[] = {13, 12, 9, 8, 5, 4, 1, 0}; 
    int positionsP4[] = {11, 10, 9, 8, 3, 2, 1, 0}; // good 
    int positionsP8[] = {7, 6, 5, 4, 3, 2, 1, 0}; // good
    int size = sizeof(positionsP1) / sizeof(positionsP1[0]);
    for (int i = 0; i < size; i++) {
        int digit1 = (binaryString[positionsP1[i]] == '1') ? 1 : 0;
        int digit2 = (binaryString[positionsP2[i]] == '1') ? 1 : 0; 
        int digit4 = (binaryString[positionsP4[i]] == '1') ? 1 : 0; 
        int digit8 = (binaryString[positionsP8[i]] == '1') ? 1 : 0;  
        p1 ^= digit1;
        p2 ^= digit2;
        p4 ^= digit4;
        p8 ^= digit8;
    }
    printf("p8p4p2p1: %d%d%d%d\n", p8, p4, p2, p1);
    incorrectPosition = (p8); // 0000 00X0
    incorrectPosition = (incorrectPosition << 1);
    incorrectPosition |= (p4);
    incorrectPosition = (incorrectPosition << 1);
    incorrectPosition |= (p2);
    incorrectPosition = (incorrectPosition << 1);
    incorrectPosition |= (p1);
    // if p0 looks good, we have no errors, or a two bit error
    if(!p0IsBad){
        // if p0 looks good, and P8P4P2P1 is zero, we have no error
        if(incorrectPosition == 0){
            char noneParityString[12] = {binaryString[0], binaryString[1], binaryString[2], binaryString[3], binaryString[4], binaryString[5], binaryString[6], binaryString[8], binaryString[9], binaryString[10], binaryString[12], '\0'};
            printf("No Errors Detected: ");
            char resultString[17] = "00000";
            strcat(resultString, noneParityString);
            printf("%s\n", resultString);
        // else we have a two bit error
        } else {
            char noneParityString[12] = {binaryString[0], binaryString[1], binaryString[2], binaryString[3], binaryString[4], binaryString[5], binaryString[6], binaryString[8], binaryString[9], binaryString[10], binaryString[12], '\0'};
            printf("Two Bit Error Detected: ");
            char resultString[17] = "10000";
            strcat(resultString, noneParityString);
            printf("%s\n", resultString);    
        }
    // p0 looks bad, time to determine if p0, or something else
    } else {
        // p0 is bad: THEN WE HAVE A 1 BIT ERROR
        printf("One Bit Error Detected: ");
        printf("%s\n", binaryString);
        printf("bit position: %i: \n", incorrectPosition);
        incorrectPosition = 15 - incorrectPosition;
        char resultString[17] = "01000";
        binaryString[incorrectPosition] = (binaryString[incorrectPosition] == '1') ? '0': '1';
        char noneParityString[12] = {binaryString[0], binaryString[1], binaryString[2], binaryString[3], binaryString[4], binaryString[5], binaryString[6], binaryString[8], binaryString[9], binaryString[10], binaryString[12], '\0'};
        strcat(resultString, noneParityString);
        printf("Corrected String: %s\n", resultString);
    }
}
