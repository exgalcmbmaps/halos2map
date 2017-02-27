!-----------------------------------------------------------------------------
!
!  Copyright (C) 1997-2013 Krzysztof M. Gorski, Eric Hivon,
!                          Benjamin D. Wandelt, Anthony J. Banday, 
!                          Matthias Bartelmann, Hans K. Eriksen, 
!                          Frode K. Hansen, Martin Reinecke
!
!
!  This file is part of HEALPix.
!
!  HEALPix is free software; you can redistribute it and/or modify
!  it under the terms of the GNU General Public License as published by
!  the Free Software Foundation; either version 2 of the License, or
!  (at your option) any later version.
!
!  HEALPix is distributed in the hope that it will be useful,
!  but WITHOUT ANY WARRANTY; without even the implied warranty of
!  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!  GNU General Public License for more details.
!
!  You should have received a copy of the GNU General Public License
!  along with HEALPix; if not, write to the Free Software
!  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
!
!  For more information about HEALPix see http://healpix.jpl.nasa.gov
!
!-----------------------------------------------------------------------------
!--------------------------------------------------------------
!
! generic body of the subroutines convert_ring2nest_*_1d 
! to be inserted as is in pix_tools.f90
!
!--------------------------------------------------------------
    !=======================================================================
    !     makes the conversion RING to NEST
    !=======================================================================
    integer(kind=I4B), intent(in) :: nside
    integer(kind=I4B) :: ipn4, ipr4
    integer(kind=I8B) :: ipn8, ipr8, npix
    !=======================================================================

    npix = nside2npix(nside)
    call assert (npix>0,       code//": invalid Nside")

    allocate(map_tmp(0:npix-1)) ! bug correction, 2010-12-06

    if (nside <= ns_max4) then
!$OMP parallel default(none) &
!$OMP   shared(map, map_tmp, npix, nside) private(ipr4, ipn4)
!$OMP do schedule(dynamic,64)
       do ipr4 = 0_i4b, npix-1
          call ring2nest(nside, ipr4, ipn4)
          map_tmp(ipn4) = map(ipr4)
       enddo
!$OMP end do
!$OMP end parallel

    else

!$OMP parallel default(none) &
!$OMP   shared(map, map_tmp, npix, nside) private(ipr8, ipn8)
!$OMP do schedule(dynamic,64)
       do ipr8 = 0_i8b, npix-1
          call ring2nest(nside, ipr8, ipn8)
          map_tmp(ipn8) = map(ipr8)
       enddo
!$OMP end do
!$OMP end parallel
       
    endif

    map = map_tmp

    deallocate(map_tmp)
    return
