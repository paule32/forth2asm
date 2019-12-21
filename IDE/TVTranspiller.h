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
// --------------------------------------------------------------------------------
#ifndef TV_TRANSPILLER_H
#define TV_TRANSPILLER_H
#pragma once

#define Uses_string
#define Uses_stdio
#define Uses_ctype
#define Uses_stdlib
#define Uses_signal

#define Uses_TKeys
#define Uses_TDrawBuffer
#define Uses_TStreamableClass
#define Uses_TStreamable
#define Uses_TVCodePage
#define Uses_TMenuBar
#define Uses_TMenuItem
#define Uses_TSubMenu
#define Uses_TDialog
#define Uses_TColorDialog
#define Uses_TColorItem
#define Uses_TColorGroup
#define Uses_TStaticText
#define Uses_TCalculator
#define Uses_TView
#define Uses_TFileDialog
#define Uses_TFileWindow
#define Uses_TButton
#define Uses_TEditor
#define Uses_TPalette
#define Uses_TChDirDialog
#define Uses_TStatusLine
#define Uses_TStatusDef
#define Uses_TStatusItem
#define Uses_TApplication
#define Uses_TRect
#define Uses_TKeys
#define Uses_MsgBox
#define Uses_TEvent
#define Uses_TFileEditor
#define Uses_TScrollBar
#define Uses_TWindow
#define Uses_TDeskTop
#define Uses_TScreen
#define Uses_IOS_BIN
#define Uses_THelpWindow
#define Uses_TCalculator
#define Uses_TFileViewer

#define Uses_TVCodePage
#define Uses_TStreamableClass

#include <tv.h>

#include <time.h>
#include <sys/time.h>
#include <unistd.h>

#include "gadgets.h"
#include "calendar.h"
#include "fileview.h"
#include "ascii.h"
#include "puzzle.h"

#include <iostream>
#include <ios>
#include <string>
#include <set>
#include <sstream>
#include <exception>
#include <fstream>

const int cmAboutCmd        = 106;
const int cmPuzzleCmd       = 101;
const int cmCalendarCmd     = 102;
const int cmAsciiCmd        = 1103;
const int cmCalcCmd         = 104;
const int cmOpenCmd         = 105;
const int cmColorCmd        = 110;

const int cmAbout           = 106;

const int cmMyHelp          = 150;
const int cmMySave          = 151;
const int cmMyOpen          = 152;

const int cmChDirCmd        = 200;
const int cmSaveCmd         = 201;
const int cmSaveAsCmd       = 202;
const int cmNewCmd          = 203;
const int cmMouseCmd        = 204;
const int cmTestInputBox    = 205;
const int cmRestoreCmd      = 206;

const int hcAbout           = 1000;
const int hcExit            = 1001;
const int hcFSave           = 1002;
const int hcFSaveAs         = 1003;
const int hcFNew            = 1004;
const int hcSColor          = 1005;

const int
  hcNocontext            = 1,
  hcAsciiTable           = 6,
  hcCalculator           = 4,
  hcCalendar             = 5,
  hcCancelBtn            = 35,
  hcFCChDirDBox          = 37,
  hcFChangeDir           = 15,
  hcFDosShell            = 16,
  hcFExit                = 17,
  hcFOFileOpenDBox       = 31,
  hcFOFiles              = 33,
  hcFOName               = 32,
  hcFOOpenBtn            = 34,
  hcFOpen                = 14,
  hcFile                 = 13,
  hcOCColorsDBox         = 39,
  hcOColors              = 28,
  hcOMMouseDBox          = 38,
  hcOMouse               = 27,
  hcORestoreDesktop      = 30,
  hcOSaveDesktop         = 29,
  hcOpenBtn              = 36,
  hcOptions              = 26,
  hcPuzzle               = 3,
  hcSAbout               = 8,
  hcSAsciiTable          = 11,
  hcSCalculator          = 12,
  hcSCalendar            = 10,
  hcSPuzzle              = 9,
  hcSystem               = 7,
  hcViewer               = 2,
  hcWCascade             = 22,
  hcWClose               = 25,
  hcWNext                = 23,
  hcWPrevious            = 24,
  hcWSizeMove            = 19,
  hcWTile                = 21,
  hcWZoom                = 20,
  hcWindows              = 18;


class TStatusLine;
class TMenuBar;
struct TEvent;
class THeapView;
class TClockView;

class TVTranspillerApplicationIDE: public TApplication
{
public:
    TVTranspillerApplicationIDE(int argc, char **argv);
    TVTranspillerApplicationIDE(void);

    static uchar  systemMenuIcon[];
    static uchar osystemMenuIcon[];

    void init_desktop(void);

    static TStatusLine * initStatusLine (TRect r);
    static TMenuBar    * initMenuBar    (TRect r);

    virtual void handleEvent(TEvent& event);
    virtual void getEvent   (TEvent& event);
    virtual void idle();

    static TVCodePageCallBack oldCPCallBack;
    static void    cpCallBack(ushort *map);

    TPalette& getPalette() const;

    std::string hfn;    // help file name (context help)
    std::string dfn;    // data file name (session data)
    std::string sfn;    // config/settings file name

private:
    TClockView   * clock;

    void aboutDlgBox();
    void asciiTable();
    void calculator();
    void calendar();
    void colors();
    void puzzle();
    void shell();
    void saveDesktop();
    void retrieveDesktop();
    void testInputBox();
    void changeDir();
    void cascade();
    void tile();
    void loadDesktop(fpstream&);
    void storeDesktop(fpstream&);
    void openFile(char*);
    void outOfMemory();

    ushort executeDialog(TDialog*, void*);
    bool   isTileable   (TView*  , void*);
};

#endif
