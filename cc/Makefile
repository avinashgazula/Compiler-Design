compiler:	compiler.l compiler.y
	bison -d compiler.y
	flex compiler.l
	g++ -o $@ compiler.tab.c lex.yy.c -lfl
