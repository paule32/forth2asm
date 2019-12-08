        subroutine getillls(pin)
        implicit double precision (a-h,o-z)
        dimension fa(0:40),si(0:40),pin(0:8,0:8,0:16)

        fa(0)=1.d0
        si(0)=1.d0
        do i=1,32
          fa(i)=dfloat(i)*fa(i-1)
          si(i)=-si(i-1)
        enddo

        do 1000 l=0,8
        do 1000 m=0,8
        do 1000 n=m+l,0,-2
          xi=0.d0
          xf=2.d0/2.d0**dfloat(n+l+m)
          nn=(n+1)/2
          mm=(m+1)/2
          ll=(l+1)/2
          do 500 ia=nn,n
            af=si(ia)*fa(ia+ia)/fa(ia)/fa(n-ia)/fa(ia+ia-n)              // ***
            do 500 ib=ll,l
              bf=si(ib)*fa(ib+ib)/fa(ib)/fa(l-ib)/fa(ib+ib-l)            // ***
              do 500 ic=mm,m
                xcf=si(ic)*fa(ic+ic)/fa(ic)/fa(m-ic)/fa(ic+ic-m)         // ***
                xi=xi+xf*af*bf*xcf/dfloat(ia*2+ib*2+ic*2-n-l-m+1)        // ***
 500      continue
          pin(l,m,n)=xi
 1000   continue

        return

        end
