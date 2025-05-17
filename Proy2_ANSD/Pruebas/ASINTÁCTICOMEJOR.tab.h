/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_ASINT_CTICOMEJOR_TAB_H_INCLUDED
# define YY_YY_ASINT_CTICOMEJOR_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    ATOM_BOOL = 258,               /* ATOM_BOOL  */
    ATOM_CADE = 259,               /* ATOM_CADE  */
    ATOM_ENT = 260,                /* ATOM_ENT  */
    ATOM_FLOTA = 261,              /* ATOM_FLOTA  */
    ATOM_ID = 262,                 /* ATOM_ID  */
    ATOM_ASIG = 263,               /* ATOM_ASIG  */
    ATOM_OPASIG = 264,             /* ATOM_OPASIG  */
    ATOM_PUNTO_COMA = 265,         /* ATOM_PUNTO_COMA  */
    ATOM_COMA = 266,               /* ATOM_COMA  */
    ATOM_PAR_IZQ = 267,            /* ATOM_PAR_IZQ  */
    ATOM_PAR_DER = 268,            /* ATOM_PAR_DER  */
    ATOM_COR_IZQ = 269,            /* ATOM_COR_IZQ  */
    ATOM_COR_DER = 270,            /* ATOM_COR_DER  */
    ATOM_LLAVE_IZQ = 271,          /* ATOM_LLAVE_IZQ  */
    ATOM_LLAVE_DER = 272,          /* ATOM_LLAVE_DER  */
    ATOM_OPREL = 273,              /* ATOM_OPREL  */
    ATOM_GLOBAL = 274,             /* ATOM_GLOBAL  */
    ATOM_HAZ = 275,                /* ATOM_HAZ  */
    ATOM_MIENTRAS = 276,           /* ATOM_MIENTRAS  */
    ATOM_SI = 277,                 /* ATOM_SI  */
    ATOM_SINO = 278,               /* ATOM_SINO  */
    ATOM_PARA = 279,               /* ATOM_PARA  */
    ATOM_DEV = 280,                /* ATOM_DEV  */
    ATOM_CONTINUAR = 281,          /* ATOM_CONTINUAR  */
    ATOM_PARAR = 282,              /* ATOM_PARAR  */
    ATOM_CADENA = 283,             /* ATOM_CADENA  */
    ATOM_FALS = 284,               /* ATOM_FALS  */
    ATOM_VER = 285,                /* ATOM_VER  */
    ATOM_NULO = 286,               /* ATOM_NULO  */
    ATOM_ENTERO = 287,             /* ATOM_ENTERO  */
    ATOM_REAL = 288,               /* ATOM_REAL  */
    ATOM_INC = 289,                /* ATOM_INC  */
    ATOM_DEC = 290,                /* ATOM_DEC  */
    ATOM_PUNTO = 291               /* ATOM_PUNTO  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 16 "ASINTÁCTICOMEJOR.y"

    char atom;
    int num;

#line 105 "ASINTÁCTICOMEJOR.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_ASINT_CTICOMEJOR_TAB_H_INCLUDED  */
