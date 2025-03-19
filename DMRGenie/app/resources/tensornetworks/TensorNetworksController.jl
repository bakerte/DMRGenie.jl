module TensorNetworksController
  using Genie.Renderer.Html
  using DMRJtensor
  using TensorPACK
  using DMRGenie.TensorNetworks

  # Have the spin ops dedfined at the top level for getfield(...)

  function getSpinOps()
    Sp,Sm,Sz,Sy,Sx,O,Id = spinOps()

    Sp = convert(Matrix{ComplexF64}, Sp)
    Sm = convert(Matrix{ComplexF64}, Sm)
    Sz = convert(Matrix{ComplexF64}, Sz)
    Sy = convert(Matrix{ComplexF64}, Sy)
    Sx = convert(Matrix{ComplexF64}, Sx)
    O = convert(Matrix{ComplexF64}, O)
    Id = convert(Matrix{ComplexF64}, Id)

    return Sp, Sm, Sz, Sy, Sx, O, Id
  end
  Sp,Sm,Sz,Sy,Sx,O,Id = getSpinOps()
  # Sp,Sm,Sz,Sy,Sx,O,Id = spinOps()

  function DMRGenie()
    clear_usergenerated_folder()
    tensor_network = TensorNetwork()

    html(:tensornetworks,
         :DMRGenie,
         tensor_network=tensor_network,
         hamiltonain_measurement=NaN,
         dense_rho_path="",
         dense_correlation_path="",
         quantum_measurement=NaN,
         symmetry_rho_path="",
         symmetry_correlation_path="",
         alert_message="")
  end

  ###################
  # IMPORTANT NOTE: #
  #                 ###############################################################
  # This may NOT BE SAFE FOR PRODUCTION and may DELETE FILES when multiple users  #
  # access the website                                                            #
  #                                                                               #
  # Change clear_usergenerated_folder as necessary so that it is production ready #
  #################################################################################
  function clear_usergenerated_folder()

    try 
      run(`rm -rf ./public/usergenerated/files`)
      run(`mkdir ./public/usergenerated/files`)
      run(`touch ./public/usergenerated/files/.gitkeep`)
    catch e
      run(`mkdir ./public/usergenerated/files`)
      run(`touch ./public/usergenerated/files/.gitkeep`)
    end
  end

  function ErrorDMRGenie(alert_message)
    tensor_network = TensorNetwork()

    html(:tensornetworks,
         :DMRGenie,
         tensor_network=tensor_network,
         hamiltonain_measurement=NaN,
         dense_rho_path="",
         dense_correlation_path="",
         quantum_measurement=NaN,
         symmetry_rho_path="",
         symmetry_correlation_path="",
         alert_message=alert_message)
  end

  function DMRGenie(tensor_network)
    # Safety - TODO - Improve
    if (tensor_network.num_tensors < 3)
      # Initialize variables
      hamiltonain_measurement = NaN
      dense_rho = nothing
      dense_correlation_function = nothing
      hamiltonian_passed = true
      quantum_measurement = NaN
      symmetry_rho = nothing
      symmetry_correlation_function = nothing
      quantum_passed = true
    elseif (tensor_network.default_model == "none") && (tensor_network.num_hamiltonian_components <= 0)
      # Initialize variables
      hamiltonain_measurement = NaN
      dense_rho = nothing
      dense_correlation_function = nothing
      hamiltonian_passed = true
      quantum_measurement = NaN
      symmetry_rho = nothing
      symmetry_correlation_function = nothing
      quantum_passed = true
    else
      hamiltonain_measurement, dense_rho, dense_correlation_function, hamiltonian_passed, quantum_measurement, symmetry_rho, symmetry_correlation_function, quantum_passed = compute_hamiltonian(tensor_network)
    end

    if !hamiltonian_passed
      if tensor_network.default_model == "none"
        hamiltonain_measurement = "Hamiltonian DMRG Measurement Failed:<br>Potentially Invalid Custom Hamiltonian"
      else
        hamiltonain_measurement = "Hamiltonian DMRG Measurement Failed:<br>Unknown Cause"
      end
    end

    if !quantum_passed
      if !tensor_network.symmetry_flag
        quantum_measurement = NaN
      else
        quantum_measurement = "Quantum DMRG Measurement Failed:<br>Potentially Invalid Symmetries"
      end
    end

    # Initialize variables
    dense_rho_path = ""
    dense_correlation_path = ""
    symmetry_rho_string = ""
    symmetry_correlation_string = ""
    symmetry_rho_path = ""
    symmetry_correlation_path = ""

    if tensor_network.correlation_flag
      # Pipe stdout to a variable to get the correlation matrices in string form
      original_stdout = stdout;
      (read_pipe, write_pipe) = redirect_stdout();
      println(dense_rho)                       # < DO NOT DELETE - FOR STDOUT!!!
      println(dense_correlation_function)      # < DO NOT DELETE - FOR STDOUT!!!
      if tensor_network.symmetry_flag
        println(symmetry_rho)                  # < DO NOT DELETE - FOR STDOUT!!!
        println(symmetry_correlation_function) # < DO NOT DELETE - FOR STDOUT!!!
      end

      redirect_stdout(original_stdout);
      close(write_pipe)

      # Grab matrix output in string form
      dense_rho_string = readline(read_pipe)
      dense_correlation_string = readline(read_pipe)
      if tensor_network.symmetry_flag
        symmetry_rho_string = readline(read_pipe)
        symmetry_correlation_string = readline(read_pipe)
      end

      # Write to unique files
      unique_string = tensor_network.uuid[1:8] # Only take 8 characters from the UUID since they're very long

      if dense_rho_string != "nothing" && dense_rho_string !=  ""
        dense_rho_path = "usergenerated/files/dense_rho_" * unique_string * ".txt"
        write_to_file(dense_rho_string, "public/" * dense_rho_path)
      end

      if dense_correlation_string != "nothing" && dense_correlation_string !=  ""
        dense_correlation_path = "usergenerated/files/dense_correlation_" * unique_string * ".txt"
        write_to_file(dense_correlation_string, "public/" * dense_correlation_path)
      end

      if tensor_network.symmetry_flag
        if symmetry_rho_string != "nothing" && symmetry_rho_string !=  ""
          symmetry_rho_path = "usergenerated/files/symmetry_rho_" * unique_string * ".txt"
          write_to_file(symmetry_rho_string, "public/" * symmetry_rho_path)
        end

        if symmetry_correlation_string != "nothing" && symmetry_correlation_string !=  ""
          symmetry_correlation_path = "usergenerated/files/symmetry_correlation_" * unique_string * ".txt"
          write_to_file(symmetry_correlation_string, "public/" * symmetry_correlation_path)
        end
      end
    end

    html(:tensornetworks,
         :DMRGenie,
         tensor_network=tensor_network,
         hamiltonain_measurement=hamiltonain_measurement,
         dense_rho_path=dense_rho_path,
         dense_correlation_path=dense_correlation_path,
         quantum_measurement=quantum_measurement,
         symmetry_rho_path=symmetry_rho_path,
         symmetry_correlation_path=symmetry_correlation_path,
         alert_message="")
  end

  #
  # TODO - Move hamiltonian stuff to another file?
  #
  function compute_hamiltonian(tensor_network)
    # Initialize values
    Ns = tensor_network.num_tensors
    d = tensor_network.physical_dimension
    if tensor_network.default_model == "hubbardMPO"
      d = 4
    end

    psi = nothing
    mpo = nothing
    E = NaN
    hamiltonian_passed = true
    dense_rho = nothing
    symmetry_rho = nothing
    dense_correlation = nothing
    symmetry_correlation = nothing

    try
      # Make MPS
      if tensor_network.system == "random"
        psi = randMPS(ComplexF64,d,Ns)
      else
        # TODO  - Allow inputted wave function
        return (NaN, nothing, nothing, false, NaN, nothing, nothing, false)
      end

      # Make MPO
      if tensor_network.default_model == "heisenbergMPO"
        mpo = makeMPO(heisenbergMPO,d,Ns)
      elseif tensor_network.default_model == "hubbardMPO"
        mpo = makeMPO(hubbardMPO,d,Ns)
      elseif tensor_network.default_model == "tjMPO"
        mpo = makeMPO(tjMPO,d,Ns)
      else
        mpo = makeCustomMPO(tensor_network)
      end
    catch e
      println("ERROR")
      return (NaN, nothing, nothing, false, NaN, nothing, nothing, false)
    end

    try
      # Find Energy
      E = dmrg(psi,mpo,sweeps=100,goal=1E-8,m=30,cutoff=1E-9,method="twosite", silent=true)

      if tensor_network.correlation_flag
        # Correlation Matrix
        op1, op2 = tensor_network.correlation_matrix_operators
        op1 = getfield(TensorNetworksController, Symbol(op1))
        op2 = getfield(TensorNetworksController, Symbol(op2))
        dense_rho = correlationmatrix(psi, op1, op2)

        # Correlation Function
        cf_ops = tensor_network.correlation_function_operators
        cf_ops = [getfield(TensorNetworksController, Symbol(op)) for op in cf_ops]

        dense_correlation = correlation(psi, cf_ops...)
      else
        dense_rho = nothing
        dense_correlation = nothing
      end
    catch e
      E = NaN
      dense_rho = nothing
      dense_correlation = nothing
      hamiltonian_passed = false
    end

    qE, symmetry_rho, symmetry_correlation, quantum_passed = if tensor_network.symmetry_flag
                                         qcalc(tensor_network, psi, mpo, d)
                                       else
                                         (NaN, nothing, nothing, false)
                                       end

    return E, dense_rho, dense_correlation, hamiltonian_passed, qE, symmetry_rho, symmetry_correlation, quantum_passed
  end

  function qcalc(tensor_network, psi, mpo, d)
    set = tensor_network.symmetry_set
    sym_name::String = set[1]
    symmetries::Vector{String} = set[2]

    # Concatenate a universally unique identifier (uuid) to the sym_name
    # such that functions defined with it by @makeQNs later on are unique.
    sym_name = sym_name * tensor_network.uuid
    @eval @makeQNs $sym_name $(symmetries...)

    QN_func_name = Symbol(sym_name)
    phys_idx_func = getfield(DMRJtensor, QN_func_name)

    # This is gross, but get the type of qnum to define Qlabels,
    # otherwise it is seen as Vector{Any}, which makeqMPO and makeqMPS do not accept
    qnum = @invokelatest phys_idx_func(tensor_network.physical_indeces[1][1]...)
    Qlabels::typeof([qnum]) = []

    # Initialize Qlabes only contain 1 type of qnum (which is the case if it is uniform)
    for w in range(1, d)
      push!(Qlabels, qnum)
    end

    total_length_range = 0
    if tensor_network.non_uniform_flag
      for physical_idx in tensor_network.physical_indeces
        physical_idx_nums = physical_idx[1]
        physical_idx_range = physical_idx[2]
        length_range = physical_idx_range[2] - physical_idx_range[1] + 1

        # Check length for safety
        total_length_range += length_range
        if total_length_range > d
          break;
        end

        # @invokelatest ensures that the functions defined with @makeQNs are loaded
        # into the current environment
        qnum = @invokelatest phys_idx_func(physical_idx_nums...)
        Qlabels[physical_idx_range[1]:physical_idx_range[2]] = [qnum for i in 1:length_range]
      end
    end

    try
      # These functions are picky about the input.
      # Malformed symmetries can cause errors, hence the try-catch block
      qmpo = @invokelatest makeqMPO(Qlabels,mpo)
      qpsi = @invokelatest makeqMPS(Qlabels,psi)

      # qDMRG
      qE = @invokelatest dmrg(qpsi,qmpo,sweeps=100,m=30,cutoff=1E-9,method="twosite")

      # Initialize
      symmetry_rho = nothing
      q_correlation_function = nothing

      if tensor_network.correlation_flag
        # Then find the correlation matrix
        op1, op2 = tensor_network.correlation_matrix_operators
        op1 = getfield(TensorNetworksController, Symbol(op1))
        op2 = getfield(TensorNetworksController, Symbol(op2))

        qOp1, qOp2 = @invokelatest Qtens(Qlabels, op1, op2)
        symmetry_rho = @invokelatest correlationmatrix(qpsi, qOp1, qOp2)

        # Then the correlation function
        original_cf_ops = tensor_network.correlation_function_operators
        cf_ops = [getfield(TensorNetworksController, Symbol(op)) for op in original_cf_ops]
        cf_ops = @invokelatest Qtens(Qlabels, cf_ops...)

        # If there is only 1 operator then do not treat cf_ops as a list
        if length(original_cf_ops) == 1
          q_correlation_function = @invokelatest correlation(qpsi, cf_ops)
        else
          q_correlation_function = @invokelatest correlation(qpsi, cf_ops...)
        end
      else
        symmetry_rho = nothing
        q_correlation_function = nothing
      end

      return (qE, symmetry_rho, q_correlation_function, true)
    catch e
      return (NaN, nothing, nothing, false)
    end
  end

  function makeCustomMPO(tensor_network)
    Ns = tensor_network.num_tensors
    J = tensor_network.hamiltonian_constant
    components = tensor_network.hamiltonian_components

    mpo = 0
    for i in 1:Ns-1
      current_mpo_terms = []
      for component_idx in 1:tensor_network.num_hamiltonian_components
        append!(current_mpo_terms, [components[component_idx]])

        if components[component_idx][3] == "+"
          mpo += create_mpo_term(current_mpo_terms, J, i)
          current_mpo_terms = []
        end
      end
        
      if length(current_mpo_terms) > 0
        mpo += create_mpo_term(current_mpo_terms, J, i)
      end
    end

    return MPO(mpo)
  end

  function create_mpo_term(components, J, i)
    num_components = length(components)
    i_vals = [i+m for m in 0:num_components-1]

    operators = []
    for n in 1:num_components
      op = getfield(TensorNetworksController, Symbol(components[n][2]))
      append!(operators, [op])
    end

    # Flatten the components
    mpoterm_components = [(zip(operators, i_vals)...)...]

    multiplicative_terms = [components[j][1] for j in 1:num_components]
    K = *(J, multiplicative_terms...)

    return mpoterm(K, mpoterm_components...)
  end

  function write_to_file(content, filename)
    touch(filename)
    file = open(filename, "w")
    write(file, content)
    close(file)
  end
end
