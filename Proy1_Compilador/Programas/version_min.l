%option noyywrap
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern FILE *yyin;
void Agregar_token(int clase, const char *valor) { /* dummy implementation */ }
%}
%%
"->"    { Agregar_token(5, yytext); }
"+->"   { Agregar_token(5, yytext); }
"-->"   { Agregar_token(5, yytext); }
"*->"   { Agregar_token(5, yytext); }
"/->"   { Agregar_token(5, yytext); }
"%->"   { Agregar_token(5, yytext); }
">>->"  { Agregar_token(5, yytext); }
"<<->"  { Agregar_token(5, yytext); }
"^->"   { Agregar_token(5, yytext); }
"&->"   { Agregar_token(5, yytext); }
(Ent|Ver|Fals|Nulo|Clase|Hilo|Parar|Continuar|Flota|Global|Define|Devo|Excep|Cade|Bool|Si|Sino|Mientras|Para|Haz)
            { Agregar_token(1, yytext); }
[A-Za-zÁÉÍÓÚáéíóúÑñ][A-Za-z0-9ÁÉÍÓÚáéíóúÑñ]*
            { Agregar_token(0, yytext); }
[ \t\n]+    ;
.           { printf("Error léxico: '%s'\n", yytext); }
%%
