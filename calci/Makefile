calci:	calci.l calci.y
	bison -d calci.y
	flex calci.l
	cc -o $@ calci.tab.c lex.yy.c -ll
