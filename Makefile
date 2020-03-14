CC = gcc
CFLAGS = -Wall
C = projet.c
EXE = projet


all : compilation executer

compilation : $(C)
	$(CC) $(CFLAGS) $(C) -o $(EXE)

executer : $(EXE)
	./$(EXE)

clean : $(EXE)
	rm -f $(EXE)
