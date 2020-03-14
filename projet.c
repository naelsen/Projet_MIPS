#include <stdio.h>
#include <stdlib.h>

#define COLOR_RED     "\x1b[31m"
#define COLOR_GREEN   "\x1b[32m"
#define COLOR_YELLOW  "\x1b[33m"
#define COLOR_BLUE    "\x1b[34m"
#define COLOR_MAGENTA "\x1b[35m"
#define COLOR_CYAN    "\x1b[36m"
#define COLOR_RESET   "\x1b[0m"

//#define J1_JETON (COLOR_YELLOW "O" COLOR_RESET)
#define J1_JETON ('O')
//#define J2_JETON (COLOR_RED "O" COLOR_RESET)
#define J2_JETON ('X')
#define VIDE (' ')

#define NB_LIGNE (6)
#define NB_COLONE (7)


char **setJeu()
{
	char **jeu;
	jeu = (char**)malloc(NB_LIGNE*sizeof(*jeu));
	for(int i = 0; i < NB_LIGNE; i++)
		jeu[i] = (char*)malloc(NB_COLONE*sizeof(char));
	for(int i = 0; i < NB_LIGNE; i++)
		for(int j = 0; j < NB_COLONE; j++)
			jeu[i][j] = VIDE;
	return jeu;
}

void afficherJeu(char **jeu)
{
	printf("+---+---+---+---+---+---+---+\n");
	for(int i = NB_LIGNE - 1; i >=0; i--)
		// Pour print le puissance 4 dans le "bon sens"
	{
		printf("|");
		for (int j = 0; j < NB_COLONE; j++)
			//Pas de probleme de sens pour les colonnes
		{
			printf(" %c |",jeu[i][j]);
		}
	printf("\n+---+---+---+---+---+---+---+\n");
	}
	// Numero des colonnes pour jouer dans la colonne voulu
	printf("| 1 | 2 | 3 | 4 | 5 | 6 | 7 |\n");
}

void setPion(int id_player, char **jeu, int col)
{
	if(col <= NB_COLONE && 1 <= col)
	{
		for(int i = 0; i < NB_LIGNE; i++)
		{
			if(jeu[i][col-1] == VIDE && id_player == 1)
			{
				jeu[i][col-1] = J1_JETON;
				return;
			}
			else if(jeu[i][col-1] == VIDE && id_player == 2)
			{
				jeu[i][col-1] = J2_JETON;
				return;
			}
			else if(jeu[i][col-1] != VIDE && i == NB_LIGNE - 1)
				printf("Vous ne pouvez pas jouer ici\n");
		}
	}
	else
		printf("Veuillez rentrez une colonne valide ...\n");
}

int main()
{
	system("clear");
	char **jeu = setJeu();
	setPion(1,jeu,1);
	setPion(2,jeu,1);
	setPion(1,jeu,1);
	setPion(2,jeu,1);
	setPion(1,jeu,1);
	setPion(2,jeu,1);
	setPion(1,jeu,1);

	afficherJeu(jeu);
	return 0;
}