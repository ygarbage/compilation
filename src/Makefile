LEX=lex
YACC=yacc
CFLAGS=-Wall -g
CC=gcc

all:compilateur

compilateur:grammar.c scanner.c static.o hashtable.o  #variable.o
	$(CC) $(CFLAGS) -o $@ $^

static.o:static.c
	$(CC) -c $^ -o static.o

grammar.c:grammar.y
	$(YACC) -d -o $@ --defines=grammar.tab.h $^

hashtable.o:hashtable.c
	$(CC) -c $^ -o hashtable.o

# variable.o:variable.c
# 	$(CC) -c $^ -o variable.o

scanner.c:scanner.l
	$(LEX) -o $@ $^

clean:
	rm -f grammar.c scanner.c grammar.tab.h *~ *.o

mrproper:
	rm -rf compilateur