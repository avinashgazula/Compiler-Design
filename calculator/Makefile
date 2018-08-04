calculator : calculator.l calculator.y
	bison -d calculator.y
	flex calculator.l
	cc -o $@ calculator.tab.c lex.yy.c -lfl