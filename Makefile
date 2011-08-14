calc: y.tab.c lex.yy.c
	gcc lex.yy.c y.tab.c -ll -ly -lm -o calc
#	yacc -d calc.y	
#	lex calc.l	

y.tab.c: calc.y
	yacc -d calc.y	

lex.yy.c: calc.l
	lex calc.l	
