# -------------------------------------------------------------------------------
# MIT License
#
# Copyright (c) 2018 Jens Kallup
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# -------------------------------------------------------------------------------
CC  = gcc-5
CXX = g++-5

IDIR = -I./ -I./include

DEBUG = -ggdb -std=c++14 -fsanitize=address -D_GLIBCXX_USE_CXX11_ABI=0

CFLAGS   = $(DEBUG) $(IDIR)
CXXFLAGS = $(DEBUG) $(IDIR)

LDIR = ./
LIBS = -lm -ll -ly -lasan -L./ -lstdc++

forth:
	bison -o forth.tab.cpp -vd forth.ypp
	flex  -o forth.lex.cpp -l  forth.lpp
	$(CXX) -c $(CXXFLAGS) -o forth.tab.o forth.tab.cpp
	$(CXX) -c $(CXXFLAGS) -o forth.lex.o forth.lex.cpp
	$(CXX) -c $(CXXFLAGS) -o twisted.o twisted.cpp
	$(CXX) -o forth forth.lex.o forth.tab.o twisted.o $(LIBS)

.PHONY: clean

clean:
	rm -f forth.lex.cpp
	rm -f forth.tab.cpp
	rm -f *.o *~ core $(INCDIR)/*~

