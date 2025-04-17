%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Estructura para la tabla de símbolos */
struct Symbol {
    int position;  /* La posición del símbolo */
    char *name;    /* El nombre del identificador */
    int type;      /* El tipo (inicializado en -1) */
};

/* Estructura para la tabla de literales (Cadenas y Flotantes) */
struct Literal {
    int position;  /* La posición del literal */
    char *data;    /* El dato, que será la cadena (en caso de cadenas o flotantes) */
};

/* Definición de tablas dinámicas */
struct Symbol *symbolTable = NULL;
struct Literal *stringLiterals = NULL;
struct Literal *floatLiterals = NULL;
int symIndex = 0, strIndex = 0, floatIndex = 0;

FILE *tokenFile, *symbolFile, *literalFile, *errorFile;
int writeToFile = 1; /* Cambiar a 0 para imprimir en pantalla (0 para pantalla, 1 para archivo) */

/* Función para agregar un símbolo a la tabla de símbolos */
void addSymbol(char *name) {
    symbolTable = realloc(symbolTable, (symIndex + 1) * sizeof(struct Symbol));
    symbolTable[symIndex].name = strdup(name);
    symbolTable[symIndex].position = symIndex;
    symbolTable[symIndex].type = -1; /* Tipo inicial */
    symIndex++;
}

/* Función para agregar un literal de cadena a la tabla de literales */
void addStringLiteral(char *value) {
    stringLiterals = realloc(stringLiterals, (strIndex + 1) * sizeof(struct Literal));
    stringLiterals[strIndex].data = strdup(value);
    stringLiterals[strIndex].position = strIndex;
    strIndex++;
}

/* Función para agregar un literal flotante a la tabla de literales */
void addFloatLiteral(char *value) {
    floatLiterals = realloc(floatLiterals, (floatIndex + 1) * sizeof(struct Literal));
    floatLiterals[floatIndex].data = strdup(value);
    floatLiterals[floatIndex].position = floatIndex;
    floatIndex++;
}

/* Función para imprimir las tablas (o escribirlas en un archivo) */
void printTables() {
    if (writeToFile) {
        /* Escribir en archivo */
        fprintf(symbolFile, "\nTABLA DE SÍMBOLOS:\n");
        for (int i = 0; i < symIndex; i++) {
            fprintf(symbolFile, "Pos: %d, Nombre: %s, Tipo: %d\n", symbolTable[i].position, symbolTable[i].name, symbolTable[i].type);
        }
        
        fprintf(literalFile, "\nTABLA DE LITERALES (Cadenas):\n");
        for (int i = 0; i < strIndex; i++) {
            fprintf(literalFile, "Pos: %d, Dato: %s\n", stringLiterals[i].position, stringLiterals[i].data);
        }
        
        fprintf(literalFile, "\nTABLA DE LITERALES (Flotantes):\n");
        for (int i = 0; i < floatIndex; i++) {
            fprintf(literalFile, "Pos: %d, Dato: %s\n", floatLiterals[i].position, floatLiterals[i].data);
        }
        
        fprintf(tokenFile, "\nSECUENCIA DE TOKENS:\n");
        for (int i = 0; i < symIndex; i++) {
            fprintf(tokenFile, "TOKEN: 2 %s (Pos: %d)\n", symbolTable[i].name, i);
        }
    } else {
        /* Imprimir en pantalla */
        printf("\nTABLA DE SÍMBOLOS:\n");
        for (int i = 0; i < symIndex; i++) {
            printf("Pos: %d, Nombre: %s, Tipo: %d\n", symbolTable[i].position, symbolTable[i].name, symbolTable[i].type);
        }
        
        printf("\nTABLA DE LITERALES (Cadenas):\n");
        for (int i = 0; i < strIndex; i++) {
            printf("Pos: %d, Dato: %s\n", stringLiterals[i].position, stringLiterals[i].data);
        }
        
        printf("\nTABLA DE LITERALES (Flotantes):\n");
        for (int i = 0; i < floatIndex; i++) {
            printf("Pos: %d, Dato: %s\n", floatLiterals[i].position, floatLiterals[i].data);
        }
        
        printf("\nSECUENCIA DE TOKENS:\n");
        for (int i = 0; i < symIndex; i++) {
            printf("TOKEN: 2 %s (Pos: %d)\n", symbolTable[i].name, i);
        }
    }
}

/* Función para liberar memoria de las tablas */
void freeTables() {
    for (int i = 0; i < symIndex; i++) free(symbolTable[i].name);
    for (int i = 0; i < strIndex; i++) free(stringLiterals[i].data);
    for (int i = 0; i < floatIndex; i++) free(floatLiterals[i].data);
    free(symbolTable);
    free(stringLiterals);
    free(floatLiterals);
}
%}

/* Expresiones regulares para los tokens */
DIGITO   [0-9]
LETRA    [A-Za-zÁÉÍÓÚÑáéíóúñ]
ID       {LETRA}({LETRA}|{DIGITO}|_)*
NUM      [-+]?{DIGITO}+
FLOAT    [-+]?{DIGITO}+\.{DIGITO}+
STRING   "--"[^--]*"--"
COMMENT  \[[^\]]*\]
WS       [ \t\n]+

%%

"Bool"|"Cade"|"Continuar"|"Devo"|"Ent"|"Fals"|"Flota"|"Global"|"Haz"|"Mientras"|"Nulo"|"Para"|"Parar"|"Si"|"Sino"|"Ver" {
    if (writeToFile) {
        fprintf(tokenFile, "TOKEN: 0 %s\n", yytext);
    } else {
        printf("TOKEN: 0 %s\n", yytext);
    }
}


"sum"|"rest"|"mult"|"div"|"mod"|"inc"|"dec"|"exp"|"dive" {
    if (writeToFile) {
        fprintf(tokenFile, "TOKEN: 3 %s\n", yytext);
    } else {
        printf("TOKEN: 3 %s\n", yytext);
    }
}


"h"|"m"|"e"|"c"|"he"|"me" {
    if (writeToFile) {
        fprintf(tokenFile, "TOKEN: 4 %s\n", yytext);
    } else {
        printf("TOKEN: 4 %s\n", yytext);
    }
}


"->"|"+->"|"-->"|"*->"|"/->"|"%->"|">>"|"<<"|"^->"|"&->" {
    if (writeToFile) {
        fprintf(tokenFile, "TOKEN: 5 %s\n", yytext);
    } else {
        printf("TOKEN: 5 %s\n", yytext);
    }
}


"<"|">"|"<<"|">>"|"#"|"#!"|"*"|"|"|"°" {
    if (writeToFile) {
        fprintf(tokenFile, "TOKEN: 1 %s\n", yytext);
    } else {
        printf("TOKEN: 1 %s\n", yytext);
    }
}


{ID} {
    addSymbol(yytext);
    if (writeToFile) {
        fprintf(tokenFile, "TOKEN: 2 %s (Pos: %d)\n", yytext, symIndex-1);
    } else {
        printf("TOKEN: 2 %s (Pos: %d)\n", yytext, symIndex-1);
    }
}


{NUM} {
    if (writeToFile) {
        fprintf(tokenFile, "TOKEN: 7 %s (Valor: %s)\n", yytext, yytext);
    } else {
        printf("TOKEN: 7 %s (Valor: %s)\n", yytext, yytext);
    }
}


{FLOAT} {
    addFloatLiteral(yytext);
    if (writeToFile) {
        fprintf(tokenFile, "TOKEN: 8 %s (Pos: %d)\n", yytext, floatIndex-1);
    } else {
        printf("TOKEN: 8 %s (Pos: %d)\n", yytext, floatIndex-1);
    }
}


{STRING} {
    addStringLiteral(yytext);
    if (writeToFile) {
        fprintf(tokenFile, "TOKEN: 9 %s (Pos: %d)\n", yytext, strIndex-1);
    } else {
        printf("TOKEN: 9 %s (Pos: %d)\n", yytext, strIndex-1);
    }
}


{COMMENT} {
    if (writeToFile) {
        fprintf(tokenFile, "TOKEN: 6 %s\n", yytext);
    } else {
        printf("TOKEN: 6 %s\n", yytext);
    }
}

{WS}  /* Ignorar espacios en blanco */


. {
    if (writeToFile) {
        fprintf(errorFile, "ERROR: %s\n", yytext);
    } else {
        printf("ERROR: %s\n", yytext);
    }
}

%%

int main(int argc, char **argv) {
    /* Definir archivos */
    if (argc > 1) {
        tokenFile = fopen("tokens.txt", "w");
        symbolFile = fopen("symbols.txt", "w");
        literalFile = fopen("literals.txt", "w");
        errorFile = fopen("errors.txt", "w");
    } else {
        tokenFile = stdout;
        symbolFile = stdout;
        literalFile = stdout;
        errorFile = stdout;
    }

    yylex();
    printTables();
    freeTables();
    return 0;
}

int yywrap() {
    return 1;
}
