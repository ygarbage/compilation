LEX=lex
YACC=yacc
CFLAGS=-Wall -g
CC=gcc

all:compilateur

compilateur:grammar.c scanner.c static.o hashtable.o existing_function.o special.o tools.o #variable.o
	$(CC) $(CFLAGS) -o $@ $^

static.o:static.c
	$(CC) -c $^ -o static.o

grammar.c:grammar.y
	$(YACC) -d -o $@ --defines=grammar.tab.h $^

hashtable.o:hashtable.c
	$(CC) -c $^ -o hashtable.o

existing_function.o:existing_function.c
	$(CC) -c $^ -o $@

special.o:special.c
	$(CC) -c $^ -o $@

tools.o:tools.c
	$(CC) -c $^ -o $@

# variable.o:variable.c
# 	$(CC) -c $^ -o variable.o

scanner.c:scanner.l
	$(LEX) -o $@ $^

clean:
	rm -f grammar.c scanner.c grammar.tab.h *~ *.o

mrproper:
	rm -rf compilateur