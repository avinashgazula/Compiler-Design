temp :	temp.l temp.y
	bison -d temp.y
	flex temp.l
	cc -o $@ temp.tab.c lex.yy.c -ll
