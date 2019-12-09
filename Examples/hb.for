        real*8 function hb(x,factor)
        implicit real*8 (a-h,o-z)
        if (x.gt.3.d0) hb=0.d0
        if (x.le.3.d0) hb=0.01d0**((dsinh(x/factor)/1.1752d0)**2.d0)
        return
        end
