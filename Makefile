# -------------------------------------------------------------------------------
# MIT License
#
# Copyright (c) 2019 Jens Kallup
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
PWD = /home/jens/Projekte/dBase4Linux/source/parser/forth

CROSS   = -e CROSS_TRIPLE=x86_64-apple-darwin multiarch/crossbuild
DOCKER  = sudo docker run -it --rm -v $(PWD):/workdir

MAC_CC    = $(DOCKER) $(CROSS) gcc
MAC_CXX   = $(DOCKER) $(CROSS) g++
MAC_STRIP = $(DOCKER) $(CROSS) strip

LINUX_CC    = gcc-5
LINUX_CXX   = g++-5
LINUX_STRIP = strip

IDIR = -I./ -I./include

CXX_DEBUG = -ggdb -std=c++14 -fsanitize=address -DDEBUG -D_GLIBCXX_USE_CXX11_ABI=0
CC__DEBUG =

CFLAGS   = $(CC__DEBUG) $(IDIR)
CXXFLAGS = $(CC__DEBUG) $(IDIR)

LDIR = ./
LIBS = -lm -ll -ly

forth.linux: forth.darwin
	bison -o forth.tab.c -vd forth.y
	flex  -o forth.lex.c -l  forth.l
	$(LINUX_CC) -c $(CFLAGS) -o forth.tab.o forth.tab.c
	$(LINUX_CC) -c $(CFLAGS) -o forth.lex.o forth.lex.c
	$(LINUX_CC) -o forth-linux  forth.lex.o forth.tab.o $(LIBS)
	cp forth-linux forth-upx
	$(LINUX_STRIP) -X -x -g \
        --wildcard  \
		--strip-dwo \
		--strip-all \
		--remove-relocations  \
		--disable-deterministic-archives forth-linux
	upx forth-upx

forth.darwin:
	bison -o forth.tab.c -vd forth.y
	flex  -o forth.lex.c -l  forth.l
	$(MAC_CC) -c $(CFLAGS) -o forth.tab.o forth.tab.c
	$(MAC_CC) -c $(CFLAGS) -o forth.lex.o forth.lex.c
	$(MAC_CC) -o forth-darwin forth.lex.o forth.tab.o $(LIBS)
    $(MAC_STRIP) forth-darwin

.PHONY: clean

clean:
	rm -f forth.linux forth.darwin
	rm -f forth.lex.c
	rm -f forth.tab.c
	rm -f *.o *~ core $(INCDIR)/*~
