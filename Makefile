CC = gcc
CFLAGS = -Wall
C = puis.c
EXE = puis


all : compilation executer

compilation : $(C)
	$(CC) $(CFLAGS) $(C) -o $(EXE)

executer : $(EXE)
	./$(EXE)

clean : $(EXE)
	rm -f $(EXE)
