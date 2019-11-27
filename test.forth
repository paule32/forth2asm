c -----------------------------------------------------------------------------
c  routine to supply nearest neighbour data for atoms in
c  a crystal structure, given
c
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
c -----------------------------------------------------------------------------

* this is a one-liner comment
* again as before

program HelloWorld
10

20

30

end

subroutine nbr (ia, na, ad, ncon, nrr, nr, rc, rk, n, rmax, mc)

    dimension ia(mc, nr), na()
c, na(mc,nr), nq( )

end
