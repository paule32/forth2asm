// --------------------------------------------------------------------------------
// MIT License
//
// Copyright (c) 2018 Jens Kallup
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
// --------------------------------------------------------------------------------

#include "common.h"

std::vector<ext::forth_prgs> ext::forth_pascal;

#if LOCALES_LANG == LOCALES_EN
const char yyerror_str1[LOCALES_LANG][100] = {    "comma sign not expected here" };
const char yyerror_str2[LOCALES_LANG][100] = {   "assing sign not expected here" };
const char yyerror_str3[LOCALES_LANG][100] = { "division sign not expected here" };
const char yyerror_str4[LOCALES_LANG][100] = { "parameter without closing brace" };
#elif LOCALES_LANG == LOCALES_DE
const char yyerror_str1[LOCALES_LANG][100] = {      "Kommazecihen hier nicht erwartet" };
const char yyerror_str2[LOCALES_LANG][100] = { "Zuweisungszeichen hier nicht erwartet" };
const char yyerror_str3[LOCALES_LANG][100] = {   "Divisionzeichen hier nicht erwartet" };
const char yyerror_str4[LOCALES_LANG][100] = { "Parameter ohne schließende Klammer"    };
#endif

int yyerror(const char *p) {
    std::cerr << "error:" << (yyget_lineno()+1) << ":" << p << std::endl;
    return yyget_lineno();
}


std::string banner()
{
    std::stringstream ss;
    ss << std::string("(* ============================================================== *)") << std::endl;
    ss << std::string("(* Fortran to Pascal transpiller.                                 *)") << std::endl;
    ss << std::string("(*                                                                *)") << std::endl;
    ss << std::string("(* (c) 2019 by Jens Kallup - non-profit Software                  *)") << std::endl;
    ss << std::string("(* (c) 2019 by Michael Schilling                                  *)") << std::endl;
    ss << std::string("(* all rights reserved.                                           *)") << std::endl;
    ss << std::string("(* ============================================================== *)") << std::endl;
    return ss.str();
}

int ext::yyget_line_gap = 0;
int ext::yymet_line_gap = 0;

FILE * ext::file_pile[2000];

int         ext::convert_mode = CVT_PASCAL;
int         ext::current_flag = forth_flags::e_forth_unknown;
std::string ext::current_var  = "";
std::string ext::current_prg  = "";

std::string ext::yypadding(::std::string c) {
std::stringstream ss;
    if (ext::convert_mode == CVT_ASM)    { ss
        << ";"
        << std::setw(ext::yymet_line_gap)
        <<      yyget_lineno()
        << ": " << c;
    } else
    if (ext::convert_mode == CVT_PASCAL) { ss
        << "(* "
        << ::std::setw(yymet_line_gap)
        <<      ::yyget_lineno()
        << ": "
        << c
        << "*)" ;
    }
    return ss.str();
}

std::string ext::string2upper(std::string s) {
    char *p = (char*)s.c_str();
    while (*p) {
        *p = toupper(*p);
        ++p;
    }
    return std::string(p);
}        

std::string ext::string2lower(std::string s) {
    char *p = (char*)s.c_str();
    while (*p) {
        *p = toupper(*p);
        ++p;
    }
    return std::string(p);
}        

void ext::removeCharsFromString(std::string &str, char* charsToRemove) {
    for (unsigned int i = 0; i < strlen(charsToRemove); ++i) {
        str.erase(remove(str.begin(),str.end(),charsToRemove[i]),str.end());
    }
}

void ext::replaceStr(std::string &data, std::string toSearch, std::string replaceStr)
{
    size_t pos = data.find(toSearch);
    while( pos != std::string::npos) {
	    data.replace(pos, toSearch.size(), replaceStr);
	    pos = data.find(toSearch, pos + replaceStr.size());
    }
}

std::vector<std::string> ext::split(const std::string& s, char delimiter)
{
    std::vector<std::string> tokens;
    std::string token;
    std::istringstream tokenStream(s);
    while (std::getline(tokenStream, token, delimiter)) {
       tokens.push_back(token);
    }
    return tokens;
}

size_t ext::strlen(const char * _str) {
    size_t i = 0;
    while(_str[i++]);
    return i;
}

void add_prg(std::string st) {
    auto &pas = ext::forth_pascal;
    ext::forth_prgs prg;
    prg.id_name = st;
    ext::current_prg = st;
    ext::forth_pascal.push_back(prg);
}

void add_var_bool(std::string st) {
    auto &prg = ext::forth_pascal.back();
    ext::forth_vars_bool ll;
    ll.id_name = st;
    prg.vars_bool.push_back(ll);
}
void add_var_int(std::string st) {
    auto &prg = ext::forth_pascal.back();
    ext::forth_vars_int ll;
    ll.id_name = st;
    prg.vars_int.push_back(ll);
}
void add_var_real(std::string st) {
    auto &prg = ext::forth_pascal.back();
    ext::forth_vars_real ll;
    ll.id_name = st;
    prg.vars_real.push_back(ll);
}
void add_var_char(std::string st) {
    auto &prg = ext::forth_pascal.back();
    ext::forth_vars_char ll;
    ll.id_name = st;
    prg.vars_char.push_back(ll);
}
void add_var_double(std::string st) {
    auto &prg = ext::forth_pascal.back();
    ext::forth_vars_double ll;
    ll.id_name = st;
    prg.vars_double.push_back(ll);
}

void add_proc(std::string st) {
    auto &prg = ext::forth_pascal.back();
    ext::forth_proc ll;
    ll.id_name = st;
    prg.proc.push_back(ll);
}
void add_func(std::string st) {
    auto &prg = ext::forth_pascal.back();
    ext::forth_func ll;
    ll.id_name = st;
    prg.func.push_back(ll);
}


void add_lbl(std::string s1) {
    auto &prg = ext::forth_pascal.back();
    ext::forth_lbls ll;
    ext::forth_cods cc;

    ll.id_name = s1;
    cc.id_stream << s1;

    prg.lbls.push_back(ll);
    prg.cods.push_back(cc);
}
void add_cod(std::string st) {
    auto &prg = ext::forth_pascal.back();
    ext::forth_cods cc;
    cc.id_name = st;
    cc.id_stream << st;
    prg.cods.push_back(cc);
}
void add_cnst(std::string v1, std::string v2) {
    auto &prg = ext::forth_pascal.back();
    ext::forth_cnst cc;
    cc.id_name = v1;
    cc.id_data = v2;
    prg.cnst.push_back(cc);
}
