#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define PATTERN_SIZE 5
#define BINARY_SIZE 256
#define EIGHT 8
#define THIRTY_TWO 32
#define FOUR 4
#define FIVE 5
#define MAX_ITERATIONS 252

int countPattern(char *bitPattern, char *binaryString, int bitCount);
int calcNumBytesInWhichPatternOccurs(char *bitPattern, char *binaryString, int bitCount);
int main(int argc, char **argv){
    char bitPattern[PATTERN_SIZE + 1];
    char binaryString[BINARY_SIZE + 1];
    if(argc != 3){
	printf("This program requires 2 arguements: a 5 bit pattern, and a 256 bit binary string.\n");
    } else {
	int bitPatternSize = strlen(*(argv + 1));
	int binaryStringSize = strlen(*(argv + 2));
	if(bitPatternSize != PATTERN_SIZE || binaryStringSize != BINARY_SIZE){
	    printf("This program requires 2 arguements: a 5 bit pattern, and a 256 bit binary string.\n");
	    return EXIT_FAILURE;
	} else {
	    for(int i = 0; i < bitPatternSize; i++){
	        if(*(*(argv + 1) + i) != '0' && *(*(argv + 1) + i) != '1'){
		    printf("The 5 bit pattern arguement is not a binary string! Please try again!\n");
                    return EXIT_FAILURE;
		} else {
		    bitPattern[i] = *(*(argv + 1) + i);
		}
	    }
	    for(int i = 0; i < binaryStringSize; i++){
		if(*(*(argv + 2) + i) != '0' && *(*(argv + 2) + i) != '1'){
		    printf("The binary string arguement is not a binary string! Please try again!\n");
		    return EXIT_FAILURE;
		} else {
		    binaryString[i] = *(*(argv + 2) + i);
		}
	    }
	}
    }
    int patternCount1 = countPattern(bitPattern, binaryString, EIGHT);
    int numBytes = calcNumBytesInWhichPatternOccurs(bitPattern, binaryString, EIGHT);
    int patternCount2 = countPattern(bitPattern, binaryString, THIRTY_TWO);
    printf("Number of bytes within which the pattern occurs: %d\n", patternCount1);
    printf("Number of bytes that contain the pattern: %d\n", numBytes);
    printf("Total number of times which the pattern occurs overall: %d\n", patternCount2);
    return EXIT_SUCCESS;
}

int countPattern(char *bitPattern, char *binaryString, int bitsToCount){
    int patternCount = 0;
    int numIterations = 0;
    if(bitsToCount == 8){
        while(numIterations < THIRTY_TWO){
            for(int i = numIterations * bitsToCount; i < (numIterations * bitsToCount) + FOUR; i++){
		int currentBit = 0;
	        for(int j = i; j < i + FIVE; j++){
		    if(*(bitPattern + currentBit) != *(binaryString + j)){
			break;
		    } else {
			currentBit++;
		    }
	        }
	        if(currentBit == FIVE){
		    patternCount++;
		}
	    }
	    numIterations++;
	}
        return patternCount;
    } else {
        while(numIterations < MAX_ITERATIONS){
	    int currentBit = 0;
	    for(int i = numIterations; i < numIterations + FIVE; i++){
		if(*(bitPattern + currentBit) != *(binaryString + i)){
                    break;
                } else {
                    currentBit++;
                }
	    }
	    if(currentBit == FIVE){
                patternCount++;
            }
	    numIterations++;
	}
        return patternCount;
    }
}

int calcNumBytesInWhichPatternOccurs(char *bitPattern, char *binaryString, int bitsToCount){
    int numIterations = 0;
    int byteHasPattern = 0;
    int numBytes = 0;
    while(numIterations < THIRTY_TWO){
            for(int i = numIterations * bitsToCount; i < (numIterations * bitsToCount) + FOUR; i++){
                int currentBit = 0;
                for(int j = i; j < i + FIVE; j++){
                    if(*(bitPattern + currentBit) != *(binaryString + j)){
                        break;
                    } else {
                        currentBit++;
                    }
                }
                if(currentBit == FIVE && !byteHasPattern){
		    byteHasPattern = 1;
		    numBytes++;
                }
            }
	    byteHasPattern = 0;
            numIterations++;
        }
    return numBytes;
}
