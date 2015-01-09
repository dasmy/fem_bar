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
  exodus = true
  
  [./console]
    type = Console
    perf_log = true
    linear_residuals = false
  [../]
[]
