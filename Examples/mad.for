c ------------------------------------------------------------
      subroutine mad (vmad, rx, ngrid, rmt, nrr, nx, nr, rc,
     &                rk, zm, n, av)
!  subroutine mad calculates the spherically and spatially averaged
!  fields from a lattice of point charges, and tabulates them on
!  a radial mesh rx, about each atomic type in the unit cell
!  ** nb this routine works in Hartrees, but converts to Rydbergs **
!  rc(i,j) = the i'th coordinate of the j'th axis of the unit cell
!  rk(i,j) = the i'th coordinate of the j'th atom in the unit cell
!  vmad(j,ir) = the j'th tabulated value of the spherically averaged
!                potential about a type-ir atom
!  zm(k)   = charge on the k'th atom
!  rmt(ir) = muffin-tin radius of a type-ir atom
!  nr      = number of inequivalent atoms in the cell
!  av      = volume of unit cell
!  g(i,j)  = i'th coordinate of the j'th reciprocal lattice vector
!  vmm(ir) = the integral of the potential about a type-ir atom
!            out to the muffin-tin radius

      dimension vmad(ngrid,nr), rx(ngrid), rc(3,3), rk(3,n), zm(n)
      dimension rmt(nr), nrr(nr), nx(nr)
      dimension g(3,3), vmm(5), fr(5), ra(3), ga(3)
      data pi, test / 3.1415926536, 1.0e-4 /

      rad(a1,a2,a3) = sqrt(a1*a1 + a2*a2 + a3*a3)

      do ir = 1, nr
        fr(ir) = 0.0
        do 10 j = 1, ngrid
          vmad(j,ir) = 0.0
        end do
      end do

!  the reciprocal lattice is defined by three vectors, g
      atv = 2.0 * pi / av
      g(1,1) = (rc(2,1)*rc(3,2)-rc(3,1)*rc(2,2))*atv
      g(2,1) = (rc(3,1)*rc(1,2)-rc(1,1)*rc(3,2))*atv
      g(3,1) = (rc(1,1)*rc(2,2)-rc(2,1)*rc(1,2))*atv

      g(1,2) = (rc(2,2)*rc(3,3)-rc(3,2)*rc(2,3))*atv
      g(2,2) = (rc(3,2)*rc(1,3)-rc(1,2)*rc(3,3))*atv
      g(3,2) = (rc(1,2)*rc(2,3)-rc(2,2)*rc(1,3))*atv

      g(1,3) = (rc(2,3)*rc(3,1)-rc(3,3)*rc(2,1))*atv
      g(2,3) = (rc(3,3)*rc(1,1)-rc(1,3)*rc(3,1))*atv
      g(3,3) = (rc(1,3)*rc(2,1)-rc(2,3)*rc(1,1))*atv

!  maximum value of rk, and minimum values of rc,g - prior to
!  choosing the separation constant al and limits for summations
      rkmax = 0.0
      do j = 1, n
        rkmax = amax1(rkmax, rad(rk(1,j), rk(2,j), rk(3,j)))
      end do
      rcmin = 1.0e6
      gmin = 1.0e6
      do j = 1, 3
        rcmin = amin1(rcmin, rad(rc(1,j), rc(2,j), rc(3,j)))
        gmin  = amin1(gmin,  rad( g(1,j),  g(2,j),  g(3,j)))
      end do
!  al is chosen to give equal numbers of terms in real and
!  reciprocal space summations
      fac1 = test*alog(test)**4
      fac2 = (4.0*pi*rcmin**4)/(av*gmin**4)
      al = exp(alog(fac1/fac2)/6.0)
      itr = 1 + ifix((al*rkmax-alog(test))/(al*rcmin))
      limr = itr + itr + 1
      fac1 = 4.0*pi*al*al/(av*gmin**4)
      itg = 1 + ifix(exp(alog(fac1/test)/4.0))
      limg = itg + itg + 1
      write (11,160) ((g(i,j), i = 1, 3), j = 1, 3)
      write (11,170) rcmin, gmin, rkmax, test, al

!  real space summation
      write (11,180) itr
!  the prefactors fr from the real space summation are calculated
      as = -float(itr)-1.0
      ax = as
      do 50 jx = 1, limr
        ax = ax + 1.0
        ay = as
        do 50 jy = 1, limr
        ay = ay + 1.0
        az = as
        do 50 jz = 1, limr
        az = az + 1.0
        do i = 1, 3
          ra(i) = ax*rc(i,1) + ay*rc(i,2) + az*rc(i,3)
        end do
        do 50 j = 1, n
        k = 1
        do 50 kr = 1, nr
        r = rad(ra(1) + rk(1,j) - rk(1,k),
     &          ra(2) + rk(2,j) - rk(2,k),
     &          ra(3) + rk(3,j) - rk(3,k))
        if (r .lt. 1.0e-4) goto 50
        fr(kr) = fr(kr) + zm(j) * exp(-al * r) / r
   50   k = k + nrr(kr)
      k = 1
      do kr = 1, nr
        x = rmt(kr)
        a = exp(-al*x)
        ai1 = ((1.0-a)/al-x*a)/al
        ai2 = (x*0.5*(1.0/a + a)-0.5*(1.0/a-a)/al)/al/al
        vmm(kr) = 4.0*pi*(zm(k)*ai1 + ai2*fr(kr))
        nix = nx(kr)
        do j = 1, nix
          x = rx(j)
          a = exp(al*x)
          vmad(j,kr) = fr(kr)*0.5*(a - 1.0/a)/(al*x) + zm(k)/(a*x)
        end do
        k = k + nrr(kr)
        end do
      write (11,190) (vmm(kr), kr = 1, nr)

!  next comes the summation in reciprocal space
      write (11,200) itg
      as = -float(itg)-1.0
      ax = as
      do 130 jx = 1, limg
        ax = ax + 1.0
        ay = as
        do 130 jy = 1, limg
        ay = ay + 1.0
        az = as
        do 130 jz = 1, limg
        az = az + 1.0
        do i = 1, 3
          ga(i) = ax*g(i,1) + ay*g(i,2) + az*g(i,3)
        end do
        gm = rad(ga(1), ga(2), ga(3))
        gs = gm*gm
        fac1 = 0.0
        if (gs .lt. 1.0e-4) goto 130
        fac1 = 4.0*pi*al*al/(av*gs*(gs + al*al))
        k = 1
        do 120 kr = 1, nr
          fac2 = 0.0
          do j = 1, n
            gr = 0.0
            do i = 1, 3
              gr = gr + ga(i) * (rk(i,k) - rk(i,j))
            end do
            fac2 = fac2 + cos(gr) * zm(j)
          end do
          x = rmt(kr)
          ai3 = (sin(gm*x)/gm - x*cos(gm*x))/gs
          vmm(kr) = vmm(kr) + 4.0*pi*ai3*fac1*fac2
          nix = nx(kr)
          do i = 1, nix
            x = rx(i)
            vmad(i,kr) = vmad(i,kr) + fac1*fac2*sin(gm*x)/(gm*x)
          end do
  120     k = k + nrr(kr)
  130 continue
      write (11,190) (vmm(kr), kr = 1, nr)
!  refer to muffin-tin zero
      vm = 0.0
      amt = 0.0
      do ir = 1, nr
        vm = vm + float(nrr(ir))*rmt(ir)**3
        amt = amt + float(nrr(ir)) * vmm(ir)
      end do
      amt = amt / (av - 4.0 * pi * vm / 3.0)
!  express the final potential in Rydbergs
      amt = -2.0 * amt
      write (11,210) amt
      do kr = 1, nr
        nix = nx(kr)
        do j = 1, nix
          vmad(j,kr) = 2.0 * vmad(j,kr) - amt
        end do
      end do
      return

  160 format (///'Madelung correction'//'reciprocal lattice'/(6x,3f8.4))
  170 format ('rcmin: ',f10.4,10x,'gmin: ',f10.4,10x,'rkmax: ',f10.4,
     &10x,'test: ',e12.4/' separation constant: ',e12.4)
  180 format ('real space summation',11x,'itr: ',i3)
  190 format (' vmm (Hartrees) : ',5e12.4)
  200 format ('reciprocal space summation',5x,'itg: ',i3)
  210 format ('Madelung muffin-tin zero: ',5e12.4)

      end