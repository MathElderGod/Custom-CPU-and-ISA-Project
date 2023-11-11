#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MAX_BIT_LENGTH 16

void promptBinaryString(char *binaryString, int size);
int validBinaryString(char *binaryString);
void clearInputBuffer(void);
int hammingBinaryStringToBinary(char *binaryString);
void calculateParities(unsigned int binaryNumber, char *p0, char *p1, char *p2,
                       char *p4, char *p8);
void detectHammingError(char *binaryString, char p0, char p1, char p2, char p4,
                        char p8);

int main(void) {
    // Variable declarations for parity bits and binary string
    char p0, p1, p2, p4, p8;
    char binaryString[MAX_BIT_LENGTH + 1];
    int arraySize = sizeof(binaryString);
    promptBinaryString(binaryString, arraySize);
    while (strcmp(binaryString, "quit")) {
        if (!validBinaryString(binaryString)) {
            promptBinaryString(binaryString, arraySize);
        } else {
            // Convert hamming string to an 11 bit binary number
            unsigned int binaryNumber =
                hammingBinaryStringToBinary(binaryString);
            // Calculate the parity bits
            calculateParities(binaryNumber, &p0, &p1, &p2, &p4, &p8);
            // compare the parity bits
            detectHammingError(binaryString, p0, p1, p2, p4, p8);
            promptBinaryString(binaryString, arraySize);
        }
    }
    return EXIT_SUCCESS;
}
// Function to prompt the user for a binary string
void promptBinaryString(char *binaryString, int size) {
    // Print prompt message
    printf(
        "Enter a 16-bit hamming binary string to detect potential errors (or "
        "type quit): ");

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
        printf(
            "The hamming binary string is not 16 bits long, please try "
            "again...\n");
        return 0;
    } else {
        // Check each character of the binary string
        for (int i = 0; i < MAX_BIT_LENGTH; i++) {
            // If any character is not '0' or '1', it's not a valid binary
            // string
            if (binaryString[i] != '1' && binaryString[i] != '0') {
                printf(
                    "you did not enter a valid hamming binary string! Please "
                    "try "
                    "again...\n");
                return 0;
            }
        }
        // Return 1 if the binary string is valid
        return 1;
    }
}

// Function to convert binary string to binary number
int hammingBinaryStringToBinary(char *binaryString) {
    unsigned int binaryNumber = 0;
    for (int i = 0; i < MAX_BIT_LENGTH; i++) {
        if (i == 7 || i == 11 || i == 13 || i == 14 || i == 15) {
            continue;
        }
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

void detectHammingError(char *binaryString, char p0, char p1, char p2, char p4,
                        char p8) {
    int parityPositions[5] = {7, 11, 13, 14, 15};
    char parities[5] = {p8, p4, p2, p1, p0};
    int size = sizeof(parityPositions) / sizeof(parityPositions[0]);
    int mismatchedParities = 0;

    int p0IsGood = (binaryString[parityPositions[4]] == parities[4]);

    // if p0 looks good, we have no errors, or a two bit error
    if (p0IsGood) {
        for (int i = 0; i < size - 1; i++) {
            if (binaryString[parityPositions[i]] != parities[i]) {
                mismatchedParities++;
            }
        }
        // if p0 looks good, and we have no mismatched parities, then we have no
        // errors
        if (mismatchedParities == 0) {
            char noneParityString[12] = {
                binaryString[0],  binaryString[1],  binaryString[2],
                binaryString[3],  binaryString[4],  binaryString[5],
                binaryString[6],  binaryString[8],  binaryString[9],
                binaryString[10], binaryString[12], '\0'};
            printf("No Errors Detected: ");
            char resultString[17] = "00000";
            strcat(resultString, noneParityString);
            printf("%s\n", resultString);
            // else we have a two bit error
        } else {
            char noneParityString[12] = {
                binaryString[0],  binaryString[1],  binaryString[2],
                binaryString[3],  binaryString[4],  binaryString[5],
                binaryString[6],  binaryString[8],  binaryString[9],
                binaryString[10], binaryString[12], '\0'};
            printf("Two Bit Error Detected: ");
            char resultString[17] = "10000";
            strcat(resultString, noneParityString);
            printf("%s\n", resultString);
        }
        // p0 looks bad, time to determine if p0, or something else
    } else {
        int p0Calculated = p0 == '1' ? 1 : 0;
        int p1Calculated = p1 == '1' ? 1 : 0;
        int p2Calculated = p2 == '1' ? 1 : 0;
        int p4Calculated = p4 == '1' ? 1 : 0;
        int p8Calculated = p8 == '1' ? 1 : 0;

        int p0Received = binaryString[15] == '1' ? 1 : 0;
        int p1Received = binaryString[14] == '1' ? 1 : 0;
        int p2Received = binaryString[13] == '1' ? 1 : 0;
        int p4Received = binaryString[11] == '1' ? 1 : 0;
        int p8Received = binaryString[7] == '1' ? 1 : 0;

        unsigned int incorrectPosition = 0;
        incorrectPosition =
            (incorrectPosition << 1) | (p8Calculated ^ p8Received);
        incorrectPosition =
            (incorrectPosition << 1) | (p4Calculated ^ p4Received);
        incorrectPosition =
            (incorrectPosition << 1) | (p2Calculated ^ p2Received);
        incorrectPosition = (incorrectPosition) | (p1Calculated ^ p1Received);
        incorrectPosition = 15 - incorrectPosition;
        printf("bit position: %i: \n", incorrectPosition);
        // if all other parities are good, then p0 is bad
        if (incorrectPosition == 0) {
            char noneParityString[12] = {
                binaryString[0],  binaryString[1],  binaryString[2],
                binaryString[3],  binaryString[4],  binaryString[5],
                binaryString[6],  binaryString[8],  binaryString[9],
                binaryString[10], binaryString[12], '\0'};
            printf("One Bit Error Detected: ");
            char resultString[17] = "01000";
            strcat(resultString, noneParityString);
            printf("%s\n", resultString);
            // calculate which bit is bad
        } else {
            // one bit error if non zero
            printf("One Bit Error Detected: ");
            char resultString[17] = "01000";
            binaryString[incorrectPosition] =
                (binaryString[incorrectPosition] == '1') ? '0' : '1';
            char noneParityString[12] = {
                binaryString[0],  binaryString[1],  binaryString[2],
                binaryString[3],  binaryString[4],  binaryString[5],
                binaryString[6],  binaryString[8],  binaryString[9],
                binaryString[10], binaryString[12], '\0'};
            strcat(resultString, noneParityString);
            printf("%s\n", resultString);
        }
    }
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
