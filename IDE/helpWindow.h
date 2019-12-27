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
#ifndef H_HELPWINDOW
#define H_HELPWINDOW
#pragma once

#include "helpViewer.hpp"

extern int  winNumber;
extern bool helpActive;

class TMyHelpViewer;
class TMyHelpWindow: public TWindow
{
    std::string helpName;
    fpstream   *helpStrm;
    int width, height;
    TRect r;
public:
    TMyHelpWindow(TRect r)
        : TWindowInit( &TMyHelpWindow::initFrame)
        , TWindow(r, "Help", winNumber++)
        {
        options |= ofTileable | ofFramed;
        state   |= sfCursorVis;

        TRect rec(getExtent());
        rec.grow(-1, -1);

        TMyHelpViewer *viewer = new TMyHelpViewer(rec,
            standardScrollBar(sbHorizontal | sbHandleKeyboard) ,
            standardScrollBar(sbVertical   | sbHandleKeyboard));

        insert(viewer);
    }
#if 0
    TMyHelpWindow(std::string &strm, int ctx)
    {
        auto *helpStrm = new fpstream(strm, CLY_IOSIn | CLY_IOSBin);
        if (!strm) {
            messageBox("help stream file not available.",
            mfOKButton | mfError);
            return;
        }

        helpName = strm;

        width  = 50;
        height = 10;

        r.a.x = floor((deskTop->size.x - width ) / 2);
        r.a.y = floor((deskTop->size.y - height) / 2);

        r.b.x = r.a.x + width;
        r.b.y = r.b.x + height;
    }
#endif
    ~TMyHelpWindow() {
        //helpStrm.close();
        //if (helpStrm != 0)
        //delete  helpStrm;
    }
};
#endif
