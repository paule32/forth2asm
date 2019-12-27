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
#ifndef H_HELPFILE_P
#define H_HELPFILE_P
#pragma once

#include "help.hpp"

// ----------------------------------------------------------------------------
// Help system by paule32 ...
// ----------------------------------------------------------------------------
class TMyHelpViewer: public TScroller
{
    bool helpActive = false;
    TMyHelpWindow   * helpWindow = nullptr;

    TScrollBar * _vscroll;
    TScrollBar * _hscroll;
public:
    TMyHelpViewer(
        const TRect &bounds,
        TScrollBar * ahScrollBar ,
        TScrollBar * avScrollBar);

    virtual void handleEvent(TEvent &event);

    void scrollDraw();
    void draw();

    bool valid(ushort command);
    bool isValid;

    ~TMyHelpViewer();
};
#endif
