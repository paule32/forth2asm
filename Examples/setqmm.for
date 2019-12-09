        subroutine setqmm(i,orb,l,ns,idoflag,v,zeff,zorig,rel,
     1                    nr,r,r2,dl,q0,xm1,xm2,njrc,vi)
        implicit real*8 (a-h,o-z)
        parameter (iorbs=33,iside=600)
        parameter (io2=iorbs*(iorbs+1)/2)
        parameter (ijive=io2*(io2+1)/2)
        parameter (lmax=4,ihmax=20,nrmax=4000,ntmax=10,npmax=60)
        dimension v(nrmax),r(nrmax),r2(nrmax),orb(nrmax,iorbs)
        dimension q0(nrmax),xm1(nrmax),xm2(nrmax),njrc(4),vi(nrmax,7)

        c=137.038d0
        alpha=rel/c
        aa=alpha*alpha
        a2=aa/2.d0

        lp=l+1
        lpx=lp
        if (lp.gt.4) lpx=4
        lp2=l+l+1
        if (lp2.gt.7) lp2=7
        zeff=zorig
        if (njrc(lpx).gt.0) zeff=0.d0
        zaa=zeff*aa
        za2=zeff*a2

        if (idoflag.ne.0) then
          if (njrc(lpx).eq.0) then
            if (idoflag.eq.1) then
              do 55 j=1,nr
                v(j)=-zeff/r(j)+orb(j,i)                                 // ***
 55           continue
            endif
            do 65 j=2,nr-1
              dvdl=(orb(j+1,i)-orb(j-1,i))/(2.d0*dl)                     // ***
              ddvdrr=((orb(j+1,i)                                        // ***
     1               +orb(j-1,i)-2.d0*orb(j,i) )/(dl*dl)-dvdl)/r2(j)     // ***
              xm1(j)=-a2*dvdl/r(j)-za2/r2(j)                             // ***
              xm2(j)=-a2*ddvdrr+zaa/r2(j)/r(j)                           // ***
 65         continue
            xm1(nr)=xm1(nr-1)
            xm2(nr)=xm2(nr-1)
            xm1(1)=xm1(2)+za2/r2(2)-za2/r2(1)
            xm2(1)=xm2(2)-zaa/r2(2)/r(2)+zaa/r2(1)/r(1)
          else
            if (idoflag.eq.1) then
              do 75 j=1,nr
                v(j)=vi(j,lp2)+orb(j,i)
 75           continue
            endif
            do 85 j=2,nr-1
              dvdl=(v(j+1)-v(j-1))/(2.d0*dl)
              ddvdrr=((v(j+1)+v(j-1)-2.d0*v(j))/(dl*dl)-dvdl)/r2(j)
              xm1(j)=-a2*dvdl/r(j)
              xm2(j)=-a2*ddvdrr
 85         continue
            xm1(nr)=xm1(nr-1)
            xm2(nr)=xm2(nr-1)
            xm1(1)=xm1(2)
            xm2(1)=xm2(2)
          endif
        endif

c  figure the (Desclaux-Numerov) effective potential.

        xlb=(dfloat(l)+0.5d0)**2.d0/2.d0
        do 45 j=1,nr
          vj=v(j)                                                        // ***
          q0(j)=vj*(1.d0-a2*vj)+xlb/r2(j)                                // ***
 45     continue

        return

        end
