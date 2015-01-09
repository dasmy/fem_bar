# use with moose/modules/solid_mechanics/solid_mechanics-opt

[Mesh]
      dim           = 3
      distribution  = DEFAULT
      nx            = 4
      ny            = 4
      nz            = 16
      type          = GeneratedMesh
      xmax          =  0.5
      xmin          = -0.5
      ymax          =  0.5
      ymin          = -0.5
      zmax          =  5.0
      zmin          = -5.0
      displacements = 'dispx dispy dispz'
[]

[Variables]
  [./dispx]
    order = FIRST
    family = LAGRANGE
  [../]

  [./dispy]
    order = FIRST
    family = LAGRANGE
  [../]

  [./dispz]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[SolidMechanics]
  # for every variable given, this sets up a StressDivergence kernel (see SolidMechanicsAction.C)  
  [./solid]
    disp_x = dispx
    disp_y = dispy
    disp_z = dispz
  [../]
[]

[Kernels]
[]


[BCs]
  [./force_x]
    type = NeumannBC
    variable = dispx
    boundary = 'left right top bottom front back'
    value = 0.0
  [../]
  [./force_y]
    type = NeumannBC
    variable = dispy
    boundary = 'left right top bottom front back'
    value = 0.0
  [../]
  [./force_z]
    type = NeumannBC
    variable = dispz
    boundary = 'left right top bottom front back'
    value = 0.0
  [../]

  [./displacement_x]
    type = DirichletBC
    variable = dispx
    boundary = 'front'
    value = 0.0
  [../]
  [./displacement_y]
    type = DirichletBC
    variable = dispy
    boundary = 'front'
    value = 0.0
  [../]
  [./displacement_z]
    type = DirichletBC
    variable = dispz
    boundary = 'front'
    value = 0.0
  [../]

  [./moving_z]
    type = FunctionDirichletBC
    variable = dispy
    boundary = 'back'
    function = pull
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
    disp_z = dispz
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

[Functions]
  [./pull]
    type = ParsedFunction
    value = '5*sin(2*pi*t/5)'
  [../]
[]

[Outputs]
  exodus = true
  
  [./console]
    type = Console
    perf_log = true
    linear_residuals = false
  [../]
[]
