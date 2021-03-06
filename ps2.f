C***********************************************************************
      USE TABLES
      USE PRMTS
      IMPLICIT NONE
    
      real (8) F,tmp
      integer IT
      real (8) LBOUND,MAXSTEP

       integer NN,nfcc,i,j,k

       real (8), DIMENSION(:), ALLOCATABLE :: EE,X
       CHARACTER( LEN =30 ) :: in_file
       real (8) oldF 

**************** initial parameters *******************

        in_file="ps2.init"
        call ininit(in_file)

**********************************************
       call inWF(in_fileWF,.false.)
**************** optimization *******************
       BSTE = 10.d0
       BPHI = PHI 
       updtbl = 0
       call EIGEN(NN,X,F)
       print *, F
       do while(F.ne.F)
          print *, 'Flag'
          call ininit(in_file,.false.)
          call eigen(NN,X,F)
       end do
       
       oldF = F
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

      NN = 6

      ALLOCATE(X(NN))
      ALLOCATE(EE(NN))

c current block 1..N
      k = 1

      write(*,*) 'Optimize ..... '

      do while (1>0)
       if(k.eq.1) then 
        write(*,*) 'multEE: ',multEE,'myacc: ',myacc
       endif
     
c how many elements to update
       updtbl = k

       do j=1,6
        EE(j) = 1.d-1*multEE*Sqrt(PHI(k,j))
        X(j) = PHI(k,j)
       enddo

       call VA04AD(X,EE,NN,F,ESCALE,IPRINT,ICON,MAXIT,nfcc)

       call BSYNCHRONIZE(NN,X,F)

       k = MOD(k,N) + 1

       if((mod(k,200).eq.1).or.((k-BSTI).eq.20)) then 
        BSTI = k
        updtbl = 0
        PHI = BPHI
        call eigen(NN,X,F)
       endif

       if(k.eq.1) then 
        write(*,*) 'oldF,F: ',oldF,F,oldF-F
        if(ABS(oldF-F) < myacc) then
         write(*,*) 'Accuracy changed'
         multEE = multEE*0.5d0 
         myacc = myacc*0.5d0
         endif
         oldF = F
        endif

       enddo

 100  continue

      END

*********1*********2*********3*********4*********5*********6*********7** 

      SUBROUTINE BSYNCHRONIZE(NN,X,F)
      USE TABLES
      IMPLICIT NONE
      integer NN
      real(8) F,X(NN)
     
      integer i 
      logical flag
     
      flag=.false.
      do i=1,6
       if (PHI(updtbl,i)<>BPHI(updtbl,i)) flag = .true.
      enddo

      if(flag)then
       do i=1,6 
        X(i)=BPHI(updtbl,i)       
       enddo
       call eigen(NN,X,F)
      endif

       RETURN
      END

*********1*********2*********3*********4*********5*********6*********7** 
 
