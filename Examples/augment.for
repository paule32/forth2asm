        subroutine augment(e, l, xj, phi, v, nr, r, dl)
        implicit real*8 (a-h, o-z)
        parameter (nrmax = 4000)
        dimension phi(nrmax), phi2(nrmax), v(nrmax), r(nrmax)
        c = 137.038d0
        cc = c * c
        c2 = cc + cc
        xkappa = -1
        if (dabs(xj) .gt. dfloat(l) + 0.25d0) xkappa = -l-1
        if (dabs(xj) .lt. dfloat(l) - 0.25d0) xkappa =  l
        do j = 4, nr - 3
          if (phi(j) .ne. 0.d0) then                                     // ***
            g0 =  phi(j)                                                 // ***
            ga = (phi(j + 1) - phi(j - 1))                               // ***
            gb = (phi(j + 2) - phi(j - 2)) / 2.d0                        // ***
            gc = (phi(j + 3) - phi(j - 3)) / 3.d0                        // ***
            gg = ((1.5d0 * ga - 0.6d0 * gb + 0.1d0 * gc)                 // ***
     1            / (2.d0 * dl) + xkappa * g0) / r(j)                    // ***
            f0 = c * gg / (e - v(j) + c2)                                // ***
            phi2(j) = dsqrt(g0 * g0 + f0 * f0)                           // ***
            if (g0 .lt. 0.d0) phi2(j) = -phi2(j)                         // ***
          else
            phi2(j) = phi(j)                                             // ***
          endif
         enddo
c Alternative
c saves 3 '/' out of 5, 1 '*' out of 8, 1 '+' and one reference to phi(j)
c        dlover = 0.75d0 / dl
c        ec2 = e + c2
c        do j = 4, nr - 3
c          if (phi(j) .ne. 0.d0) then
c            g0 =  phi(j)
c            ga = (phi(j + 1) - phi(j - 1))
c            gb = (phi(j + 2) - phi(j - 2)) * 0.20d0
c            gc = (phi(j + 3) - phi(j - 3)) * 0.0125d0
c            gg = ((ga - gb + gc) * dlover + xkappa * g0) / r(j)
c            f0 = c * gg / (ec2 - v(j))
c            phi2(j) = dsqrt(g0 * g0 + f0 * f0)
c            if (g0 .lt. 0.d0) phi2(j) = -phi2(j)
c          else
c            phi2(j) = 0.0d0
c          endif
c        enddo

        do j = 1, 3
          phi2(j) = phi(j) * phi(4) / phi2(4)
        enddo
        do j = 1,  nr
          phi(j) = phi2(j)                                               // ***
        enddo
        return
        end
