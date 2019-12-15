%{
// --------------------------------------------------------------------------------
// MIT License
//
// Copyright (c) 2019 Jens Kallup
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
// exec example: fort2pas --mode pascal --auto source.f
//
// Legend: --mode = pascal transpile
//         --auto = _no_ interactive run
// --------------------------------------------------------------------------------
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include <ctype.h>
#include <limits.h>
#include <unistd.h>
#include <getopt.h>
#include <limits.h>
#include <ftw.h>
#include <sys/types.h>
#include <sys/stat.h>

// forward declarations ...
void banner(FILE*);

const int CVT_NONE   = 0;
const int CVT_ASM    = 2;
const int CVT_PASCAL = 1;   // default ?

int   convert_mode   = 0;

#define YYDEBUG 1
#define YYTYPE yylval

#include "forth.tab.h"
#undef yywrap
int    yywrap() { return 1; }

int yyerror(const char *p) {
    fprintf(stderr,"error:%d:%s\n",yylineno,p);
    return yylineno;
}

%}

%option noyywrap
%option caseless

DIGIT       [0-9]
num         {DIGIT}+
realnum     [0-9]+\.?[0-9]+
ws          [ \t\n\r]

ident       [a-zA-Z]+[a-zA-Z0-9_]*

l_not       (\.[n|N][o|O][t|T]\.)
l_and       (\.[a|A][n|N][d|D]\.)
l_or        (\.[o|O][r|R]\.)
l_xor       (\.[x|X][o|O][r|R]\.)
l_eqv       (\.[e|E][q|Q][v|V]\.)
l_neq       (\.[n|N][e|E][q|Q][v|V]\.)

%%

^\!.*\n     { }
^\*.*\n     { }
^[c|C].*\n  { }

^[1-9]+[0-9]* {
    BEGIN(INITIAL);
}

([l|L][o|O][g|G][i|I][c|C][a|A][l|L])                { return _LOGICALS_  ; }
([i|I][n|N][t|T][e|E][g|G][e|E][r|R])                { return _INTEGERS_  ; }
([r|R][e|E][a|A][l|L])                               { return _REALS_     ; }
([d|D][o|O][u|U][b|B][l|L][e|E])                     { return _DOUBLES_   ; }
([c|C][o|O][m|M][p|P][l|L][e|E][x|X])                { return _COMPLEXS_  ; }
([c|C][a|A][r|R][a|A][c|C][t|T][e|E][r|R])           { return _CHARS_     ; }
([d|D][i|I][m|M][e|E][n|n][s|S][i|I][o|O][n|N])      { return _DIMENS_    ; }
([s|S][u|U][b|B][r|R][o|O][u|U][t|T][i|I][n|N][e|E]) { return _ROUTINES_  ; }
([p|P][r|R][o|O][g|G][r|R][a|A][m|M])                { return _PROGRAMS_  ; }
([g|G][o|O][t|T][o|O])                               { return _GOTOS_     ; }
([p|P][a|A][r|R][a|A][m|M][e|E][t|T][e|E][r|R])      { return _PARAMETERS_; }
([e|E][n|N][d|D])                                    { return _ENDS_      ; }

(\.[f|F][a|A][l|L][s|S][e|E]\.) { return _FALSE_; }
(\.[t|T][r|R][u|U][e|E]\.)      { return _TRUE_ ; }

{ident}     { return _IDS_ ; }

{num}*      { return _NUMS_; }
{realnum}*  { return _NUMS_; }

\'.*\'      { return _STRINGS_; }

\(          { return '('; }
\)          { return ')'; }
\,          { return ','; }
\=          { return '='; }

\+          { return '+'; }
\-          { return '-'; }
\*          { return '*'; }
\/          { return '/'; }

\^          { return '^'; }
\%          { return '%'; }

{ws}*       { }

.   {
    yyerror("unknow character.");
    exit(1);
}

<<EOF>>         { return 0; }
%%

//-- FUNCTION DEFINITIONS ---------------------------------
int main(int argc, char **argv)
{
    FILE * file_pile[100];
    int opt, c;
    int idx;

    static const struct option long_options[] =
    {
        { "mode",    required_argument, 0, 400 },
        { "auto",    no_argument,       0, 401 },
        { "verbose", no_argument,       0, 402 },
        { "version", no_argument,       0, 404 },
        { "help",    no_argument,       0, 408 },
        { 0     ,    0          ,       0,  0  }
    };

    fprintf(stdout,"forth2asm (c) 2019 Jens Kallup - non profit Software\n");
    fprintf(stdout,"all rights reserved.\n\n");

    if (argc < 2) {
        fprintf(stderr,"no parameter given.\n");
        return 1;
    }

    int w_flag = 0;
    #define macro_w_flag 1

    while (1) {
        opt = optind ? optind : 1;
        idx = 0;
        if ((c = getopt_long(argc, argv, "abc:d", long_options, &idx)) < 0) {
            break;
        }
        switch (c) {
        case 0:
            printf("option %s", long_options[idx].name);
            if (optarg)
                printf(" with arg %s", optarg);
            printf("\n");
            break;

        case 400:
        {
            if (strcmp(optarg,"pascal")) {
                convert_mode = CVT_PASCAL;
            }
            else if (strcmp(optarg,"asm")) {
                convert_mode = CVT_ASM;
            }
            else {
                fprintf(stderr,"unknow converter mode\n");
                return 1;
            }
            fprintf(stdout,"source file will be converted to: %s\n",optarg);
        }
        break;

        case 401:
            w_flag = macro_w_flag;
            break;

        case 402:
            fprintf(stdout,"option verbose\n");
            break;

        case 404:
            fprintf(stdout,"version: 0.0.1 alpha\n");
            break;

        case 408:
            fprintf(stdout,
            "Fortran Transpiller - options:\n"
            " --mode     mode = asm, pascal\n");
            break;

        case '?':
            break;

        default:
            fprintf(stderr,"?? getopt returned character code 0%o ??\n", c);
        }
    }

    char *input_file = (char*) malloc(1024);
    char *reput_file = (char*) malloc(1024);

    if (optind < argc) {
        while (optind < argc) {
            if (!(file_pile[optind++] = fopen(argv[optind-1],"r"))) {
                optind += 1;
                char buffer[200];
                sprintf(buffer,"can't open file: %s",argv[optind-1]);
                perror (buffer);
                return 1;
            }
            else {
                fclose(file_pile[optind-1]);
            }   strcpy(input_file,argv[optind-1]);
        }
    }
    else {
        fprintf(stderr,"no input file specified.\n");
        return 1;
    }

    if (strlen(input_file) < 1)
    strcpy(input_file,"stdin");

    strcpy(reput_file,input_file);

    if (convert_mode == CVT_PASCAL) strcat(reput_file,".pas"); else
    if (convert_mode == CVT_ASM   ) strcat(reput_file,".asm");

    FILE *fr = fopen(input_file,"r"); if (!fr) return yyerror("can not open input file!");
    FILE *fw = fopen(reput_file,"w"); if (!fw) return yyerror("can not open write file!");

    yyset_in (fr);
    yyset_out(fw);

    yylineno = 1;
    
    // parse/lex code ...
    int result = yyparse();


    free(input_file);
    free(reput_file);
    fclose(fr);
    fclose(fw);

    fprintf(stdout,"done.\n");

    return result;
}

// ----------------------------------------------------------------------------
// Code of Conduct - please keep this notice intact - thank's ...
// ----------------------------------------------------------------------------
void banner(FILE *out)
{
    fprintf(out,
    "(* ============================================================== *)\n"
    "(* Fortran to Pascal transpiller.                                 *)\n"
    "(*                                                                *)\n"
    "(* (c) 2019 by Jens Kallup - non-profit Software                  *)\n"
    "(* (c) 2019 by Michael Schilling                                  *)\n"
    "(* all rights reserved.                                           *)\n"
    "(* ============================================================== *)\n");
}
