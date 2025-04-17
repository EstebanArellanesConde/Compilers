%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NUM_RESERVADAS 20
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
    "y", "o", "no", "si", "sino", "para", "mientras", "romper", "continuar",
    "def", "retornar", "clase", "importar", "como", "ninguno", "cierto", "falso", "intentar",
    "excepto", "finalmente"
};

const char *simbolos[] = {
    "<", ">", "<<", ">>", "#", "#!", "*", "|", "°"
};

// Prototipos de funciones
void Agregar_token(int clase, const char *valor);
void Mostrar_Tokens();
%}

%%

@([A-Za-zÁÉÍÓÚáéíóúÑñ0-9]+)_ {
    int pos = CONT_IDE++;
    strcpy(T_IDE[pos].nombre, yytext);
    char buffer[10];
    sprintf(buffer, "%d", pos);
    Agregar_token(2, buffer);
}

[ \t\n]+    ;

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

