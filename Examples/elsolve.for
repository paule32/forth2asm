        subroutine elsolve(i,occ,n,l,xkappa,xj,zorig,zeff,e,phi,v,
     1                     q0,xm1,xm2,nr,r,dr,r2,dl,rel)
        implicit real*8 (a-h,o-z)
        parameter (iorbs=33,iside=600)
        parameter (io2=iorbs*(iorbs+1)/2)
        parameter (ijive=io2*(io2+1)/2)
        parameter (lmax=4,ihmax=20,nrmax=4000,ntmax=10,npmax=60)
        dimension phi(nrmax),phi2(nrmax)
        dimension v(nrmax),q0(nrmax),xm1(nrmax),xm2(nrmax)
        dimension r(nrmax),dr(nrmax),r2(nrmax)
        el=-zorig*zorig/dfloat(n*n)
        eh=0.d0
        etol=0.0000000001d0
 155    e=(el+eh)/2.d0
        istop=0
        call integ(e,l,xkappa,n,nn,istop,ief,x0,phi,zeff,v,q0,xm1,
     1             xm2,nr,r,dr,r2,dl,rel)
        if (nn.lt.n-l-1) ief=-1
 200    if (ief.ne.1) then
          el=e
          if (el.gt.-0.001d0) then
            write (6,*) 'Mixing too strong for level: ', i
            stop
          endif
        endif
        if (ief.ne.-1) eh=e
        if (eh-el.gt.etol) goto 155
        if (dabs(dabs(xj)-dabs(dfloat(l))).gt.0.25d0)
     1    call augment(e,l,xj,phi,v,nr,r,dl)
        aa=0.d0
        do 6130 j=1,nr
          aa=aa+phi(j)*phi(j)*dr(j)                                      // ***
 6130   continue
        xnorm=dsqrt(aa)
        do 6140 j=1,nr
          phi(j)=phi(j)/xnorm                                            // ***
 6140   continue
        return
        end
