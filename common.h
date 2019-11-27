#ifndef COMMON_H
#define COMMON_H
#pragma once

#include <iostream>     // std::cout
#include <vector>

#include <string>       // std::string
#include <sstream>      // std::stringstream
#include <iomanip>      // std::setw
#include <regex>

extern int  yyerror(const char*);
extern int  yylex();

extern void yyset_in (FILE*);
extern void yyset_out(FILE*);
extern void yyset_lineno(int);
extern int  yyget_lineno();

// my own namespace: non-standard !!
namespace ext {
    struct forth_namespace {
        ::std::string              id;
        ::std::vector<std::string> id_parameter;

        forth_namespace() {}
        forth_namespace(::std::string s1) : id(s1) {}
    };

    ::std::vector<forth_namespace> forth_memory;
    int forth_memory_position = 0;

    enum ForthFlags {
        FLAG_NULL = 0,      // empty
        FLAG_SUROUTINE,     // subroutine
        FLAG_PARAMETER      // parameter
    };

    int current_id   = 0;
    int current_flag = ForthFlags::FLAG_NULL;

    int yyget_line_gap = 0;
    int yymet_line_gap = 0;

    int tmp_top_of_stack = 0;
    int tmp_parameter    = 0;

    ::std::stringstream tmp_string_stream;
    ::std::string yypadding(::std::string c) {
    ::std::stringstream ss; ss
    << ";"
    << ::std::setw(yymet_line_gap)
    <<      ::yyget_lineno()
    << ": " << c;
    return ss.str();
    }

    void removeCharsFromString(::std::string &str, char* charsToRemove) {
        for (unsigned int i = 0; i < strlen(charsToRemove); ++i) {
            str.erase(remove(str.begin(),str.end(),charsToRemove[i]),str.end());
        }
    }

    ::std::vector<::std::string> split(const ::std::string& s, char delimiter)
    {
        ::std::vector<::std::string> tokens;
        ::std::string token;
        ::std::istringstream tokenStream(s);
        while (::std::getline(tokenStream, token, delimiter))
        {
           tokens.push_back(token);
        }
        return tokens;
    }
}

#endif
