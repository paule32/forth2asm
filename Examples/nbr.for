c ------------------------------------------------------------
      subroutine nbr (ia, na, ad, ncon, nrr, nr, rc, rk, n, rmax, mc)
c  routine to supply nearest neighbour data for atoms in
c  a crystal structure, given
c  rc(i,j)  the i'th coordinate of the j'th axis of the unit cell
c  rk(i,j)  the i'th coordinate of the j'th atom in the unit cell
c  nrr(ir)  the number of type-ir atoms in the unit cell
c
c  The information returned, for a type-ir atom, is
c  ncon(ir) the number of nearest neighbour shells of a type-ir
c           atom included, out to a distance of rmax, but <= mc
c  ia(j,ir) the type of atoms in the j'th neighbouring shell
c  na(j,ir) the number of atoms in the j'th shell
c  ad(j,ir) the radius of the j'th shell initialisation

      dimension ia(mc,nr), na(mc,nr), ad(mc,nr), ncon(nr), nrr(nr)
      dimension rc(3,3), rk(3,n), rj(3)
      
      double precision as, ax, ay, az, r, dr

      rad(a1,a2,a3) = sqrt(a1*a1 + a2*a2 + a3*a3)
      rcmin = 1.0e6
      do i = 1, 3
        rcmin = amin1(rcmin, rad(rc(1,i), rc(2,i), rc(3,i)))
      end do
      ia = 0
      na = 0
      ad = 1.0e6
c  search over adjacent unit cells to include mc nearest neighbours
      itc = ifix(rmax / rcmin) + 1
      limc = itc + itc + 1
      as = -float(itc + 1)
      ax = as
      do 100 jx = 1, limc
        ax = ax + 1.0d0
        ay = as
        do 100 jy = 1, limc
        ay = ay + 1.0d0
        az = as
        do 100 jz = 1, limc
        az = az + 1.0d0
        do j = 1, 3
          rj(j) = ax*rc(j,1) + ay*rc(j,2) + az*rc(j,3)
        end do
c  rj is current unit cell origin. For each atom in this unit cell
c  find displacement r from kr-type atom in basic unit cell
        j = 0
        do 100 jr = 1, nr
          jnr = nrr(jr)
          do 100 jjr = 1, jnr
            j = j + 1
            k = 1
            do 90 kr = 1, nr
              r = rad(rj(1) + rk(1,j) - rk(1,k), 
     &                rj(2) + rk(2,j) - rk(2,k),
     &                rj(3) + rk(3,j) - rk(3,k))
              if (r > rmax) goto 90
c  compare r with nearest neighbour distances already found
              ic = 0
   40         ic = ic + 1
              if (ic > mc) goto 90
              dr = r - ad(ic,kr)
              if (abs(dr) < 1.0e-4) dr = 0.0d0
              if (dr) 60, 50, 40
   50         if (ia(ic,kr) /= jr) goto 40
              na(ic,kr) = na(ic,kr) + 1
              goto 90
   60         if (ic == mc) goto 80
              iic = ic + 1
              do jjc = iic, mc
                jc = mc + iic - jjc
                ia(jc,kr) = ia(jc - 1,kr)
                na(jc,kr) = na(jc - 1,kr)
                ad(jc,kr) = ad(jc - 1,kr)
              end do
   80         ia(ic,kr) = jr
            na(ic,kr) = 1
            ad(ic,kr) = r
   90       k = k + nrr(kr)
  100 continue
      do 120 ir = 1, nr
        ncon(ir) = 0
        do ic = 1, mc
          if (na(ic,ir) == 0) goto 120
          ncon(ir) = ncon(ir) + 1
        end do 
  120 continue
      return
      end
