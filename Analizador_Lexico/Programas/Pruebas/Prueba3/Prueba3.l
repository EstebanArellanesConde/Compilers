%option noyywrap

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    int position;
    char *identifier;
    int type; /* Inicializado en -1 */
} SymbolTable;

int addSymbol(char *name);
int addNumericLiteral(char *literal);
int addStringLiteral(char *string);
void printTables();
void reportError(const char *msg);

typedef struct {
    int position;
    char *literal;
} LiteralTable;

typedef struct {
    int position;
    char *string;
} StringLiteralTable;

SymbolTable symbols[100];
int symbolCount = 0;
LiteralTable numericLiterals[100];
int numericLiteralCount = 0;
StringLiteralTable stringLiterals[100];
int stringLiteralCount = 0;

/* Función para agregar un símbolo a la tabla */
int addSymbol(char *name) {
    for (int i = 0; i < symbolCount; i++) {
        if (strcmp(symbols[i].identifier, name) == 0) {
            return symbols[i].position;
        }
    }
    symbols[symbolCount].position = symbolCount;
    symbols[symbolCount].identifier = strdup(name);
    symbols[symbolCount].type = -1;
    return symbolCount++;
}

/* Función para agregar un literal numérico a la tabla */
int addNumericLiteral(char *literal) {
    for (int i = 0; i < numericLiteralCount; i++) {
        if (strcmp(numericLiterals[i].literal, literal) == 0) {
            return numericLiterals[i].position;
        }
    }
    numericLiterals[numericLiteralCount].position = numericLiteralCount;
    numericLiterals[numericLiteralCount].literal = strdup(literal);
    return numericLiteralCount++;
}

/* Función para agregar un literal de cadena a la tabla */
int addStringLiteral(char *string) {
    for (int i = 0; i < stringLiteralCount; i++) {
        if (strcmp(stringLiterals[i].string, string) == 0) {
            return stringLiterals[i].position;
        }
    }
    stringLiterals[stringLiteralCount].position = stringLiteralCount;
    stringLiterals[stringLiteralCount].string = strdup(string);
    return stringLiteralCount++;
}

/* Función para imprimir las tablas */
void printTables() {
    printf("\nTabla de Símbolos:\n");
    for (int i = 0; i < symbolCount; i++) {
        printf("Posición: %d, Identificador: %s, Tipo: %d\n", symbols[i].position, symbols[i].identifier, symbols[i].type);
    }

    printf("\nTabla de Literales Numéricos:\n");
    for (int i = 0; i < numericLiteralCount; i++) {
        printf("Posición: %d, Literal: %s\n", numericLiterals[i].position, numericLiterals[i].literal);
    }

    printf("\nTabla de Literales de Cadenas:\n");
    for (int i = 0; i < stringLiteralCount; i++) {
        printf("Posición: %d, Cadena: %s\n", stringLiterals[i].position, stringLiterals[i].string);
    }
}

/* Función para manejar errores léxicos */
void reportError(const char *msg) {
    printf("Error léxico: Token no reconocido: %s\n", msg);
}

%}

/* Expresiones regulares para los tokens */
DIGITO   [0-9]
PALABRA_RESERVADA  (Bool|Cade|Continuar|Devo|Ent|Fals|Flota|Global|Haz|Mientras|Nulo|Para|Parar|Si|Sino|Ver)
SIMBOLOS_ESPECIALES  (<|>|<<|>>|#|#!|\*|\||°)
IDENT     @[A-Za-zÁÉÍÓÚÑáéíóúñ][A-Za-zÁÉÍÓÚÑáéíóúñ0-9]*_
OP_ARITHMETIC  (sum|rest|mult|div|mod|inc|dec|exp|dive)
OP_RELACIONAL  (h|m|e|c|he|me)
OP_ASIGNACION   ("->"|"\\+->"|"-->"|"\\*->"|"/->"|"%->"|">>"|"<<"|"\\^->"|"&->")
ENTERO   [-+]?[1-9]{DIGITO}*{DIGITO}?[p|g]?
REAL     [-+]?{DIGITO}+('{DIGITO}+)?|{DIGITO}+[rR]
CADENA   "--".*?"--"
COMMENT  \[[^\]]*\]
WS       [ \t\n]+

%%

{PALABRA_RESERVADA} {
    /* Palabras reservadas */
    if (strcmp(yytext, "Bool") == 0) {
        printf("(0,0) %s\n", yytext);
    } else if (strcmp(yytext, "Cade") == 0) {
        printf("(0,1) %s\n", yytext);
    } else if (strcmp(yytext, "Continuar") == 0) {
        printf("(0,2) %s\n", yytext);
    } else if (strcmp(yytext, "Devo") == 0) {
        printf("(0,3) %s\n", yytext);
    } else if (strcmp(yytext, "Ent") == 0) {
        printf("(0,4) %s\n", yytext);
    } else if (strcmp(yytext, "Fals") == 0) {
        printf("(0,5) %s\n", yytext);
    } else if (strcmp(yytext, "Flota") == 0) {
        printf("(0,6) %s\n", yytext);
    } else if (strcmp(yytext, "Global") == 0) {
        printf("(0,7) %s\n", yytext);
    } else if (strcmp(yytext, "Haz") == 0) {
        printf("(0,8) %s\n", yytext);
    } else if (strcmp(yytext, "Mientras") == 0) {
        printf("(0,9) %s\n", yytext);
    } else if (strcmp(yytext, "Nulo") == 0) {
        printf("(0,10) %s\n", yytext);
    } else if (strcmp(yytext, "Para") == 0) {
        printf("(0,11) %s\n", yytext);
    } else if (strcmp(yytext, "Parar") == 0) {
        printf("(0,12) %s\n", yytext);
    } else if (strcmp(yytext, "Si") == 0) {
        printf("(0,13) %s\n", yytext);
    } else if (strcmp(yytext, "Sino") == 0) {
        printf("(0,14) %s\n", yytext);
    } else if (strcmp(yytext, "Ver") == 0) {
        printf("(0,15) %s\n", yytext);
    }
}

{SIMBOLOS_ESPECIALES} {
    /* Símbolos especiales */
    if (strcmp(yytext, "<") == 0) {
        printf("(1,0) %s\n", yytext);
    } else if (strcmp(yytext, ">") == 0) {
        printf("(1,1) %s\n", yytext);
    } else if (strcmp(yytext, "<<") == 0) {
        printf("(1,2) %s\n", yytext);
    } else if (strcmp(yytext, ">>") == 0) {
        printf("(1,3) %s\n", yytext);
    } else if (strcmp(yytext, "#") == 0) {
        printf("(1,4) %s\n", yytext);
    } else if (strcmp(yytext, "#!") == 0) {
        printf("(1,5) %s\n", yytext);
    } else if (strcmp(yytext, "*") == 0) {
        printf("(1,6) %s\n", yytext);
    } else if (strcmp(yytext, "|") == 0) {
        printf("(1,7) %s\n", yytext);
    } else if (strcmp(yytext, "°") == 0) {
        printf("(1,8) %s\n", yytext);
    }
}

{OP_ARITHMETIC} {
    /* Operadores aritméticos */
    if (strcmp(yytext, "sum") == 0) {
        printf("(3,0) %s\n", yytext);
    } else if (strcmp(yytext, "rest") == 0) {
        printf("(3,1) %s\n", yytext);
    } else if (strcmp(yytext, "mult") == 0) {
        printf("(3,2) %s\n", yytext);
    } else if (strcmp(yytext, "div") == 0) {
        printf("(3,3) %s\n", yytext);
    } else if (strcmp(yytext, "mod") == 0) {
        printf("(3,4) %s\n", yytext);
    } else if (strcmp(yytext, "inc") == 0) {
        printf("(3,5) %s\n", yytext);
    } else if (strcmp(yytext, "dec") == 0) {
        printf("(3,6) %s\n", yytext);
    } else if (strcmp(yytext, "exp") == 0) {
        printf("(3,7) %s\n", yytext);
    } else if (strcmp(yytext, "dive") == 0) {
        printf("(3,8) %s\n", yytext);
    }
}

{OP_RELACIONAL} {
    /* Operadores relacionales */
    if (strcmp(yytext, "h") == 0) {
        printf("(4,0) %s\n", yytext);
    } else if (strcmp(yytext, "m") == 0) {
        printf("(4,1) %s\n", yytext);
    } else if (strcmp(yytext, "e") == 0) {
        printf("(4,2) %s\n", yytext);
    } else if (strcmp(yytext, "c") == 0) {
        printf("(4,3) %s\n", yytext);
    } else if (strcmp(yytext, "he") == 0) {
        printf("(4,4) %s\n", yytext);
    } else if (strcmp(yytext, "me") == 0) {
        printf("(4,5) %s\n", yytext);
    }
}

{IDENT} {
    int pos = addSymbol(yytext);
    printf("(2,%d) %s\n", pos, yytext);
}

{OP_ASIGNACION} {
    /* Operadores de asignación */
    if (strcmp(yytext, "->") == 0) {
        printf("(5,0) %s\n", yytext);
    } else if (strcmp(yytext, "+->") == 0) {
        printf("(5,1) %s\n", yytext);
    } else if (strcmp(yytext, "-->") == 0) {
        printf("(5,2) %s\n", yytext);
    } else if (strcmp(yytext, "*->") == 0) {
        printf("(5,3) %s\n", yytext);
    } else if (strcmp(yytext, "/->") == 0) {
        printf("(5,4) %s\n", yytext);
    } else if (strcmp(yytext, "%->") == 0) {
        printf("(5,5) %s\n", yytext);
	} else if (strcmp(yytext, ">>") == 0) {
        printf("(5,6) %s\n", yytext);
	} else if (strcmp(yytext, "<<") == 0) {
        printf("(5,7) %s\n", yytext);
    } else if (strcmp(yytext, "^->") == 0) {
        printf("(5,8) %s\n", yytext);
    } else if (strcmp(yytext, "&->") == 0) {
        printf("(5,9) %s\n", yytext);
    }
}

{CADENA} {
    int pos = addStringLiteral(yytext);
    printf("(6,%d) %s\n", pos, yytext);
}

{ENTERO} {
    int pos = addNumericLiteral(yytext);
    printf("(7,%d) %s\n", pos, yytext);
}

{REAL} {
    int pos = addNumericLiteral(yytext);
    printf("(8,%d) %s\n", pos, yytext);
}

{COMMENT} { 
    printf("Comentario ignorado: %s\n", yytext);
}

{WS}  /* Ignorar espacios en blanco */

. {
    /* Manejo de errores para caracteres no reconocidos */
    reportError(yytext);
}
%%

/* Punto de entrada del programa */
int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Se debe proporcionar un archivo de entrada.\n");
        return 1;
    }
    
    FILE *file = fopen(argv[1], "r");
    if (!file) {
        perror("Error al abrir el archivo");
        return 1;
    }

    yyin = file;
    yylex();
    
    /* Imprimir las tablas después del análisis */
    printTables();
    
    fclose(file);
    return 0;
}
