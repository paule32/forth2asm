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
#include <assert.h>

#include "zlib.h"
#include "TVHelpWindow.h"
#include "TVTranspiller.h"

#include <algorithm>
#include <iostream>
#include <iterator>
#include <vector>

#include "help.h"

using namespace std;

//const int maxLineLength = maxViewWidth+1;
const int maxLines      = 100;
char *Lines[maxLines];
int LineCount = 0;

extern bool helpActive;
extern class TVTranspillerApplicationIDE *IDEapp;

static short winNumber = 0;

TVHelpWindow::TVHelpWindow(TRect r)
    : TWindowInit( &TVHelpWindow::initFrame )
    , TWindow(r, "Help", winNumber++)
{
    check_zip("debug.hlp");

    options |= ofTileable | ofFramed;
    state   |= sfCursorVis;

    TRect rec(getExtent());
    rec.grow(-1, -1);

    TVHelpViewer *viewer = new
    TVHelpViewer(rec
        , standardScrollBar(sbHorizontal | sbHandleKeyboard)
        , standardScrollBar(sbVertical   | sbHandleKeyboard));
    insert(viewer);
/*
    TRect er(getExtent());
    er.grow(-1,-1);

    TEditWindow *editor = new
    TEditWindow(er,0,100);
    insert(editor);
*/
}


void TVHelpWindow::check_zip(std::string filename)
{
    // ----------------
    // write help() ...
    // ----------------
    std::string helpstr   =
"Hallo und Willkommen!";

    class help_header *hdr = new help_header;

    hdr->file_type    = 0x1949;
    hdr->version_     = 0x1501;
    hdr->entry_point  = 0x0201;
    hdr->password     = std::string("passkey");
    hdr->password_len = hdr->password.size();
    hdr->topics_no    = 1;

    class help_topic *top1 = new help_topic;
    top1->topic_idx = 1;
    top1->topic_str     = std::string("Index");
    top1->topic_len_str = std::string("Index").size();
    top1->topic_txt     = helpstr;
    top1->topic_len_txt = top1->topic_txt.size();


    std::ofstream out(filename, std::ofstream::binary);
    boost::archive::binary_oarchive oa(out);

    oa << hdr;
    oa << top1;

    out.close();

    delete top1;
    delete hdr;

}

TVHelpViewer::~TVHelpViewer()
{
    helpActive = false;
}

Boolean TVHelpViewer::valid(ushort)  {
    return isValid;
}

TVHelpViewer::TVHelpViewer(
        const TRect& bounds,
        TScrollBar *aHScrollBar,
        TScrollBar *aVScrollBar)
    :   TScroller( bounds, aHScrollBar, aVScrollBar )
{
    growMode = gfGrowHiX | gfGrowHiY;
    options |= ofSelectable;
    eventMask = evMouseDown | evKeyDown | evCommand | evBroadcast;
    showCursor();

    isValid = True;
}

void TVHelpViewer::scrollDraw()
{
    TScroller::scrollDraw();
    draw();
}

void TVHelpViewer::draw()       // modified for scroller
{
    static int disp = 0;

    char   buffer[2048];
    ushort color = getColor(0x0301);

    if (disp == 0)
    {   disp  = 1;

        std::ifstream in("fort.hlp", std::ifstream::binary);
        boost::archive::binary_iarchive ia(in);

        class help_header *hdr = new help_header;
        class help_topic  *top = new help_topic;

        ia >> hdr;
        ia >> top;

        strcpy(buffer,top->topic_str.c_str());
    }

    cout << buffer << endl;

    TDrawBuffer db;
    char c;
    int  i = 0;
    while ((c = buffer[i]))
    {
        db.moveChar(i++, c, color, 1);
    }

#ifdef _OLDDDD_
    ushort color = getColor(0x0301);
    char buffer[20];

    for( int i = 0; i < size.y; i++ )
    // for each line:
    {
        sprintf(buffer,"%6d",i+1);

        TDrawBuffer b,c,d;
        //b.moveStr(0, buffer, color, 6);
        //c.moveChar(0, 133, color, 1);
        d.moveChar(0, ' ', color, size.x);

        // fill line buffer with spaces
        int j = delta.y + i;       // delta is scroller offset
        if( j < LineCount && Lines[j] != 0 )
            {
            char s[maxLineLength];
            if( delta.x > (int)strlen(Lines[j] ) )
                s[0] = EOS;
            else
                {
                strncpy( s, Lines[j]+delta.x, size.x );
                s[size.x] = EOS;
                }
            b.moveCStr( 0, s, color );
            }
        //writeLine(0, i, 6, 1, b);
        //writeLine(6, i, 2, 1, c);
        //writeLine(7, i, size.x, 1, d);
        writeLine(0, i, size.x, 1, d);
    }
#endif
}


void TVHelpViewer::handleEvent(TEvent &event)
{
    TScroller::handleEvent(event);
}
