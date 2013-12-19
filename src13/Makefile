LEX=lex
YACC=yacc
CFLAGS=-Wall
CC=gcc

all:parse

parse:grammar.c scanner.c static.o
	$(CC) $(CFLAGS) -o $@ $^

static.o:static.c
	$(CC) -c $^ -o static.o

grammar.c:grammar.y
	$(YACC) -d -o $@ --defines=grammar.tab.h $^

scanner.c:scanner.l
	$(LEX) -o $@ $^

clean:
	rm -f grammar.c scanner.c grammar.tab.h *~ parse
