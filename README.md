Installation of MOOSE
=====================
* Follow the installation instructions (including prerequisites etc.) for your specific operating system on 
  [mooseframework.org](http://mooseframework.org/getting-started/) but instead of the original repository
  given in *2. Clone MOOSE*, please use my fork to allow adding code if necessary, i.e. do
  
    mkdir ~/projects
    cd ~/projects
    git clone https://github.com/dasmy/moose.git
    cd ~/projects/moose
    git checkout fem_bar
    
  Afterwards, proceed with *3. Compile libMesh*
* Build MOOSE by changing into `moose/test` and calling `make -j 4`.
* Change into `moose/test` and invoke `./run_tests` which will verify that your MOOSE installation is working correctly.

Compilation of the Solid Mechanics example application
======================================================
Change to `moose/modules/solid_mechanics` and call `make`.
This produces the executable `solid_mechanics-opt` which is used for our input files.

Running MOOSE
=============
Just call `./solid_mechanics-opt -i INPUTFILE.i`.
For a parallel run, you can use MPI: `mpirun -np 2 ./solid_mechanics-opt -i INPUTFILE.i` but for our small examples, more than 2 processors will not improve speed.
The produced Exodus (`*.e`) files can for example be visualized using [ParaView](http://www.paraview.org).

Input Files
===========
The following input files are available:
* [`01-bar_bending.i`](01-bar_bending.i),[`01-bar_bending_2d.i`](01-bar_bending_2d.i):
  3D and 2D case of a bar being fixed at one end and bent by imposing a time-dependent displacement on the other end.
* [`02-bar_velocityBC.i`](02-bar_velocityBC.i),[`02-bar_velocityBC_2d.i`](02-bar_velocityBC_2d.i):
  3D and 2D case of a bar being fixed at one end and bent by imposing a temporally and spatially varying velocity to one of its sides.

Input File Structure
====================
for understanding how MOOSE works and is fed with input, it will really make sense to study the relevant chapters in the [MOOSE tutorial](http://mooseframework.org/static/media/uploads/docs/main.pdf).
For a rough overview on what we are doing, the following figure shows the structure of [`02-bar_velocityBC_2d.i`](02-bar_velocityBC_2d.i):

![02-bar_velocityBC_2d.svg](https://rawgit.com/dasmy/fem_balken/master/02-bar_velocityBC_2d.svg)


TODO
====
* Compute surface forces from the stresses for feeding them as forces to the fluid code.
  To this end I assume we have to evaluate the stress in surface normal direction (isn't this the pressure?).
  Thus we have to search for methods to compute surface pressures or utilize the `MaterialTensorCalculator`s `direction` parameter.
* Get values for velocity boundary conditions from the fluid code.

