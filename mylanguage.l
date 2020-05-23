%{
#include<stdlib.h>
#include "mylanguage.tab.h"
void yyerror(char *);
extern int yylval;
%}

%%
[0-9]+ { yylval=atoi(yytext);
		 return INTEGER;
		}

[a-z]   {
           yylval = *yytext - 'a';
           return ID;
        }
		
"("|")"|","|"="|add|display|var|assign|"$start"|"$end"|":"|"sub"|"mul"|"div" {return *yytext;}
[\n] return *yytext;
[\t];
.yyerror ("invalid character");
%%

int yywrap(void){
	return 1;
}