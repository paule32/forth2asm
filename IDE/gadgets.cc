#include <tv/configtv.h>

// SET: moved the standard headers before tv.h
#define Uses_string
#define Uses_stdlib
#define Uses_ctype
#define Uses_time
#define Uses_iomanip
#define Uses_stdio
#define Uses_sys_stat

#define Uses_TRect
#define Uses_TView
#define Uses_TDrawBuffer
#include <tv.h>

#include "gadgets.h"

//extern "C" unsigned long farcoreleft( void );

//
// ------------- Heap Viewer functions
//

THeapView::THeapView(TRect& r) : TView( r )
{
#if 0
    oldMem = 0;
    newMem = heapSize();

	/* SS: now resizing under X works well */
	growMode = gfGrowLoX | gfGrowLoY | gfGrowHiX | gfGrowHiY;
#endif
}


void THeapView::draw()
{
#if 0
    TDrawBuffer buf;
    char c = getColor(2);

    buf.moveChar(0, ' ', c, (short)size.x);
    buf.moveStr(0, heapStr, c);
    writeLine(0, 0, (short)size.x, 1, buf);
#endif
}


void THeapView::update()
{
#if 0
    if( (newMem = heapSize()) != oldMem )
        {
        oldMem = newMem;
        drawView();
        }
#endif
}


long THeapView::heapSize()
{
#if 0
   struct stat st;
   long rval=0;

   if (stat("/proc", &st)==0)
   {
      rval=st.st_size;
   }

   if (rval>1024UL*512UL) // one half megabyte !
   {
      if (rval>1024UL*1024UL*32UL) // if above 32Mb free
      {
         sprintf(heapStr, "%10dMb", rval/1024UL/1024UL);
      }
      else
      {
         sprintf(heapStr, "%10dKb", rval/1024UL);
      }
   }
   else
   {
      sprintf(heapStr, "%12d", rval);
   }

   return rval;

//	strcpy(heapStr, "Hello world!");
#endif
    return -1;
}


//
// -------------- Clock Viewer functions
//

TClockView::TClockView( TRect& r ) : TView( r )
{
    strcpy(lastTime, "        ");
    strcpy(curTime, "        ");

	/* SS: now resizing under X works well */
	growMode = gfGrowLoX | gfGrowHiX;
}


void TClockView::draw()
{
    TDrawBuffer buf;
    char c = getColor(2);

    buf.moveChar(0, ' ', c, (short)size.x);
    buf.moveStr(0, curTime, c);
    writeLine(0, 0, (short)size.x, 1, buf);
}


void TClockView::update()
{
    time_t t = time(0);
    char *date = ctime(&t);

    date[19] = '\0';
    strcpy(curTime, &date[11]);        /* Extract time. */

    if( strcmp(lastTime, curTime) )
        {
        drawView();
        strcpy(lastTime, curTime);
        }
}
