        subroutine integ(e,l,xkappa,n,nn,istop,ief,x0,phi,z,v,q0,xm1,
     1                   xm2,nr,r,dr,r2,dl,rel)
        implicit real*8 (a-h,o-z)
        parameter (iorbs=33,iside=600)
        parameter (io2=iorbs*(iorbs+1)/2)
        parameter (ijive=io2*(io2+1)/2)
        parameter (lmax=4,ihmax=20,nrmax=4000,ntmax=10,npmax=60)
        dimension phi(nrmax),v(nrmax)
        dimension q0(nrmax),xm1(nrmax),xm2(nrmax)
        dimension r(nrmax),dr(nrmax),r2(nrmax)
        dl2=dl*dl/12.d0
        dl5=10.d0*dl2
        c=137.038d0
        alpha=rel/c
        za2=z*z*alpha*alpha
        a2=alpha*alpha/2.d0
        xl=l
        xlp=l+1
        xl2=0.5d0+xl
        xl4=xl2*xl2

c  then, we set up the leading power.
c  adjust for Desclaux's implementation of Numerov.

        if (rel.eq.0.d0) then
          ss=xlp
        else
          rtest=1.d0-za2
          if (rtest.lt.0.d0) then
            write (6,*) 'z > 137 is too big.'
            stop
          endif
          ss=dsqrt(rtest)
        endif
        ss2=ss-0.5d0

c  we shall set ief to -1 if energy is too low, +1 if too high.

        ief=0

c  see Desclaux and documentation to see the origin of the below equations.
c  here, we set up the first two points.

        t=e-v(1)
        xm0=1.d0+a2*t
        tm=xm0+xm0
        xmx=xm1(1)/xm0
        xk0=r2(1)*(tm*t-xmx*(xkappa/r(1)+0.75d0*xmx)+xm2(1)/tm)-xl4
        dk0=1.d0+dl2*xk0
        p0=dk0
        phi(1)=p0*dsqrt(xm0*r(1))/dk0

        t=e-v(2)
        xm=1.d0+a2*t
        tm=xm+xm
        xmx=xm1(2)/xm
        xk2=r2(2)*(tm*t-xmx*(xkappa/r(2)+0.75d0*xmx)+xm2(2)/tm)-xl4
        dk2=1.d0+dl2*xk2
        p1=dk2*((r(2)/r(1))**ss2-(r(2)-r(1))*z/xlp)*dsqrt(xm0/xm)
        phi(2)=p1*dsqrt(xm*r(2))/dk2

c  if istop is set, the we know to stop there.  If it is zero, it shall
c  then be set to the classical turning point.

        is0=istop
        if (istop.eq.0) then
          do 10 j=nr-1,2,-1
            if (e.gt.v(j)) goto 15                                       // ***
 10       continue
          ief=-1
          return
 15       istop=j
        endif

c  initialize number of nodes, and determine the ideal number.

        nn=0
        nnideal=n-l-1

c  integrate out.  count nodes, and stop along the way if there are too many.

        do 50 i=3,istop+2
          ri = r(i)
          t=e-v(i)
          xm=1.d0+a2*t
          tm=xm+xm
          xmx=xm1(i)/xm
          p2=(2.d0-dl5*xk2)*p1 * dk2 -p0
          xk2=r2(i)*(tm*t-xmx*(xkappa/ ri +0.75d0*xmx)+xm2(i)/tm)-xl4    // ****
          dk2=1.0d0 / (1.d0+dl2*xk2)
          phi(i)=p2*dsqrt(xm* ri ) * dk2                                   // ****
          if (dabs(p2).gt.10000000000.d0) then
            p2over = 1 / p2
            do 20 j=1,i
              phi(j)=phi(j) * p2over
 20         continue
            p0=p0 * p2over
            p1=p1 * p2over
            p2 = 1.0d0
          endif
          if (p2*p1.lt.0.d0) then
            nn=nn+1
            if (nn.gt.nnideal) then
              ief=1
              return
            endif
          endif
          p0=p1
          p1=p2
 50     continue

        if (istop.gt.0) then
          psip2=(phi(istop+2)-phi(istop-2))
          psip1=(phi(istop+1)-phi(istop-1))
          psip=(8.d0*psip1-psip2)/(12.d0*dl*r(istop))
          x0=psip/phi(istop)
        endif

        if (is0.ne.0) return

        do 150 i=istop+3,nr-1
          t=e-v(i)                                                       // ***
          xm=1.d0+a2*t                                                   // ***
          tm=xm+xm                                                       // ***
          xmx=xm1(i)/xm                                                  // ***
          p2=(2.d0-dl5*xk2)*p1/dk2-p0                                    // ***
          if (p2/p1.gt.1.d0) then                                        // ***
            ief=-1
            return
          endif
          xk2=r2(i)*(tm*t-xmx*(xkappa/r(i)+0.75d0*xmx)+xm2(i)/tm)-xl4    // ***
          dk2=1.d0+dl2*xk2                                               // ***
          phi(i)=p2*dsqrt(xm*r(i))/dk2                                   // ***
          if (dabs(p2).gt.10000000000.d0) then                                       // ***
            do 120 j=1,i
              phi(j)=phi(j)/p2
 120        continue
            p0=p0/p2
            p1=p1/p2
            p2=p2/p2
          endif
          if (p2*p1.lt.0.d0) then                                        // ***
            nn=nn+1
            if (nn.gt.nnideal) then
              ief=1
              return
            endif
          endif
          p0=p1                                                          // ***
          p1=p2                                                          // ***
 150    continue
        return
        end
