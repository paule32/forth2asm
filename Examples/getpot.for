        subroutine getpot(etot,nst,rel,alfa,dl,nr,dr,r,r2,
     1                    xntot,phe,ratio,orb,occ,is,
     2                    nel,nl,nm,no,xnj,rpower,xnum,etot2,iuflag)
        implicit real*8 (a-h,o-z)
        parameter (iorbs=33,iside=600)
        parameter (io2=iorbs*(iorbs+1)/2)
        parameter (ijive=io2*(io2+1)/2)
        parameter (lmax=4,ihmax=20,nrmax=4000,ntmax=10,npmax=60)
        dimension dr(nrmax),r(nrmax),r2(nrmax)
        dimension phe(nrmax,iorbs),occ(iorbs)
        dimension is(iorbs),orb(nrmax,iorbs),nl(iorbs)
        dimension nm(iorbs),xnj(iorbs),no(iorbs)
        dimension rpower(nrmax,0:15)
        dimension xq1(nrmax),xq2(nrmax),xq0(nrmax)
        dimension cg(0:6,0:6,0:12,-6:6,-6:6),pin(0:8,0:8,0:16)
        dimension xqj0(nrmax),xqj1(nrmax)
        dimension xqj2(nrmax),xqi0(nrmax)
        dimension xqi1(nrmax),xqi2(nrmax),rsp(2)

        call clebschgordan(nel,nl,cg)
        call getillls(pin)

        ratio1=1.d0-ratio
        do 2100 i=1,nel
          do 2100 k=1,nr
            orb(k,i)=ratio1*orb(k,i)                                     // ***
 2100   continue

        do 2990 i=1,nel

          li=nl(i)
          mi=nm(i)

          jstart=i+1
          if ((xnj(i).lt.0.d0).or.
     1        (occ(i).gt.1.d0).or.
     2        (dabs(alfa).gt.0.001d0)) jstart=i
          do 2990 j=jstart,nel

            if ((occ(i).eq.0.d0).and.(occ(j).eq.0.d0)) goto 2990

            lj=nl(j)
            mj=nm(j)

c  direct coulomb

            lmx=2*li
            if (li.gt.lj) lmx=2*lj

c  l=0 is monopole or spherical term for direct coulomb.  Therefore,
c  when we have occ(i) or occ(j) greater than one, set lmx=0.

            if ((occ(i).gt.1.d0).or.(occ(j).gt.1.d0).or.
     1        (xnj(i).lt.0.d0).or.(xnj(j).lt.0.d0)) lmx=0

            do 2550 la=lmx,0,-2
              lap=la+1
          coeff=dfloat((li+li+1)*(lj+lj+1))/dfloat((la+la+1))**2.d0*
     1          cg(li,li,la,mi,-mi)*cg(lj,lj,la,mj,-mj)*
     2          cg(li,li,la,0 , 0 )*cg(lj,lj,la,0 , 0 )
              if (mi+mj.ne.2*((mi+mj)/2)) coeff=-coeff
              if (i.eq.j) coeff=coeff/2.d0
              coeffi=occ(i)*coeff
              coeffj=occ(j)*coeff
              ri=ratio*coeffi
              rj=ratio*coeffj
              rc=coeff*occ(i)*occ(j)

              xouti=0.d0
              xoutj=0.d0
              do 2500 k=1,nr
                xqi0(k)=dr(k)*phe(k,i)*phe(k,i)/2.d0                     // ***
                xqi1(k)=xqi0(k)*rpower(k,la)                             // ***
                if (rpower(k,lap).ne.0.d0) then                          // ***
                  xqi2(k)=xqi0(k)/rpower(k,lap)                          // ***
                else
                  xqi2(k)=0.d0
                endif
                xouti=xouti+xqi2(k)                                      // ***
                xqj0(k)=dr(k)*phe(k,j)*phe(k,j)/2.d0                     // ***
                xqj1(k)=xqj0(k)*rpower(k,la)                             // ***
                if (rpower(k,lap).ne.0.d0) then                          // ***
                  xqj2(k)=xqj0(k)/rpower(k,lap)                          // ***
                else
                  xqj2(k)=0.d0
                endif
                xoutj=xoutj+xqj2(k)                                      // ***
 2500         continue

              xinti=xqi1(1)
              xintj=xqj1(1)
              xouti=2.d0*xouti-xqi2(1)
              xoutj=2.d0*xoutj-xqj2(1)

              do 2550 k=2,nr

                xinti=xinti+xqi1(k)+xqi1(k-1)                            // ***
                xouti=xouti-xqi2(k)-xqi2(k-1)                            // ***
                vali=xouti*rpower(k,la)                                  // ***
                if (rpower(k,lap).ne.0.d0) vali=vali+xinti/rpower(k,lap) // ***
                orb(k,j)=orb(k,j)+ri*vali                                // ***

                xintj=xintj+xqj1(k)+xqj1(k-1)                            // ***
                xoutj=xoutj-xqj2(k)-xqj2(k-1)                            // ***
                valj=xoutj*rpower(k,la)                                  // ***
                if (rpower(k,lap).ne.0.d0) valj=valj+xintj/rpower(k,lap) // ***
                orb(k,i)=orb(k,i)+rj*valj                                // ***

                etot=etot+rc*(xqi0(k)*valj+xqj0(k)*vali)                 // ***

 2550       continue

            if ((is(i).ne.is(j)).and.
     1          (occ(i).le.1.d0).and.
     2          (occ(j).le.1.d0).and.
     3          (xnj(i).ge.0.d0).and.
     4          (xnj(j).ge.0.d0)     ) goto 2990
            if (dabs(alfa).ge.0.001d0) goto 2990

c  exchange interaction

           lmx=li+lj
           lmin=iabs(mi-mj)
           if ((occ(i).gt.1.d0).or.(occ(j).gt.1.d0).or.
     1        (xnj(i).lt.0.d0).or.(xnj(j).lt.0.d0)) lmin=0
           do 2980 la=lmx,lmin,-2
             lap=la+1

        coeff=dfloat((li+li+1)*(lj+lj+1))/dfloat((la+la+1))**2.d0*
     1               (cg(li,lj,la,-mi,mj)*cg(li,lj,la,0,0))**2.d0
        if ((occ(i).gt.1.d0).or.(occ(j).gt.1.d0).or.
     1      (xnj(i).lt.0.d0).or.(xnj(j).lt.0.d0))
     2     coeff=pin(li,lj,la)/4.d0
              if (i.eq.j) coeff=coeff/2.d0
              coeffi=occ(i)*coeff
              coeffj=occ(j)*coeff
              ri=ratio*coeffi
              rj=ratio*coeffj
              rc=coeff*occ(i)*occ(j)
              xnum2=xnum*xnum

              xout=0.d0
              do 2600 k=1,nr
                xq0(k)=dr(k)*phe(k,i)*phe(k,j)/2.d0                      // ***
                xq1(k)=xq0(k)*rpower(k,la)                               // ***
                if (rpower(k,lap).ne.0.d0) then                          // ***
                  xq2(k)=xq0(k)/rpower(k,lap)                            // ***
                else
                  xq2(k)=0.d0
                endif
                xout=xout+xq2(k)                                         // ***
 2600         continue
              xint=xq1(1)
              xout=2.d0*xout-xq2(1)
              do 2610 k=2,nr
                xint=xint+xq1(k)+xq1(k-1)                                // ***
                xout=xout-xq2(k)-xq2(k-1)                                // ***
                if (xq0(k).ne.0.d0) then                                 // ***
                  val=xout*rpower(k,la)                                  // ***
                  if (rpower(k,lap).ne.0.d0) val=val+xint/rpower(k,lap)  // ***
                  etot=etot-2.d0*xq0(k)*rc*val                           // ***
                  xx=phe(k,j)/phe(k,i)                                   // ***
                  if (dabs(xx)/xnum.gt.1.d0) then                        // ***
                    orb(k,i)=orb(k,i)-rj*xnum2/xx*val                    // ***
                  else
                    orb(k,i)=orb(k,i)-rj*xx*val
                  endif
                  xx=phe(k,i)/phe(k,j)                                   // ***
                  if (dabs(xx)/xnum.gt.1.d0) then                        // ***
                    orb(k,j)=orb(k,j)-ri*xnum2/xx*val                    // ***
                  else
                    orb(k,j)=orb(k,j)-ri*xx*val                          // ***
                  endif
                endif
 2610         continue

c Alternative
c savings:
c *: 2 + 2 from 8
c /: 2 + 1 from 7
c              rjxnum2 = rj * xnum2
c              rixnum2 = ri * xnum2
c              etotpart = 0
c              xnumover = 1.0d0 / xnum
c              do 2610 k=2,nr
c                xint=xint+xq1(k)+xq1(k-1)
c                xout=xout-xq2(k)-xq2(k-1)
c                if (xq0(k).ne.0.d0) then
c                  val=xout*rpower(k,la)
c                  if (rpower(k,lap).ne.0.d0) val=val+xint/rpower(k,lap)
c                  etotpart = etotpart - xq0(k) * val
c                  xx = phe(k,i) / phe(k,j)
c                  if (dabs(xx) .lt. xnumover) then
c                    orb(k,i) = orb(k,i) - rjxnum2 * xx * val
c                  else
c                    orb(k,i) = orb(k,i) - rj / xx * val
c                  endif
c                  if (dabs(xx) .gt. xnum) then
c                    orb(k,j) = orb(k,j)- rixnum2 /xx*val
c                  else
c                    orb(k,j) = orb(k,j)-ri*xx*val
c                  endif
c                endif
c 2610         continue
c              etot = etot + 2.0d0 * etotpart * rc

 2980      continue

 2990   continue
c
c  here we compute the charge density, if needed, for treating
c  exchange/correlation in a local fashion...
c
        if (dabs(alfa).ge.0.001d0) then
          if (alfa.gt.0.d0) then
            fx=1.0d0
            fc=1.0d0
          else
            fx=1.5d0*dabs(alfa)
            fc=0.0d0
          endif
c
c  note: we don't deal with spin-polarization in local exchange
c  picture, since local exchange is totally wrong for such
c  effects, anyway.  local exchange pretends charge density
c  is paramagnetic.  also, local exchange treats everything
c  as spherical.
c
          fourpi=16.d0*datan(1.d0)
          do 5000 i=1,nr
            xn=0.d0
            do 3200 j=1,nel
              xn=xn+phe(i,j)*phe(i,j)*occ(j)
 3200       continue
            xn1=xn/2.d0
            xn2=xn/2.d0
            nst=2
            call exchcorr(nst,rel,r2(i),xn1,xn2,ex,ec,ux1,ux2,uc1,uc2)
            exc=fx*ex +fc*ec
            uxc=fx*ux1+fc*uc1
            etot=etot+dr(i)*xn*exc
            do 3300 j=1,nel
              orb(i,j)=orb(i,j)+uxc*ratio
 3300       continue
 5000     continue
        endif
c
        do 9000 i=1,nr
        if (iuflag.ne.0) then
          jj=1
 8960     ii=jj
 8965     if (ii.eq.nel) goto 8970
          icond=0
          if ((no(jj).eq.no(ii+1)).and.(nl(jj).eq.nl(ii+1))
     1      .and.(iuflag.eq.2)) icond=1
          if ((no(jj).eq.no(ii+1)).and.(nl(jj).eq.nl(ii+1))
     1      .and.(is(jj).eq.is(ii+1)).and.(iuflag.eq.1)) icond=1
          if (icond.eq.1) then
            ii=ii+1
            goto 8965
          endif
 8970     orba=0.d0
          div=0.d0
          do 8980 k=jj,ii
            div=div+occ(k)
            orba=orba+orb(i,k)*occ(k)
 8980     continue
          if (div.ne.0.d0) then
            orba=orba/div
            do 8990 k=jj,ii
              orb(i,k)=orba
 8990       continue
          endif
          if (ii.ne.nel) then
            jj=ii+1
            goto 8960
          endif
        endif
 9000   continue
        return
        end
