#include <stdio.h>

int outcomes[3][3] = {
//                  Rock    Paper   Scissor
/* Rock */      {   3,      0,      6 },
/* Paper */     {   6,      3,      0 },
/* Scissor */   {   0,      6,      3 }
};

int main() {
    FILE *input = fopen("day2.input", "r");
    int total = 0;
    while (!feof(input)) {
        char opponent, my;
        fscanf(input, "%c %c\n", &opponent, &my);
        
        total += my - 'X' + 1 + outcomes[my - 'X'][opponent - 'A'];
    }
    fclose(input);
    
    printf("Total score %d\n", total);
}