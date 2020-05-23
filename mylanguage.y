%{
#include<stdio.h>
int yylex(void);
void yyerror(char *);
extern FILE *yyin;
int sys[26];
%}
%token INTEGER ID

%%

program:start

start: '$start' '\n' statement '$end'

statement: variable assignment expression display
		   
variable: 'var' ID ':' '\n'
		  |'var' ID ',' identifier ':' '\n'
		  ;

identifier: ID ',' identifier
			|ID
			;
		  
assignment: 'assign' '(' ID ',' int ')' ':' '\n' {sys[$3]=$5;}
	  | assignment 'assign' '(' ID ',' int ')' ':' '\n' {sys[$4]=$6;}
	  ;

expression: operation
			| expression operation
			;

operation:ID '=' 'add' '(' ID ',' ID ')' ':' '\n' {sys[$1]=sys[$5]+sys[$7];}
			|ID '=' 'sub' '(' ID ',' ID ')' ':' '\n' {sys[$1]=sys[$5]-sys[$7];}
			|ID '=' 'mul' '(' ID ',' ID ')' ':' '\n' {sys[$1]=sys[$5]*sys[$7];}
			|ID '=' 'div' '(' ID ',' ID ')' ':' '\n' {sys[$1]=sys[$5]/sys[$7];}
			;

display: 'display' '(' ID ')' ':' '\n' {printf("%d\n",sys[$3]);}
		 |'display' '(' print ',' ID ')' ':' '\n' {printf("%d\n",sys[$5]);}
		 ;
		 
print:print ',' ID	{printf("%d\n",sys[$3]);}
	 |ID      		{printf("%d\n",sys[$1]);}
	  
int:INTEGER {$$=$1;}
%%

void yyerror(char *s){
	fprintf(stderr,"%s\n",s);
}

int main(int argc,char **argv){
if(argc >1)
{
	yyin=fopen(argv[1],"r");
}
else{
	printf("Enter file name");
	return 1;
}
yyparse();
return 0;
}