%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern void yyerror(const char *s);
extern char *yytext;
extern int yylineno;
extern FILE *yyin;

// Estructuras para tablas de símbolos (deben coincidir con lexer.l)
typedef struct {
    int position;
    char *identifier;
    int type;
} SymbolTable;

typedef struct {
    int position;
    char *literal;
} LiteralTable;

typedef struct {
    int position;
    char *string;
} StringLiteralTable;

// Para comunicación con Flex
extern SymbolTable symbols[];
extern LiteralTable numericLiterals[];
extern StringLiteralTable stringLiterals[];
extern int symbolCount, numericLiteralCount, stringLiteralCount;
extern char atom_sequence[];
extern int atom_pos;

void printTables();
void add_atom(int atom);
%}

%union {
    char atom;
    int num;
}

/* Tokens atómicos */
%token <atom> ATOM_BOOL /* b */
%token <atom> ATOM_CADE /* c */
%token <atom> ATOM_ENT  /* n */
%token <atom> ATOM_FLOTA /* f */
%token <atom> ATOM_ID   /* a */
%token <atom> ATOM_ASIG /* = */
%token <atom> ATOM_OPASIG /* #, ñ, $, V, ?, :, ", ^, & */
%token <atom> ATOM_PUNTO_COMA /* ; */
%token <atom> ATOM_COMA /* , */
%token <atom> ATOM_PAR_IZQ /* ( */
%token <atom> ATOM_PAR_DER /* ) */
%token <atom> ATOM_COR_IZQ /* [ */
%token <atom> ATOM_COR_DER /* ] */
%token <atom> ATOM_LLAVE_IZQ /* { */
%token <atom> ATOM_LLAVE_DER /* } */
%token <atom> ATOM_OPREL /* >, <, i, !, x, y */
%token <atom> ATOM_GLOBAL /* g */
%token <atom> ATOM_HAZ /* h */
%token <atom> ATOM_MIENTRAS /* w */
%token <atom> ATOM_SI /* i */
%token <atom> ATOM_SINO /* l */
%token <atom> ATOM_PARA /* o */
%token <atom> ATOM_DEV /* d */
%token <atom> ATOM_CONTINUAR /* t */
%token <atom> ATOM_PARAR /* p */
%token <atom> ATOM_CADENA /* s */
%token <atom> ATOM_FALS /* q */
%token <atom> ATOM_VER /* m */
%token <atom> ATOM_NULO /* u */
%token <atom> ATOM_ENTERO /* e */
%token <atom> ATOM_REAL /* r */
%token <atom> ATOM_INC /* z */
%token <atom> ATOM_DEC /* j */
%token <atom> ATOM_PUNTO /* . */
%token '+' '-' '*' '/' '%' '~' 'k'

/* No terminales */
%type <atom> programa list_dec_glob dec_global tipo list_id func otra_func arg list_arg
%type <atom> cuerpo lista_dec lista_sent sent asig op_asig op_asig_simple op_asig_comp
%type <atom> expr_gral expr term  factor factor_prime
%type <atom> exp_rel op_rel haz_mientras si sino para dev llama_func list_param param
%type <atom> val_ret

%start programa

%%

programa:
    list_dec_glob func otra_func
    ;

list_dec_glob:
    dec_global list_dec_glob
    | { $$ = '\0'; } /* vacío */
    ;

dec_global:
    ATOM_GLOBAL tipo ATOM_ID list_id ATOM_PUNTO_COMA
    ;

tipo:
    ATOM_BOOL
    | ATOM_CADE
    | ATOM_ENT
    | ATOM_FLOTA
    ;

list_id:
    ATOM_COMA ATOM_ID list_id
    | { $$ = '\0'; } /* vacío */
    ;

func:
    tipo ATOM_ID ATOM_PAR_IZQ arg ATOM_PAR_DER ATOM_COR_IZQ cuerpo ATOM_COR_DER
    ;

otra_func:
    func otra_func
    | { $$ = '\0'; } /* vacío */
    ;

arg:
    tipo ATOM_ID list_arg
    ;

list_arg:
    ATOM_COMA arg
    | { $$ = '\0'; } /* vacío */
    ;

cuerpo:
    lista_dec lista_sent
    ;

lista_dec:
    dec_global lista_dec
    | { $$ = '\0'; } /* vacío */
    ;

lista_sent:
    sent lista_sent
    | { $$ = '\0'; } /* vacío */
    ;

sent:
    asig
    | haz_mientras
    | si
    | para
    | dev
    | ATOM_CONTINUAR ATOM_PUNTO
    | ATOM_PARAR ATOM_PUNTO
    ;

asig:
    ATOM_ID op_asig ATOM_PUNTO_COMA
    ;

op_asig:
    op_asig_simple expr_gral
    | op_asig_comp expr_gral
    ;

op_asig_simple:
    ATOM_ASIG
    ;

op_asig_comp:
    ATOM_OPASIG
    ;

expr_gral:
    ATOM_CADENA
    | ATOM_FALS
    | ATOM_VER
    | ATOM_NULO
    | expr
    ;

expr:
    term expr_prime
    ;

expr_prime:
    '+' term expr_prime   /* Sin acción */
    | '-' term expr_prime /* Sin acción */
    | /* vacío sin acción */
    ;

term:
    factor term_prime
    ;

term_prime:
    '*' factor term_prime   /* Sin acción */
    | '/' factor term_prime
    | '%' factor term_prime
    | '~' factor term_prime
    | 'k' factor term_prime
    | /* vacío sin acción */
    ;

factor:
    ATOM_PAR_IZQ expr ATOM_PAR_DER
    | ATOM_ID factor_prime
    | ATOM_ENTERO
    | ATOM_REAL
    | llama_func
    ;

factor_prime:
    ATOM_INC
    | ATOM_DEC
    ;

llama_func:
    ATOM_LLAVE_IZQ ATOM_ID ATOM_PAR_IZQ list_param ATOM_PAR_DER ATOM_LLAVE_DER
    ;

list_param:
    expr_gral param
    | { $$ = '\0'; } /* vacío */
    ;

param:
    ATOM_COMA expr_gral param
    | { $$ = '\0'; } /* vacío */
    ;

exp_rel:
    expr op_rel expr
    ;

op_rel:
    '>'   { $$ = '>'; }
    | '<' { $$ = '<'; }
    | 'i' { $$ = 'i'; }
    | '!' { $$ = '!'; }
    | 'x' { $$ = 'x'; }
    | 'y' { $$ = 'y'; }
    ;

haz_mientras:
    ATOM_HAZ ATOM_COR_IZQ lista_sent ATOM_COR_DER ATOM_MIENTRAS ATOM_PAR_IZQ exp_rel ATOM_PAR_DER
    ;

si:
    ATOM_SI ATOM_PAR_IZQ exp_rel ATOM_PAR_DER ATOM_COR_IZQ lista_sent ATOM_COR_DER sino
    ;

sino:
    ATOM_SINO ATOM_COR_IZQ lista_sent ATOM_COR_DER
    | { $$ = '\0'; } /* vacío */
    ;

para:
    ATOM_PARA ATOM_PAR_IZQ expr ATOM_PAR_DER ATOM_COR_IZQ lista_sent ATOM_COR_DER
    ;

dev:
    ATOM_DEV ATOM_PAR_IZQ val_ret ATOM_PAR_DER ATOM_PUNTO
    ;

val_ret:
    expr_gral
    | { $$ = '\0'; } /* vacío */
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error sintáctico en línea %d: %s\nToken inesperado: '%s'\n", yylineno, s, yytext);
}

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "Uso: %s <archivo.txt>\n", argv[0]);
        return 1;
    }

    // Inicialización de tablas de símbolos (si es necesario)
    symbolCount = 0;
    numericLiteralCount = 0;
    stringLiteralCount = 0;
    atom_pos = 0;  // Reinicia la posición de átomos

    // Abrir archivo
    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("Error al abrir el archivo");
        return 1;
    }

    // Ejecutar análisis
    yyparse();

    // Mostrar resultados (funciones que estaban en el main léxico)
    printTables();  // Mostrar tablas de símbolos
    printf("\nCadena de átomos generada:\n%s\n", atom_sequence);

    // Cerrar archivo
    fclose(yyin);
    return 0;
}
