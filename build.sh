#!/bin/sh

flex  -o forth.lex.cpp -l  forth.lpp
bison -o forth.tab.cpp -vd forth.ypp

g++ -D_GLIBCXX_USE_CXX11_ABI=0    \
    -ggdb -fno-omit-frame-pointer \
    -fsanitize=address            \
    -o forth			  \
    forth.lex.cpp forth.tab.cpp   \
    -lm -ll -ly 		  \
    -L./ -lstdc++

#g++ -D_GLIBCXX_USE_CXX11_ABI=0    \
#    -ggdb -fno-omit-frame-pointer \
#    -fsanitize=address            \
#    -o forth -ggdb                \
#    test2.cc   \
#    -L./ -lstdc++
