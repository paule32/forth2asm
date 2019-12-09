c ------------------------------------------------------------
      subroutine mtz (sig, rho, rx, ngrid, rmt, nrr, nx, nr, rc,
     &                rk, n, vhar, vex, alpha, av, nh)
!  subroutine for calculation of the muffin-tin zero level,
!  the average value of the potential between the muffin-tin
!  spheres in the unit cell

      dimension sig(ngrid,nr), rho(ngrid,nr), rx(ngrid)
      dimension rmt(nr), nrr(nr), nx(nr), vg(20), rc(3,3), rk(3,n)
      dimension x(3), rb(3)
      data pi, ng / 3.14159265358, 20 /

!  grid reference for radius on Loucks' mesh
      index(y) = 20.0 * (alog(y) + 8.8) + 1.0
      rad(a1,a2,a3) = sqrt(a1*a1 + a2*a2 + a3*a3)

      pd = 6.0 / pi / pi
      do ig = 1, ng
        vg(ig) = 0.0
      end do
      ig     = 0
      vhar   = 0.0
      vex    = 0.0
      npoint = 0
      nint   = 0
      dh     = 1.0 / float(nh)
   20 ah = dh / 2.0
      ax = -ah
      do 80 ix = 1, nh
        ax = ax + dh
        ay = -ah
        do 80 iy = 1, nh
        ay = ay + dh
        az = -ah
        do 80 iz = 1, nh
        az = az + dh
        do i = 1, 3
          x(i) = ax*rc(i,1) + ay*rc(i,2) + az*rc(i,3)
        end do
        npoint = npoint + 1
!  gives sample point x inside the unit cell - test whether
!  interstitial
        bx = -1.0
        do 50 jx = 1, 2
          bx = bx + 1.0
          by = -1.0
          do 50 jy = 1, 2
          by = by + 1.0
          bz = -1.0
          do 50 jz = 1, 2
          bz = bz + 1.0
          do i = 1, 3
            rb(i) = x(i) - bx*rc(i,1) - by*rc(i,2) - bz*rc(i,3)
          end do
          i = 0
          do 50 ir = 1, nr
            inr = nrr(ir)
            do 50 iir = 1, inr
              i = i + 1
              xr = rad(rb(1) - rk(1,i), rb(2) - rk(2,i), rb(3) - rk(3,i))
              if (xr .lt. rmt(ir)) goto 80
   50   continue
!  we have an interstitial point
        nint = nint + 1
!  sum Coulomb and exchange energies from atoms within 2 unit
!  cells around this point
        sumc = 0.0
        sume = 0.0
        bx = -3.0
        do 70 jx = 1, 5
          bx = bx + 1.0
          by = -3.0
          do 70 jy = 1, 5
          by = by + 1.0
          bz = -3.0
          do 70 jz = 1, 5
          bz = bz + 1.0
          do i = 1, 3
            rb(i) = bx*rc(i,1) + by*rc(i,2) + bz*rc(i,3) - x(i)
          end do
          j = 0
          do 70 jr = 1, nr
          jnr = nrr(jr)
          do 70 jjr = 1, jnr
          j = j + 1
          xr = rad(rb(1) + rk(1,j), rb(2) + rk(2,j), rb(3) + rk(3,j))
          j2 = index(xr)
          if (j2 .ge. nx(jr)) goto 70
          j1 = j2 - 1
          j3 = j2 + 1
          x1 = rx(j1)
          x2 = rx(j2)
          x3 = rx(j3)
          termc = (xr-x2)*(xr-x3)/(x1-x2)/(x1-x3)*sig(j1,jr) + 
     &            (xr-x1)*(xr-x3)/(x2-x1)/(x2-x3)*sig(j2,jr) +
     &            (xr-x2)*(xr-x1)/(x3-x2)/(x3-x1)*sig(j3,jr)
          terme = (xr-x2)*(xr-x3)/(x1-x2)/(x1-x3)*rho(j1,jr) +
     &            (xr-x1)*(xr-x3)/(x2-x1)/(x2-x3)*rho(j2,jr) +
     &            (xr-x2)*(xr-x1)/(x3-x2)/(x3-x1)*rho(j3,jr)
          sumc = sumc + termc
          sume = sume + terme
   70   continue

        if (sume .le. 1.e-8) then
          sume = .0
        else
          sume = -1.5 * alpha * (pd * sume)**(1. / 3.)
        end if
        vhar = vhar + sumc
        vex  = vex + sume
        jg = mod(ig,20) + 1
        vg(jg) = vg(jg) + sumc + sume
        ig = ig + 1
   80 continue
      dh = dh / 2.0
      nh = nh + nh
      if (nint .eq. 0) goto 20

      ant  = float(nint)
      vhar = vhar / ant
      vex  = vex / ant
      vint = vhar + vex
!  estimate standard deviation
      if (nint .lt. ng) ng = nint
      nag = nint / ng
      ag = float(nag)
      do ig = 1, ng
        vg(ig) = vg(ig) / ag
      end do
      var = 0.0
      do ig = 1, ng
        var = var + (vint - vg(ig))**2
      end do
      var = sqrt(var / float(ng - (ng - 1)))
!  the current Monte-Carlo volume for the interstitial region
!  is volc
      volc = ant / float(npoint) - av
!  volt is the true volume of the region between muffin-tin
!  spheres in the unit cell
      vm = 0.0
      do ir = 1, nr
        vm = vm + float(nrr(ir)) * rmt(ir)**3
      end do
      volt = av - 4.0 * pi * vm / 3.0

      write (11,120) nint, npoint, ng, nag, volt, volc
      write (11,130) vhar, vex, vint, var

      return
  120 format (///'muffin-tin zero calculation, sampling with',i6,' point
     &s from grid of',i6/' variance estimated from',i4,' groups of',i5//
     &' true volume of interstitial region: ',f11.4,5x,'Monte-Carlo volu
     &me: ',11x,f9.4)
  130 format (' average Hartree potential: ',6x,f14.5,5x,'average exchan
     &ge potential: ',f12.5/'muffin-tin zero: ',f12.5,10x,'standard devi
     &ation: ',f12.5)
      end
