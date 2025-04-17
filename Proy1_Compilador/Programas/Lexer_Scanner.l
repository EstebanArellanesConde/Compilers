%option noyywrap
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NUM_RESERVADAS 21
#define NUM_SIMBOLOS 9

// Estructuras
typedef struct {
    int posicion;
    char nombre[50];
    int tipo;
} IDE;

typedef struct {
    int posicion;
    char valor[100];
} CLit;

typedef struct {
    int clase;
    char valor[100];  
} Token;

// Tablas
IDE T_IDE[200];
CLit T_CL[200];
CLit T_CLF[200];
Token T_TK[100];

// Contadores
int CONT_IDE = 0;
int CONT_CL = 0;
int CONT_CLF = 0;
int CONT_TK = 0;

// CATALOGOS
const char *reservadas[] = {
    "Ent", "Ver", "Fals", "Nulo", "Clase", "Hilo", "Parar", "Continuar",
    "Flota", "Global", "Define", "Devo", "Excep", "Cade", "Bool", "Si", "Sino",
    "Mientras", "Para", "Haz"
};

const char *simbolos[] = {
    "(", ")", "[", "]", "{", "}", ";", ",", ".",
    "<", ">", "<<", ">>", "#", "#!", "*", "|", "°"
};

// Prototipos de funciones
void Agregar_token(int clase, const char *valor);
void Mostrar_Tokens();
extern FILE *yyin;
%}

%%
/* 1. Operadores específicos (Clase 5) */
(->|\+->|-->|\*->|/->|%->|>>->|<<->|\^->|&->) { Agregar_token(5, yytext); }

/* 2. Palabras reservadas (Clase 1) */
(Ent|Ver|Fals|Nulo|Clase|Hilo|Parar|Continuar|Flota|Global|Define|Devo|Excep|Cade|Bool|Si|Sino|Mientras|Para|Haz) { Agregar_token(1, yytext); }

/* 3. Identificadores (Clase 0) */
[A-Za-zÁÉÍÓÚáéíóúÑñ][A-Za-z0-9ÁÉÍÓÚáéíóúÑñ]* { Agregar_token(0, yytext); }

/* 4. Tokens que inician con '@' (Clase 2) */
[@][A-Za-zÁÉÍÓÚáéíóúÑñ0-9]+_ { Agregar_token(2, yytext); }

/* 5. Token específico "a sum b" (Clase 3) */
a[ ]sum[ ]b { Agregar_token(3, yytext); }

/* 6. Operadores relacionales simplificados (Clase 4) */
(he|me|h|m|e|c) { Agregar_token(4, yytext); }

/* 7. Cadenas delimitadas con "--" (Clase 6) */
--[^-]*-- { Agregar_token(6, yytext); }

/* 8. Constantes enteras (Clase 7) */
([+-]?[1-9][0-9]*|@[IVXLCDM]+[pg]?) { Agregar_token(7, yytext); }

/* 9. Números reales (Clase 8) */
([0-9]+'[0-9]+|[0-9]+[rRØø]) { Agregar_token(8, yytext); }

/* 10. Ignorar espacios, tabulaciones y saltos de línea */
[ \t\n]+    ;

/* 11. Cualquier otro carácter se considera error */
. { printf("Error léxico: '%s'\n", yytext); }
%%

void Agregar_token(int clase, const char *valor) {
    if (CONT_TK < 100) {
        T_TK[CONT_TK].clase = clase;
        strcpy(T_TK[CONT_TK].valor, valor);
        CONT_TK++;
    } else {
        printf("Advertencia: Tabla de tokens llena, no se pudo agregar '%s'\n", valor);
    }
}

void Mostrar_Tokens() {
    printf("\nTokens encontrados:\n");
    for (int i = 0; i < CONT_TK; i++) {
        printf("Clase: %d, Valor: %s\n", T_TK[i].clase, T_TK[i].valor);
    }
}

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *archivo = fopen(argv[1], "r");
        if (!archivo) {
            perror("Error al abrir el archivo");
            return EXIT_FAILURE;
        }
        yyin = archivo;
    } else {
        fprintf(stderr, "Uso: %s <archivo fuente>\n", argv[0]);
        return EXIT_FAILURE;
    }

    yylex();
    Mostrar_Tokens();

    if (argc > 1) {
        fclose(yyin);
    }

    return EXIT_SUCCESS;
}

int yywrap(void) {
    return 1;
}

