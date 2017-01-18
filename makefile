OPTS  = -c --wide -quad
OPTSF = --wide -quad

all: o1 main

prmts.o: ./mystd/prmts.f
	lf95 $(OPTS) ./mystd/prmts.f

ininit.o: ./inout/ininit.f
	lf95 $(OPTS) ./inout/ininit.f

inWF.o: ./inout/inWF.f
	lf95 $(OPTS) ./inout/inWF.f

outWF.o: ./inout/outWF.f
	lf95 $(OPTS) ./inout/outWF.f

idx.o: ./mystd/idx.f
	lf95 $(OPTS) ./mystd/idx.f

para.o: ./mystd/para.f
	lf95 $(OPTS) ./mystd/para.f
f.o: ./f/f.f
	lf95 $(OPTS) ./f/f.f
 
f2.o: ./f/f2.f
	lf95 $(OPTS) ./f/f2.f

eigen.o: ./eigen/eigen.f
	lf95 $(OPTS) ./eigen/eigen.f

halmnormS.o: ./eigen/halmnormS.f
	lf95 $(OPTS) ./eigen/halmnormS.f

qrdcmp.o: ./mystd/qrdcmp.f
	lf95 $(OPTS) ./mystd/qrdcmp.f

qrsolv.o: ./mystd/qrsolv.f
	lf95 $(OPTS) ./mystd/qrsolv.f

rsolv.o: ./mystd/rsolv.f
	lf95 $(OPTS) ./mystd/rsolv.f

rotate.o: ./mystd/rotate.f
	lf95 $(OPTS) ./mystd/rotate.f

qrupdt.o: ./mystd/qrupdt.f
	lf95 $(OPTS) ./mystd/qrupdt.f

VA04AD.o: ./VA04AD/VA04AD.f
	lf95 $(OPTS) ./VA04AD/VA04AD.f

o1: prmts.o ininit.o inWF.o outWF.o idx.o halmnormS.o eigen.o qrdcmp.o qrsolv.o rsolv.o rotate.o qrupdt.o VA04AD.o f.o f2.o

main: ps2.f o1
	lf95 --wide -o main ps2.f prmts.o ininit.o inWF.o outWF.o idx.o f2.o f.o halmnormS.o eigen.o qrdcmp.o qrsolv.o rsolv.o rotate.o qrupdt.o VA04AD.o

.PHONY: clean
clean:
	rm -f *.o
	rm -f *.mod
	rm -f main
	rm -f *~
	rm -f */*~
	rm -f *.exe