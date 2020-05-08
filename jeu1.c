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
#define J1_JETON ('X')
//#define J2_JETON (COLOR_RED "O" COLOR_RESET)
#define J2_JETON ('O')
#define VIDE ('.')

#define NB_LIGNE 6
#define NB_COLONE 7


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
	system("clear"); //Pour effacer ce que ya dans le terminale et effacer les
					// Ancien affichage du puissance 4
	printf("+");
	for(int i = 0; i < NB_COLONE; i++)
		printf("---+");
	printf("\n");
	for(int i = NB_LIGNE - 1; i >=0; i--)
		// Pour print le puissance 4 dans le "bon sens"
	{
		printf("|");
		for (int j = 0; j < NB_COLONE; j++)
			//Pas de probleme de sens pour les colonnes
		{	if(jeu[i][j] == J1_JETON){
			printf(COLOR_BLUE " %c " COLOR_RESET,jeu[i][j]);printf("|");
			}else 
			if(jeu[i][j] == J2_JETON){
				printf(COLOR_RED" %c " COLOR_RESET,jeu[i][j]); printf("|");
			}
			else 
				printf(" %c |", jeu[i][j]);
		}
		printf("\n+");
		for(int i = 0; i < NB_COLONE; i++)
			printf("---+");
		printf("\n");
	}
	// Numero des colonnes pour jouer dans la colonne voulu
	printf("|");
	for(int i = 1; i <= NB_COLONE; i++)
		printf(" %d |",i);
	printf("\n");
}

void setPion(int id_player, char **jeu)
{
	int col = 0;
	while(col < 1 || col > NB_COLONE)
	{
		if(id_player == 1)
			printf(COLOR_BLUE "Joueur %d : " COLOR_RESET, id_player);
		else
			printf(COLOR_RED "Joueur %d : " COLOR_RESET, id_player);
		scanf("%d",&col);
		if(col > NB_COLONE || col < 1){
			printf(COLOR_RED "/!\\ "COLOR_RESET"Veuillez choisir une colonne entre 1 et 7\n");
			return;}
	}
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
			printf("%d,%d\n",i,col-1 );
			return;
		}
		else if(jeu[i][col-1] != VIDE && i == NB_LIGNE - 1)
		{
			printf(COLOR_RED "/!\\ " COLOR_RESET "La colonne %d est rempli, veuillez jouez autre part\n",col);
			setPion(id_player,jeu);
		}
	}

}

/*char verifVictoire(jeu)
//envoie : 'X' si le joueur 1 gagne
//			'O' si le jouer 2 gagne
//			'?' si personne ne gagne
{
	int victoireX = 0 victoireO = 0;
	for (int i = 0; i < NB_LIGNE)
		for (int j = 0; i < NB_COLONE; j++)
		{
		}
}*/

/*if (jeu[i][j]==jeu[i][j+1]==jeu[i][j+2]==jeu[i][j+3] 
	&& jeu[i][j] == jeu[i+1][j] == jeu[i+2][j] == jeu[i+3][j]
	&& jeu[i][j]==jeu[i+1][j+1]==jeu[i+2][j+2]==jeu[i+3][j+3]){
	printf("VICTOIRE\n");
}*/
int main()
{
	system("clear");
	char **jeu = setJeu();
	/*jeu[0][0]= 'o'; //case ligne = 4 ,col =5
	//afficherJeu(jeu);
	jeu[0][1]= 'o';
	jeu[0][2]= 'o';
	jeu[0][3]= 'o';*/
	//afficherJeu(jeu);
	/*for (int i = 0 ; i<3 ; i++){
		if ( (jeu[i][i]==jeu[i][i+1]==jeu[i][i+2]==jeu[i][i+3] ) && (jeu[i][i] == jeu[i+1][i] == jeu[i+2][i] == jeu[i+3][i]) && (jeu[i][i]==jeu[i+1][i+1]==jeu[i+2][i+2]==jeu[i+3][i+3])){
	printf("VICTOIRE\n");
		}
	}*/
	while(1)
	{
		afficherJeu(jeu);
		setPion(1,jeu);
		afficherJeu(jeu);
		setPion(2,jeu);
	}
	return 0;
}