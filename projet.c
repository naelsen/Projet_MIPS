#include <stdio.h>
#include <stdlib.h>



#define ANSI_COLOR_RED     "\x1b[31m"
#define ANSI_COLOR_GREEN   "\x1b[32m"
#define ANSI_COLOR_YELLOW  "\x1b[33m"
#define ANSI_COLOR_BLUE    "\x1b[34m"
#define ANSI_COLOR_MAGENTA "\x1b[35m"
#define ANSI_COLOR_CYAN    "\x1b[36m"
#define ANSI_COLOR_RESET   "\x1b[0m"

void affichage(char c,int a, int b){

	printf("_________________________\n");
	for(int i=0; i<10 ;i++){
		for(int j =0; j<8 ; j++){
			if (i==a && j==b){printf(ANSI_COLOR_BLUE " %c ",c);}
			else
				printf(ANSI_COLOR_GREEN " %c ",'.');
		}
		printf(ANSI_COLOR_RESET"|\n");
	}
	printf("_________________________\n");
}

int main()
{

	affichage('o',8,2);
	affichage('x',6,5);
	
}