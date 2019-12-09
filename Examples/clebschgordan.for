c-----------------------------------------------------------------------
c  routine to generate Clebsch-Gordan coefficients, in the form of
c  cg(l1,l2,L,m1,m2) = <l1,m1;l2,m2|L,m1+m2>, according to Rose's
c  'Elementary Theory of Angular Momentum', p. 39, Wigner's formula.
c  those coefficients listed are only those for which l1.ge.l2.
c  coefficients known to be zero because of either the L or M
c  selection rules are not computed, and should not be sought.

        subroutine clebschgordan(nel,nl,cg)

        implicit real*8 (a-h,o-z)
        parameter (iorbs=33,iside=600)
        parameter (io2=iorbs*(iorbs+1)/2)
        parameter (ijive=io2*(io2+1)/2)
        parameter (lmax=4,ihmax=20,nrmax=4000,ntmax=10,npmax=60)
        dimension nl(iorbs)
        dimension cg(0:6,0:6,0:12,-6:6,-6:6),si(0:32),fa(0:32)

        lmx=0
        do i=1,nel
          if (nl(i).gt.lmx) lmx=nl(i)
        enddo

        si(0)=1.d0
        fa(0)=1.d0
        do i=1,32
          si(i)=-si(i-1)
          fa(i)=dfloat(i)*fa(i-1)
        enddo

        do 100 l1=0,lmx
        do 100 l2=0,l1
 52     format (1x,i3,a3,i3)
        do 100 m1=-l1,l1
        do 100 m2=-l2,l2
        m3=m1+m2
        lmin=iabs(l1-l2)
        if (lmin.lt.iabs(m3)) lmin=iabs(m3)
        do 100 l3=lmin,l1+l2
        prefactor=dfloat(2*l3+1)
        prefactor=prefactor*fa(l3+l1-l2)/fa(l1+l2+l3+1)
        prefactor=prefactor*fa(l3-l1+l2)/fa(l1-m1)
        prefactor=prefactor*fa(l1+l2-l3)/fa(l1+m1)
        prefactor=prefactor*fa(l3+m3)/fa(l2-m2)
        prefactor=prefactor*fa(l3-m3)/fa(l2+m2)
        prefactor=dsqrt(prefactor)
        sum=0.d0
        numax=l3-l1+l2
        if ((l3+m3).lt.numax) numax=l3+m3
        numin=0
        if (l1-l2-m3.lt.numin) numin=-(l1-l2-m3)
        do nu=numin,numax
          sum=sum+(si(nu+l2+m2)/fa(nu))*fa(l2+l3+m1-nu)*fa(l1-m1+nu)
     1            /fa(l3-l1+l2-nu)/fa(l3+m3-nu)/fa(nu+l1-l2-m3)
        enddo
        cg(l1,l2,l3,m1,m2)=prefactor*sum
        cg(l2,l1,l3,m2,m1)=si(l1+l2+l3)*prefactor*sum
 100    continue

        return
        end
