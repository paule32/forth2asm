#!/bin/sh

flex  -o forth.lex.cpp -l  forth.lpp
bison -o forth.tab.cpp -vd forth.ypp

g++ -D_GLIBCXX_USE_CXX11_ABI=0	\
    -o forth -ggdb              \
    forth.lex.cpp forth.tab.cpp \
    -lm -ll -ly 		\
    -L./ -lstdc++
