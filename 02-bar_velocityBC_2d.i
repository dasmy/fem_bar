# use with moose/modules/solid_mechanics/solid_mechanics-opt

[Mesh]
      dim           = 2
      distribution  = DEFAULT
      nx            = 16
      ny            = 4
      nz            = 4
      type          = GeneratedMesh
      xmax          = 10.0
      xmin          =  0.0
      ymax          =  0.5
      ymin          = -0.5
      displacements = 'dispx dispy'
[]

[Variables]
  [./dispx]  order=FIRST  family=LAGRANGE  [../]
  [./dispy]  order=FIRST  family=LAGRANGE  [../]
[]

[SolidMechanics]
  [./solid]  disp_x=dispx  disp_y=dispy  [../]
[]

[Kernels]
[]


[BCs]
  [./displacement_x]  type=DirichletBC  variable='dispx'  boundary='left'  value=0.0  [../]
  [./displacement_y]  type=DirichletBC  variable='dispy'  boundary='left'  value=0.0  [../]

  [./velocity]
    type = PresetVelocity
    variable = dispy
    boundary = 'bottom'
    velocity = 1.0
    function = velocity_func
  [../]
[]

[Functions]
  [./velocity_func]
    type = ParsedFunction
    value = 'sin(2*pi*t/5)*sin(pi/2*x/7.5)'
  [../]
[]

[Materials]
  [./linear_isotropic]
    type = LinearIsotropicMaterial
    block = 0
    youngs_modulus = 0.01e6
    poissons_ratio = 0.3
    disp_x = dispx
    disp_y = dispy
  [../]
[]

[AuxVariables]
  # stress aux variables are defined for output; this is a way to get integration point variables to the output file
  [./stress_xx]  order=CONSTANT  family=MONOMIAL  [../]
  [./stress_yy]  order=CONSTANT  family=MONOMIAL  [../]
  [./stress_zz]  order=CONSTANT  family=MONOMIAL  [../]
  [./stress_xy]  order=CONSTANT  family=MONOMIAL  [../]
  [./stress_yz]  order=CONSTANT  family=MONOMIAL  [../]
  [./stress_zx]  order=CONSTANT  family=MONOMIAL  [../]
[]

[AuxKernels]
  # indices for the MaterialTensorAux are (0,1,2,3,4,5) --> (xx, yy, zz, xy, yz, zx)
  # for efficiency, we only compute these at the end of a timestep
  [./aux_stress_xx]  type=MaterialTensorAux  tensor=stress  variable=stress_xx  index=0  execute_on=timestep  [../]
  [./aux_stress_yy]  type=MaterialTensorAux  tensor=stress  variable=stress_yy  index=1  execute_on=timestep  [../]
  [./aux_stress_zz]  type=MaterialTensorAux  tensor=stress  variable=stress_zz  index=2  execute_on=timestep  [../]
  [./aux_stress_xy]  type=MaterialTensorAux  tensor=stress  variable=stress_xy  index=3  execute_on=timestep  [../]
  [./aux_stress_yz]  type=MaterialTensorAux  tensor=stress  variable=stress_yz  index=4  execute_on=timestep  [../]
  [./aux_stress_zx]  type=MaterialTensorAux  tensor=stress  variable=stress_zx  index=5  execute_on=timestep  [../]
[]

[Executioner]
  type = Transient

  solve_type = PJFNK
  petsc_options_iname = '-ksp_gmres_restart -pc_type -pc_hypre_type -pc_hypre_boomeramg_max_iter'
  petsc_options_value = '201                 hypre    boomeramg      4'
  line_search = 'none'


  nl_rel_step_tol = 1.e-8
  l_max_its = 100

  start_time = 0
  end_time   = 5.0
  #num_steps = 10
  dtmax      = 0.1
  dtmin      = 0.1
[]

[Outputs]
  output_on = 'initial timestep_end'
  exodus = true
  
  [./console]
    type = Console
    perf_log = true
    linear_residuals = false
  [../]
[]
