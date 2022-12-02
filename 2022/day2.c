#include <stdio.h>

int outcomes[3][3] = {
//                  Rock    Paper   Scissor
/* Rock */      {   3,      0,      6 },
/* Paper */     {   6,      3,      0 },
/* Scissor */   {   0,      6,      3 }
};

int findMove(char opponent, int outcome) {
    for (int i = 0; i < 3; i++) {
        if (outcomes[i][opponent - 'A'] == outcome) {
            return i;
        }
    }
    return -1;
}

int main() {
    FILE *input = fopen("day2.input", "r");
    int totalPart1 = 0;
    int totalPart2 = 0;
    while (!feof(input)) {
        char opponent, my;
        fscanf(input, "%c %c\n", &opponent, &my);
        
        totalPart1 += my - 'X' + 1 + outcomes[my - 'X'][opponent - 'A'];

        switch (my) {
            case 'X': // Lose
                my = findMove(opponent, 0);
                break;
                
            case 'Y': // Draw
                my = opponent - 'A';
                break;
                
            case 'Z': // Win
                my = findMove(opponent, 6);
                break;
        }

        totalPart2 += my + 1 + outcomes[my][opponent - 'A'];
    }
    
    fclose(input);
    
    printf("Part1: Total score %d\n", totalPart1);
    printf("Part2: Total score %d\n", totalPart2);
}