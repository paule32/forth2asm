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
#ifndef THELPWINDOW_H
#define THELPWINDOW_H

#define Uses_stdlib             // for exit(), rand()
#define Uses_iostream
#define Uses_fstream
#define Uses_stdio              // for puts() etc
#define Uses_string             // for strlen etc
#define Uses_ctype
#define Uses_getline

#define Uses_TEventQueue
#define Uses_TEvent
#define Uses_TIndicator
#define Uses_TProgram
#define Uses_TApplication
#define Uses_TKeys
#define Uses_TRect
#define Uses_TMenuBar
#define Uses_TSubMenu
#define Uses_TMenuItem
#define Uses_TStatusLine
#define Uses_TStatusItem
#define Uses_TStatusDef
#define Uses_TDeskTop
#define Uses_TView
#define Uses_TWindow
#define Uses_THelpFile
#define Uses_TScroller
#define Uses_TVConfigFile
#define Uses_TDialog
#define Uses_TCheckBoxes
#define Uses_TLabel
#define Uses_TEditWindow
#define Uses_TSItem
#define Uses_TRadioButtons
#define Uses_TInputLine
#define Uses_TValidator
#define Uses_TButton
#define Uses_MsgBox
#include <tv.h>

using namespace std;

class TInterior: public TScroller
{
public:
    TInterior(const TRect& bounds, TScrollBar *aHScrollBar, TScrollBar *aVScrollBar);
    virtual void draw();
};

class TVHelpViewer : public TScroller
{
public:
    TVHelpViewer(
            const TRect& bounds,
            TScrollBar *aHScrollBar,
            TScrollBar *aVScrollBar);
    ~TVHelpViewer();

    virtual void handleEvent(TEvent& event);

    void draw();
    void scrollDraw();

    Boolean valid( ushort command );
    Boolean isValid;
};

class TVHelpWindow : public TWindow
{
public:
    TVHelpWindow(TRect r);
    void makeInterior();
    TInterior *interior;

    void check_zip(std::string filename);
};

#endif // THELPWINDOW_H
