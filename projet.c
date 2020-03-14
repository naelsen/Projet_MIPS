#include <stdio.h>
#include <stdlib.h>


#define ANSI_COLOR_RED     "\x1b[31m"
#define ANSI_COLOR_GREEN   "\x1b[32m"
#define ANSI_COLOR_YELLOW  "\x1b[33m"
#define ANSI_COLOR_BLUE    "\x1b[34m"
#define ANSI_COLOR_MAGENTA "\x1b[35m"
#define ANSI_COLOR_CYAN    "\x1b[36m"
#define ANSI_COLOR_RESET   "\x1b[0m"


void affichage(char c, int x, int y)
{
	printf("\n");
	for(int i=1; i<=6 ;i++)
	{
		printf("|");
		for(int j = 1; j<= 7 ; j++)
		{
			if (i == x && j == y)
				printf(ANSI_COLOR_BLUE " %c ",c);
			else
				printf(ANSI_COLOR_GREEN " %c ",'.');
		}
		printf(ANSI_COLOR_RESET"|\n");
	}
	printf("\n");
}

int main()
{
	affichage('o',6,1);
	affichage('o',6,2);
	return 0;
}