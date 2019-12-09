c-----------------------------------------------------------------------
        subroutine atsolve(etot,nst,rel,alfa,eerror,nfc,
     1                     nr,r,dr,r2,dl,
     2          phe,njrc,vi,zorig,xntot,nel,no,nl,nm,xnj,ev,occ,is,ek,
     3                     ratio,orb,rpower,xnum,etot2,iuflag)
        implicit real*8 (a-h,o-z)
        parameter (iorbs=33,iside=600)
        parameter (io2=iorbs*(iorbs+1)/2)
        parameter (ijive=io2*(io2+1)/2)
        parameter (lmax=4,ihmax=20,nrmax=4000,ntmax=10,npmax=60)
        dimension r(nrmax),dr(nrmax),r2(nrmax),v(nrmax)
        dimension no(iorbs),nl(iorbs),nm(iorbs),xnj(iorbs)
        dimension ek(iorbs),ev(iorbs),occ(iorbs),is(iorbs)
        dimension phe(nrmax,iorbs),njrc(4),vi(nrmax,7)
        dimension q0(nrmax),xm1(nrmax),xm2(nrmax),orb(nrmax,iorbs)
        dimension rpower(nrmax,0:15)

c possible hotspots as derived from FCAT marked with // ***

c  initialize eerror, the biggest change in an eigenvalue, and etot.

        eerror=0.d0
        etot=0.d0

c  run through all the orbitals.  calculate those not in the core.

        do 102 i=1,nel

          if (i.gt.nfc) then

            idoflag=1
            call setqmm(i,orb,nl(i),is(i),idoflag,v,zeff,zorig,rel,
     1                  nr,r,r2,dl,q0,xm1,xm2,njrc,vi)

            xkappa=-1.d0
            if (dabs(xnj(i)).gt.dfloat(nl(i))+0.25d0) xkappa=-nl(i)-1
            if (dabs(xnj(i)).lt.dfloat(nl(i))-0.25d0) xkappa= nl(i)

            call elsolve(i,occ(i),no(i),nl(i),xkappa,xnj(i),zorig,zeff,
     1                   evi,phe(1,i),v,q0,xm1,xm2,nr,r,dr,r2,dl,rel)
            if (dabs(ev(i)-evi).gt.eerror) eerror=dabs(ev(i)-evi)
            ev(i)=evi

            ekk=0.d0
            ll=2
            do 100 j=nr,1,-1
              dq=phe(j,i)*phe(j,i)                                       // ***
              ekk=ekk+(evi-orb(j,i))*dr(j)*dq*dfloat(ll)/3.d0            // ***
              ll=6-ll                                                    // ***
 100        continue
            ek(i)=ekk

          endif

c  add the kinetic to total, including the frozen core kinetic energy.

          etot=etot+ek(i)*occ(i)
 102    continue
        call getpot(etot,nst,rel,alfa,dl,nr,dr,r,r2,xntot,
     1              phe,ratio,orb,occ,is,nel,nl,nm,no,xnj,rpower,xnum,
     2              etot2,iuflag)
        return
        end
