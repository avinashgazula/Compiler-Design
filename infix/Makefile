infix : infix.l infix.y
	bison -d infix.y
	flex infix.l
	g++ -o $@ infix.tab.c lex.yy.c -lfl