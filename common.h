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
#ifndef COMMON_H
#define COMMON_H
#pragma once

#include <iostream>     // std::cout
#include <vector>

#include <string>       // std::string
#include <sstream>      // std::stringstream
#include <iomanip>      // std::setw
#include <regex>
#include <cstring>

extern int  yyerror(const char*);
extern int  yylex();

extern void yyset_in (FILE*);
extern void yyset_out(FILE*);
extern void yyset_lineno(int);
extern int  yyget_lineno();

// my own namespace: non-standard !!
namespace ext {
    const int CVT_NONE   = 0;
    const int CVT_ASM    = 2;
    const int CVT_PASCAL = 1;   // default ?

    enum ForthFlags {
        FLAG_NULL = 0,      // empty
        FLAG_SUBROUTINE,    // subroutine
        FLAG_PARAMETER,     // parameter
        FLAG_PROGRAM,       // program
        FLAG_VARIABLE       // variable
    };

    struct forth_labels {
        ::std::string       id;
        ::std::stringstream id_stream;

        forth_labels() { }
        forth_labels(const forth_labels &o) {
            id = o.id;
            id_stream.clear();
            id_stream << o.id_stream.str();
        }
        forth_labels & operator=(const forth_labels &o) {
            id = o.id;
            id_stream.clear();
            id_stream << o.id_stream.str();
        }
    };
    struct forth_programs  {
        ::std::string       id;
        ::std::stringstream id_stream;

        forth_programs() { }
        forth_programs(const forth_programs &o) {
            id = o.id;
            id_stream.clear();
            id_stream << o.id_stream.str();
        }
        forth_programs & operator=(const forth_programs &o) {
            id = o.id;
            id_stream.clear();
            id_stream << o.id_stream.str();
        }
    };
    struct forth_variables {
        ::std::string id;
        int           id_type = 0;

        forth_variables() {}
        forth_variables(const forth_variables &o) {
            id      = o.id;
            id_type = o.id_type;
        }
        forth_variables & operator=(const forth_variables &o) {
            id      = o.id;
            id_type = o.id_type; return
            *this;  
        }
    };
    struct forth_namespace {
        ::std::string                  id;
        ::std::vector<forth_namespace> id_parameter;
        ::std::vector<forth_variables> id_variables;
        ::std::vector<forth_programs>  id_programs;
        ::std::vector<forth_labels>    id_labels;
        int                            id_index = 0;
        ForthFlags                     id_type  = ForthFlags::FLAG_NULL;

        forth_namespace() {}
        forth_namespace(::std::string s1) : id(s1) {}

        forth_namespace(            const forth_namespace &o) { id = o.id; }
        forth_namespace & operator=(const forth_namespace &o) { id = o.id; }
    };

    ::std::vector<forth_namespace>           forth_memory;
    ::std::vector<forth_namespace>::iterator forth_memory_iterator;
    ::std::string forth_procedure;
    int           forth_memory_position = 0;

    FILE * file_pile[2048];
    int convert_mode = CVT_PASCAL;

    int current_id   = 0;
    int current_flag = ForthFlags::FLAG_NULL;

    int yyget_line_gap = 0;
    int yymet_line_gap = 0;

    int tmp_top_of_stack = 0;
    int tmp_parameter    = 1;

    ::std::stringstream tmp_string_stream;
    ::std::string yypadding(::std::string c) {
    ::std::stringstream ss;
         if (convert_mode == CVT_ASM)    { ss
         << ";"
         << ::std::setw(yymet_line_gap)
         <<      ::yyget_lineno()
         << ": " << c; } else
         if (convert_mode == CVT_PASCAL) { ss
         << "(* "
         << ::std::setw(yymet_line_gap)
         <<      ::yyget_lineno()
         << ": " << c
         << "*)" ;
         }
         return ss.str();
    }

    size_t strlen(const char * _str) {
        size_t i = 0;
        while(_str[i++]);
        return i;
    }

    ::std::string string2upper(::std::string s) {
        char *p = (char*)s.c_str();
        while (*p) {
            *p = toupper(*p);
            ++p;
        }
        return ::std::string(p);
    }        
    ::std::string string2lower(std::string s) {
        char *p = (char*)s.c_str();
        while (*p) {
            *p = toupper(*p);
            ++p;
        }
        return ::std::string(p);
    }        

    void removeCharsFromString(::std::string &str, char* charsToRemove) {
        for (unsigned int i = 0; i < strlen(charsToRemove); ++i) {
            str.erase(remove(str.begin(),str.end(),charsToRemove[i]),str.end());
        }
    }

    void replaceStr(::std::string &data, ::std::string toSearch, ::std::string replaceStr)
    {
	    // Get the first occurrence
	    size_t pos = data.find(toSearch);
     
	    // Repeat till end is reached
	    while( pos != std::string::npos)
	    {
		    // Replace this occurrence of Sub String
		    data.replace(pos, toSearch.size(), replaceStr);
		    // Get the next occurrence from the current position
		    pos = data.find(toSearch, pos + replaceStr.size());
	    }
    }

    ::std::vector< ::std::string> split(const ::std::string& s, char delimiter)
    {
        ::std::vector< ::std::string> tokens;
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
