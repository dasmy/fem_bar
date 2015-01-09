Installation of MOOSE
=====================
* Follow the installation instructions (including prerequisites etc.) for your specific operating system on [mooseframework.org](http://mooseframework.org/getting-started/).
* Build MOOSE by changing into `moose/test` and calling `make -j 4`.
* Change into `moose/test` and invoke `./run_tests` which will verify that your MOOSE installation is working correctly.

Compilation of the Solid Mechanics example application
======================================================
Change to `moose/modules/solid_mechanics` and call `make`.
This produces the executable `solid_mechanics-opt` which is used for our input files.

Running MOOSE
=============
Just call `./solid_mechanics-opt -i INPUTFILE.i`.
For a parallel run, you can use MPI: `mpirun -np 4 ./solid_mechanics-opt -i INPUTFILE.i` but for our small examples, more than 2 processors will not improve speed.

TODO
====
* Find out how to output the stresses for feeding them as forces to the fluid code.
* Feed the forces to the fluid code.
* Get values for velocity boundary conditions from the fluid code.

