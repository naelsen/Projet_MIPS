CC = gcc
CFLAGS = -Wall
C = projet.c
EXE = projet


all : EXE

compilation : $(C)
	$(gcc) $(CFLAGS) $(C) -o $(EXE)

clean : $(EXE)
	rm -f $(EXE)
