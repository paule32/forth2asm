c ------------------------------------------------------------
      subroutine chgrid (fx, x, nx, fy, y, ny)
!  piecewise quadratic interpolation from grid x to grid y,  by
!  aitken's divided difference scheme.   nx,ny are array dimensions?
!  note that ny is reset in chgrid

      dimension fx(nx), x(nx), fy(ny), y(ny)

      iy=1
      do 20 ix = 3, nx
   10   if (iy .gt. ny) goto 30
        yy=y(iy)
        if (yy .gt. x(ix)) goto 20
        a1=x(ix-2)-yy
        a2=x(ix-1)-yy
        a3=x(ix)-yy
        a12=(fx(ix-2)*a2-fx(ix-1)*a1)/(x(ix-1)-x(ix-2))
        a13=(fx(ix-2)*a3-fx(ix)*a1)/(x(ix)-x(ix-2))
        fy(iy)=(a12*a3-a13*a2)/(x(ix)-x(ix-1))
        if (iy .gt. ny) goto 30
        iy=iy+1
        goto 10
   20 continue
   30 ny=iy-1
      return
      end
