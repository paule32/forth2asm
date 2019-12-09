c ------------------------------------------------------------
      subroutine sumax (acc, chi, rx, nx, ncon, ia, na, ad, imax, ngrid,
     &                  nr)
!  routine to perform the summation of contributions from
!  neighbouring atoms (eq. 3.22,3.26,3.28).  integration by
!  trapezium rule on radial grid  rx(i)=exp(-8.8+0.05(i-1))

      dimension acc(ngrid), chi(ngrid,nr), rx(ngrid), nx(nr), ia(ncon)
      dimension na(ncon), ad(ncon)
      double precision sum

      index(x)=20.*(alog(x)+8.8)+2.
      dx=0.05
      ddx=0.5*dx
      dxx=exp(2.*dx)
      ic=ia(1)
      do 10 i = 1, imax
   10   acc(i)=chi(i,ic)
      do 40 ja = 2, ncon
        ic=ia(ja)
        nix=nx(ic)
        do 40 i = 1, imax
        sum=0.0d0
        x1=abs(rx(i)-ad(ja))
        ix1=index(x1)
        if (ix1 .gt. nix) goto 40
        dx1=alog(rx(ix1)/x1)
        rdx1=dx1/dx
        x2=amin1((rx(i)+ad(ja)),rx(nix))
        ix2=min0(index(x2),nix)
        dx2=alog(rx(ix2)/x2)
        rdx2=dx2/dx
        xx=rx(ix2-1)**2
        xx1=xx*dxx
        if (ix1 .eq. ix2) goto 30
        sum=sum+0.5*dx2*((2.-rdx2)*xx*chi(ix2-1,ic)+rdx2*xx1*chi(ix2,ic)
     &   )
        xx=rx(ix1-1)**2
        xx1=xx*dxx
        sum=sum+0.5*dx1*(rdx1*xx*chi(ix1-1,ic)+(2.-rdx1)*xx1*chi(ix1,ic)
     &   )
        ix1=ix1+1
        if (ix1 .eq. ix2) goto 40
        xx=xx1
        t1=ddx*xx*chi(ix1,ic)
        ix2=ix2-1
        do 20 ix = ix1, ix2
          xx=xx*dxx
          t2=ddx*xx*chi(ix,ic)
          sum=sum+t1+t2
   20     t1=t2
        goto 40
   30   sum=0.5*(dx2-dx1)*((rdx1+rdx2)*xx*chi(ix1-1,ic)+(2.-rdx1-rdx2)*
     &   xx1*chi(ix1,ic))
   40   acc(i)=acc(i)+0.5*sum*float(na(ja))/(ad(ja)*rx(i))
      return
      end
