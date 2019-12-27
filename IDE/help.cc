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
#include "TVTranspiller.h"

TMyHelpViewer::TMyHelpViewer(
        const TRect &bounds,
        TScrollBar * aHScrollBar,
        TScrollBar * aVScrollBar)
    :   _hscroll(aHScrollBar)
    ,   _vscroll(aVScrollBar)
    ,   TScroller(bounds, aHScrollBar, aVScrollBar) {

    growMode = gfGrowHiX | gfGrowHiY;
    options |= ofSelectable;

    eventMask = evMouseDown | evKeyDown | evCommand | evBroadcast;

    _hscroll->setRange(1,100);
    _vscroll->setRange(1,100);

    showCursor();
    isValid = true;
}

TMyHelpViewer::~TMyHelpViewer()
{
}

bool TMyHelpViewer::valid( ushort ) { return true; }
void TMyHelpViewer::scrollDraw()
{
    TScroller::scrollDraw();
    draw();
}

void TMyHelpViewer::draw()
{
    static int disp = 0;

    char bufferA[2048];
    char bufferB[2048];
    char bufferC[2048];

    sprintf(bufferA,"Hello World !!!");
    sprintf(bufferB,"testoesssz");
    sprintf(bufferC,"Albermn");

    ushort color = getColor(0x0301);

    if (disp == 0)
    {   disp  = 1;

    }

    TDrawBuffer db;
    char c;
    int i = 0;

    for (int i = 0; i < size.y; i++) {
        for (int j = 0; j < 3; j++) {
            db.moveChar(0, ' ', color, size.x);
            if (j == 0) db.moveCStr(0, bufferA, color);
            if (j == 1) db.moveCStr(0, bufferB, color);
            if (j == 2) db.moveCStr(0, bufferC, color);
            writeLine(0, i+j, size.x, 1, db);
        }   i += 2;
    }
}

void TMyHelpViewer::handleEvent(TEvent &event) {
    TScroller::handleEvent(event);
    switch (event.what) {
        case evKeyDown:
            if (helpActive)
            if (event.keyDown.keyCode == kbEsc) {
                removeView(helpWindow);
                destroy(helpWindow);
                helpWindow = nullptr;
                helpActive = false;
                deskTop->draw();
            }
            clearEvent(event);
        break;
    }
}


