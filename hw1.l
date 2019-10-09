%{
/*
 * scan.l
 *
 * lex input file for pascal scanner
 *
 * extensions: two ways to spell "external" and "->" ok for "^".
 */

#include <stdio.h>

#define	PROGRAM	1
#define	ID	2
#define	VAR	3
#define	ARRAY	4
#define	OF	5
#define	PROCEDURE	6
#define	_BEGIN	7
#define	END	8
#define	NUM	9
#define	INTEGER	10
#define	FUNCTION	11
#define	REAL	12

#define	IF	13
#define	THEN	14
#define	ELSE	15
#define	WHILE	16
#define	DO	17
#define	NOT	18
#define	AND	19

#define	LPAREN	20
#define	RPAREN	21
#define	CONST		22 
#define	ASSIGNMENT	23
#define	CHARACTER_STRING	24  
#define	COLON	25
#define	COMMA	26    
#define	DOT	27    
#define	DOTDOT	28    
#define	EQUAL	29    
#define	GE	30  
#define	GT    31  
#define	LBRAC	32   
#define	LE  	33        
#define	LT    34  
#define	MINUS	35
#define	NOTEQUAL	36 
#define	PLUS  	37   
#define	RBRAC 	38
#define	SEMICOLON	39           
#define	SLASH     40
#define	STAR      41
#define	IDENTIFIER	42 
#define	CROSS_LINE_STRING	43

int line_no=1,nest=0; 

%}
%x COM
A [aA]
B [bB]
C [cC]
D [dD]
E [eE]
F [fF]
G [gG]
H [hH]
I [iI]
J [jJ]
K [kK]
L [lL]
M [mM]
N [nN]
O [oO]
P [pP]
Q [qQ]
R [rR]
S [sS]
T [tT]
U [uU]
V [vV]
W [wW]
X [xX]
Y [yY]
Z [zZ]
NQUOTE [^']

%%

{P}{R}{O}{G}{R}{A}{M}	return(PROGRAM);
{I}{D}	return(ID);
{V}{A}{R}	return(VAR);
{A}{R}{R}{A}{Y}	return(ARRAY);
{O}{F}	return(OF);
{P}{R}{O}{C}{E}{D}{U}{R}{E}	return(PROCEDURE);
{B}{E}{G}{I}{N}	return(_BEGIN);
{E}{N}{D}	return(END);
{N}{U}{M}	return(NUM);
{C}{O}{N}{S}{T}	return(CONST);
{I}{N}{T}{E}{G}{E}{R}	return(INTEGER);
{F}{U}{N}{C}{T}{I}{O}{N}	return(FUNCTION);
{R}{E}{A}{L}	return(REAL);

{I}{F}	return(IF);
{T}{H}{E}{N}	return(THEN);
{E}{L}{S}{E}	return(ELSE);
{W}{H}{I}{L}{E}	return(WHILE);
{D}{O}	return(DO);
{N}{O}{T}	return(NOT);
{A}{N}{D}	return(AND);

[a-zA-Z]([a-zA-Z0-9_])*      return(IDENTIFIER);
[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?   	return(NUM);

":="                         return(ASSIGNMENT);
'({NQUOTE}|'')+'             return(CHARACTER_STRING);

\"(\\.|[^\^\n\"])*\"		 return(CHARACTER_STRING);
\"(\\.|[^\^\n^\"])*\n(\\.|[^\^\n^\"])*\"	return(CROSS_LINE_STRING);
\"(\\.|[^\^\n^\"])*\n		 return(CROSS_LINE_STRING);

":"                          return(COLON);
","                          return(COMMA);
"."                          return(DOT);
".."                         return(DOTDOT);
"="                          return(EQUAL);
"!="                         return(NOTEQUAL);
">="                         return(GE);
">"                          return(GT);
"["                          return(LBRAC);
"<="                         return(LE);
"("                          return(LPAREN);
"<"                          return(LT);
"-"                          return(MINUS);
"+"                          return(PLUS);
"]"                          return(RBRAC);
")"                          return(RPAREN);
";"                          return(SEMICOLON);
"/"                          return(SLASH);
"*"                          return(STAR);

"//"([^\n])*\n   {fprintf(stderr," // comment at line %d\n",line_no);line_no++;}
"/*"             {BEGIN(COM);{fprintf(stderr," /*  comment begin at line %d\n",line_no);}}
<COM>
{
  "/*"           {++nest;}
  "*"+"/"        {if (nest) 
  				    --nest;
                  else 
				   {BEGIN(INITIAL);fprintf(stderr," */  comment end at line %d\n",line_no);}}
  "*"+           ;
  [^/*\n]+       ; 
  [/]            ; 
  \n             line_no++;
}

\"([^"])*\"  	return(CONST);
\"([^"])*   	{fprintf(stderr,"Unterminated string%d :\n",line_no);}
[ \t\f]    		;
\r         		;
.    			{fprintf(stderr,"Lexical analyzer error at line %d : %s\n",line_no,yytext);}
\n    			line_no++;

%%

int main(int argc,char** argv) 
{
  int i,token;
  yyin=fopen("test.txt","r");
  for(i=0;i==1;i++) 
  {
    token=yylex();
    fprintf(stderr,"%3d-th token(type:%d) on line %d : %s\n",i,token,line_no,yytext);
  }
  return(0);
} 

int yywrap(){
  fclose(yyin);
  exit(1);
}

