c ------------------------------------------------------------
      subroutine mtzm (vh, vs, rx, ngrid, rmt, rws, jrmt, jrws, vhar,
     &                 vex)
!  subroutine for calculation of the muffin-tin zero level for
!  monoatomic crystals, using a spherical average of the potential
!  between muffin-tin radius and wigner-seitz radius, as in eq 3.31
!  of loucks, transformed to the exponential grid rx?
!                       rx(i)=exp(-8.8+0.05(i-1))
!  integration by trapezium rule.  jrmt,jrws are grid points outside
!  muffin-tin radius and wigner-seitz radius respectively

      dimension vh(ngrid), vs(ngrid), rx(ngrid)
      double precision sumh, sume

      dx=0.05
      ddx=0.5*dx
      dxx=exp(3.*dx)
      x=alog(rx(jrmt)/rmt)
      rdx=x/dx
      xx=rx(jrmt-1)**3
      xxmt=xx*dxx
      sumh=0.5*x*(rdx*xx*vh(jrmt-1)+(2.-rdx)*xxmt*vh(jrmt))
      sume=0.5*x*(rdx*xx*vs(jrmt-1)+(2.-rdx)*xxmt*vs(jrmt))
      xx=xxmt
      jrw=jrws-1
      if (jrmt .eq. jrw) goto 20
      vh1=ddx*xx*vh(jrmt)
      vx1=ddx*xx*vs(jrmt)
      jrm=jrmt+1
      do 10 j = jrm, jrw
        xx=xx*dxx
        vh2=ddx*xx*vh(j)
        vx2=ddx*xx*vs(j)
        sumh=sumh+vh1+vh2
        sume=sume+vx1+vx2
        vh1=vh2
   10   vx1=vx2
   20 x=alog(rws/rx(jrw))
      rdx=x/dx
      xxws=xx*dxx
      sumh=sumh+0.5*x*((2.-rdx)*xx*vh(jrw)+rdx*xxws*vh(jrws))
      sume=sume+0.5*x*((2.-rdx)*xx*vs(jrw)+rdx*xxws*vs(jrws))
      c=3./(rws*rws*rws-rmt*rmt*rmt)
      vhar=c*sumh
      vex=c*sume
      vint=vhar+vex
      write (11,30) vhar, vex, vint
      return

   30 format (///'muffin-tin zero by spherical average',/' average hartr
     &ee potential: ',6x,f14.5,5x,'average exchange potential: ',f12.5,/
     &'muffin-tin zero: ',f12.5)
      end