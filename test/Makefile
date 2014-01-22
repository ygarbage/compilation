CXX=gcc
CXXFLAGS=-Wall -g 

test: htable_test.o hashtable.o
	$(CXX) $(CXXFLAGS) $^ -o $@

htable_test.o: htable_test.c hashtable.h

hashtable.o:  hashtable.h  hashtable.c 

clean:
	rm test  hashtable.o htable_test.o