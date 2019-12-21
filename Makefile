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

CROSS_MAC = -e CROSS_TRIPLE=x86_64-apple-darwin multiarch/crossbuild
CROSS_WIN = -e CROSS_TRIPLE=x86_64-w64-mingw32  multiarch/crossbuild

DOCKER    = sudo docker run -it --rm -v $(PWD):/workdir

MAC_CC    = $(DOCKER) $(CROSS_MAC) gcc
MAC_CXX   = $(DOCKER) $(CROSS_MAC) g++
MAC_STRIP = $(DOCKER) $(CROSS_MAC) strip

WIN_CC    = $(DOCKER) $(CROSS_WIN) gcc
WIN_CXX   = $(DOCKER) $(CROSS_WIN) g++
WIN_STRIP = $(DOCKER) $(CROSS_WIN) strip

LINUX_CC    = gcc-5
LINUX_CXX   = g++-5
LINUX_STRIP = strip

IDIR = -I./ -I./IDE \
	-I./IDE/include \
	-I./IDE/include/tv \
	-I./IDE/include/cl

CXX_DEBUG = -ggdb -std=c++14 -DDEBUG -D_GLIBCXX_USE_CXX11_ABI=0 $(IDIR)
CC__DEBUG = -ggdb            -DDEBUG

CFLAGS    = $(CC__DEBUG) $(IDIR) -Wno-format-extra-args -O2 -c
CXX_FLAGS = $(CXX_DEBUG) $(IDIR) -Wno-format-extra-args -O2 -c \
	-Wno-write-strings \
	-Wno-deprecated-declarations

LDIR = ./

LDLIBS += -lboost_program_options

CC_LIBS  = -lm -ll -ly -lasan
CXX_LIBS = $(CC_LIBS) -lstdc++  \
	-L./ -L./IDE/lib -L/usr/lib/x86_64-linux-gnu/ -L/lib \
	-lrhtv -lncurses -lgpm  \
	-lboost_serialization   \
	-lboost_system          \
	-lboost_filesystem      \
	-lboost_program_options

forth.linux:
	$(LINUX_CXX) -o IDE/TVTranspiller.o $(CXX_FLAGS) IDE/TVTranspillerApplicationIDE.cc
	$(LINUX_CXX) -o IDE/calendar.o      $(CXX_FLAGS) IDE/calendar.cc
	$(LINUX_CXX) -o IDE/gadgets.o       $(CXX_FLAGS) IDE/gadgets.cc
	$(LINUX_CXX) -o IDE/ascii.o         $(CXX_FLAGS) IDE/ascii.cc
	$(LINUX_CXX) -o IDE/puzzle.o        $(CXX_FLAGS) IDE/puzzle.cc
	cd IDE
	g++	IDE/TVTranspiller.o \
		IDE/ascii.o    \
		IDE/calendar.o \
		IDE/gadgets.o  \
		IDE/puzzle.o   \
		-o forti $(CXX_LIBS)
	cd ..
	bison -o forth.tab.cc -vd forth.ypp
	flex  -o forth.lex.cc -l  forth.lpp
	$(LINUX_CXX) -c $(CXX_FLAGS) -o forth.tab.o forth.tab.cc
	$(LINUX_CXX) -c $(CXX_FLAGS) -o forth.lex.o forth.lex.cc
	$(LINUX_CXX) -o forth-linux forth.lex.o forth.tab.o $(CXX_LIBS)
	cp forth-linux forth-upx
	$(LINUX_STRIP) -X -x -g \
		--wildcard  \
		--strip-dwo \
		--strip-all \
		--remove-relocations  \
		--disable-deterministic-archives forth-linux
	upx forth-upx

forth.windows: forth.darwin
	bison -o forth.tab.c -vd forth.y
	flex  -o forth.lex.c -l  forth.l
	$(WIN_CC) -c $(CFLAGS)  -o forth.tab.o forth.tab.c
	$(WIN_CC) -c $(CFLAGS)  -o forth.lex.o forth.lex.c
	$(WIN_CC) -o forth-windows forth.lex.o forth.tab.o $(CC_LIBS)
	$(WIN_STRIP) forth-windows

forth.darwin:
	bison -o forth.tab.c -vd forth.y
	flex  -o forth.lex.c -l  forth.l
	$(MAC_CC) -c $(CFLAGS) -o forth.tab.o forth.tab.c
	$(MAC_CC) -c $(CFLAGS) -o forth.lex.o forth.lex.c
	$(MAC_CC) -o forth-darwin forth.lex.o forth.tab.o $(CC_LIBS)
	$(MAC_STRIP) forth-darwin

.PHONY: clean

clean:
	rm -f forth-linux forth-darwin forth-windows
	rm -f forth.lex.cc
	rm -f forth.tab.cc
	rm -f *.o *~ core $(INCDIR)/*~
