%{
/* Program en lex que presenta en base hexadecimal los números
introducidos que están en base diez
*/
#include <stdlib.h>
#include <stdio.h>
int count = 0;
%}

dig [0-9]
num [dig]+

%%
{num}    {int n= atoi(yytext);
						printf("%x", n);
						if (n>9) count ++;}
%%
int main() {
	yylex();
	 fprintf(stderr, "número de reemplazos = %d\n", count);
	 return 0;
}

%{
  
  /* Programa que lee un programa y hace el
     reconocimiento de identificadores, 
     palabras reservadas y enteros de un
     lenguaje x
  */
  
  FILE *archSal;
  
  %}
  dig     [0-9]
  let     [a-z]
  entero  (dig)+
  ident   (let)((let)|(dig))*
  palres  if|else|while|int|char
  
  %%
  {entero}  fprintf(archSal, "%s es un entero\n", yytext);
  {palres}  fprintf(archSal, "%s es un identificador\n", yytext);
  {ident}   fprintf(archSal, "%s es un identificador\n", yytext);
  
  %%
	
}

}
