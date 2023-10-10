#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MAX_BIT_LENGTH 11  // Define the maximum length for the binary string
#define NUM_PARITIES 5     // Define the number of parities

// Function declarations
void promptBinaryString(char *binaryString, int size);
int validBinaryString(char *binaryString);
void clearInputBuffer(void);
int binaryStringToBinary(char *binaryString);
void calculateParities(unsigned int binaryNumber, char *p0, char *p1, char *p2,
                       char *p4, char *p8);

// Main function
int main(void) {
    // Variable declarations for parity bits and binary string
    char p0, p1, p2, p4, p8;
    char binaryString[MAX_BIT_LENGTH + 1];
    int arraySize = sizeof(binaryString);

    // Prompting the user for a binary string
    promptBinaryString(binaryString, arraySize);

    // Loop until the user types "quit"
    while (strcmp(binaryString, "quit")) {
        // Validate the binary string
        if (!validBinaryString(binaryString)) {
            // If not valid, prompt again
            promptBinaryString(binaryString, arraySize);
            continue;
        } else {
            // Convert binary string to binary number
            unsigned int binaryNumber = binaryStringToBinary(binaryString);

            // Calculate the parity bits
            calculateParities(binaryNumber, &p0, &p1, &p2, &p4, &p8);

            // Check if parity bits are calculated properly
            if (p0 == '\0' || p1 == '\0' || p2 == '\0' || p4 == '\0' ||
                p8 == '\0') {
                // Error message and exit if parities are not calculated
                printf("ERROR: Parities not Calculated. Please try again.\n");
                return EXIT_FAILURE;
            }

            // Create the Hamming code string with the parity bits
            char hammingString[17];
            for (int i = 0; i < MAX_BIT_LENGTH - 4; i++) {
                hammingString[i] = binaryString[i];
            }
            hammingString[7] = p8;
            hammingString[8] = binaryString[7];
            hammingString[9] = binaryString[8];
            hammingString[10] = binaryString[9];
            hammingString[11] = p4;
            hammingString[12] = binaryString[10];
            hammingString[13] = p2;
            hammingString[14] = p1;
            hammingString[15] = p0;
            hammingString[16] = '\0';
            char *hammingStringPtr = hammingString;

            // Print the Hamming code
            printf("Hamming Binary String: %s\n", hammingStringPtr);

            // Prompt for another binary string
            promptBinaryString(binaryString, arraySize);
        }
    }

    // Exit the program successfully
    return EXIT_SUCCESS;
}

// Function to prompt the user for a binary string
void promptBinaryString(char *binaryString, int size) {
    // Print prompt message
    printf("Enter an 11-bit binary string (or type quit): ");

    // Read the user input
    fgets(binaryString, size, stdin);

    // Clear the input buffer if the binary string is of maximum length, or
    // remove the newline character otherwise
    if (strcspn(binaryString, "\n") == MAX_BIT_LENGTH) {
        clearInputBuffer();  // Clear the buffer only if 11 characters are
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
        printf("The binary string is not 11 bits long, please try again...\n");
        return 0;
    } else {
        // Check each character of the binary string
        for (int i = 0; i < MAX_BIT_LENGTH; i++) {
            // If any character is not '0' or '1', it's not a valid binary
            // string
            if (binaryString[i] != '1' && binaryString[i] != '0') {
                printf(
                    "you did not enter a valid binary string! Please try "
                    "again...\n");
                return 0;
            }
        }
        // Return 1 if the binary string is valid
        return 1;
    }
}

// Function to convert binary string to binary number
int binaryStringToBinary(char *binaryString) {
    unsigned int binaryNumber = 0;
    for (int i = 0; i < MAX_BIT_LENGTH; i++) {
        if (binaryString[i] == '1') {
            binaryNumber = (binaryNumber << 1) | 1;
        } else {
            binaryNumber = (binaryNumber << 1);
        }
    }
    return binaryNumber;
}

// Function to clear the input buffer
void clearInputBuffer() {
    int c;
    while ((c = getchar()) != '\n' && c != EOF)
        ;  // Clear the input buffer
}

// Function to calculate the parity bits
void calculateParities(unsigned int binaryNumber, char *p0, char *p1, char *p2,
                       char *p4, char *p8) {
    int p0I = 0;
    int p1I = 0;
    int p2I = 0;
    int p4I = 0;
    int p8I = 0;
    int positionsP1[] = {11, 9, 7, 5, 4, 2, 1};
    int positionsP2[] = {11, 10, 7, 6, 4, 3, 1};
    int positionsP4[] = {11, 10, 9, 8, 4, 3, 2};
    int positionsP8[] = {11, 10, 9, 8, 7, 6, 5};
    int size = sizeof(positionsP1) / sizeof(positionsP1[0]);
    for (int i = 0; i < size; i++) {
        p1I ^= (binaryNumber >> (positionsP1[i] - 1)) & 1;
        p2I ^= (binaryNumber >> (positionsP2[i] - 1)) & 1;
        p4I ^= (binaryNumber >> (positionsP4[i] - 1)) & 1;
        p8I ^= (binaryNumber >> (positionsP8[i] - 1)) & 1;
    }
    *p1 = (p1I == 1 ? '1' : (p1I == 0 ? '0' : '\0'));
    *p2 = (p2I == 1 ? '1' : (p2I == 0 ? '0' : '\0'));
    *p4 = (p4I == 1 ? '1' : (p4I == 0 ? '0' : '\0'));
    *p8 = (p8I == 1 ? '1' : (p8I == 0 ? '0' : '\0'));
    for (int i = 0; i < MAX_BIT_LENGTH; i++) {
        p0I ^= (binaryNumber >> (i)) & 1;
    }
    p0I ^= p1I ^ p2I ^ p4I ^ p8I;
    *p0 = (p0I == 1 ? '1' : (p0I == 0 ? '0' : '\0'));
}
