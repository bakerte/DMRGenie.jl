using Genie
using Genie.Router
using Genie.Renderer.Html
using Genie.Requests
using DMRGenie.Pages
using DMRGenie.TensorNetworksController
using DMRGenie.TensorNetworks
using UUIDs
using JSON
using TensorPACK
include("test_routes.jl")

##############
# Main pages #
##############

route("/",  Pages.home)
route("/tutorial", Pages.tutorial)
route("/runalgs", TensorNetworksController.DMRGenie)
route("/build", TensorNetworkBuildersController.buildnetwork)



####################
# Algorithm Runner #
####################

# This post method takes all the data from the submitted form to create a tensor network
route("/runalgs", method = POST) do
  # Initialize variables because of try-catch-block
  alert_message = ""
  uuid = ""
  num_tensors = 3
  graph_type = ""
  system = ""
  method = ""
  default_model = ""
  physical_dimension = 2
  hamiltonian_constant = 1
  num_hamiltonian_components = 0
  hamiltonian_components = []
  correlation_flag = false
  correlation_matrix_operators = ("Id", "Id")
  correlation_function_operators = ["Id"]
  symmetry_flag = false
  symmetry_set = ("", [])
  non_uniform_flag = false
  physical_indeces = []

  try
    # Set universally unique identifier (uuid)
    uuid = gen_uuid_with_no_hyphens()

    # Collect Method Data
    num_tensors = parse(Int64, postpayload(:num_tensors, "1"))
    graph_type = postpayload(:graph_type, "scalar")
    system = postpayload(:system, "random")
    method = postpayload(:method, "multiply")

    # Collect Hamiltonian data
    physical_dimension = parse(Int64,postpayload(:physical_dimension, "2"))
    hamiltonian_constant = parse(Float64,postpayload(:hamiltonian_constant, "1"))
    num_hamiltonian_components = parse(Int64,postpayload(:num_hamiltonian_components, "0"))
    default_model = postpayload(:default_model, "1")

    # Collect all Hamiltonian components in a loop
    hamiltonian_components = []
    for i in 1:num_hamiltonian_components
      value_sym = Symbol("hamiltonian_value[" * string(i) * "]")
      matrix_sym = Symbol("hamiltonian_matrix[" * string(i) * "]")
      operator_sym = Symbol("operation[" * string(i) * "]")

      curr_hamiltonian_value = parse(Float64, postpayload(value_sym, "0"))
      curr_hamiltonian_matrix = postpayload(matrix_sym, "Id")

      # The last hamiltonian component has no operator
      if i != num_hamiltonian_components
        curr_operator = postpayload(operator_sym, "*")
      else
        curr_operator = ""
      end


      append!(hamiltonian_components,
              [(curr_hamiltonian_value, curr_hamiltonian_matrix, curr_operator)])
    end


    correlation_flag = postpayload(:correlation_box, "off")
    correlation_flag = if correlation_flag == "on"
                         true
                       else
                         false
                       end
    
    # Computation Limitation for Correlations
    # This limit is also imposed in model_fields.js
    if num_tensors > 15
      correlation_flag = false
    end

    if correlation_flag
      # Collect Correlation Matrix Operators
      # (There are only ever 2)
      op1_sym = Symbol("correlation_matrix_op[1]")
      op2_sym = Symbol("correlation_matrix_op[2]")
      correlation_matrix_op1 = postpayload(op1_sym, "Id")
      correlation_matrix_op2 = postpayload(op2_sym, "Id")
      correlation_matrix_operators = (correlation_matrix_op1, correlation_matrix_op2)

      # Collect Correlation Function Operators
      # (There can be any number of operators up to 20)
      correlation_function_operators = []
      curr_operator_symbol = Symbol("correlation_function_op[" * string(1) * "]")
      curr_func_op = postpayload(curr_operator_symbol, "Id")

      j = 1
      # There are an unknown number of symmetries that can be input
      while !isempty(curr_func_op)
        append!(correlation_function_operators, [curr_func_op])

        j += 1
        curr_operator_symbol = Symbol("correlation_function_op[" * string(j) * "]")
        curr_func_op = postpayload(curr_operator_symbol, "")
      end
    end

    # Collect symmetry data
    symmetry_flag = postpayload(:symmetry_box, "off")
    symmetry_flag = if symmetry_flag == "on"
                      true
                    else
                      false
                    end

    # Computation Limitation for Symmetries
    # This limit is also imposed in model_fields.js
    if num_tensors > 50
      symmetry_flag = false
    end

    # Set some initial values
    non_uniform_flag = false
    physical_indeces = []
    symmetry_set = ("", [])

    if symmetry_flag
      name_symbol = Symbol("sym_name")
      sym_name = postpayload(name_symbol, "")

      symmetries = []
      symmetry_symbol = Symbol("sym[" * string(1) * "]")
      curr_symmetry = postpayload(symmetry_symbol, "")

      i = 1
      # There are an unknown number of symmetries that can be input
      while !isempty(curr_symmetry)
        if curr_symmetry == "Zn"
          Zn_val_symbol = Symbol("Zn_val[" * string(i) * "]")
          sym_num = postpayload(Zn_val_symbol, "1")
          curr_symmetry = string(curr_symmetry, "{", sym_num, "}")
        end

        append!(symmetries, [curr_symmetry])

        i += 1
        symmetry_symbol = Symbol("sym[" * string(i) * "]")
        curr_symmetry = postpayload(symmetry_symbol, "")
      end

      symmetry_set::Tuple{String, Vector{String}} = (sym_name, symmetries)

      non_uniform_flag = postpayload(:non_uniform_box, "off")
      non_uniform_flag = if non_uniform_flag == "on"
                        true
                      else
                        false
                      end
      pi_idx = 1

      num_physical_indeces = parse(Int64, postpayload(:num_physical_indeces, "0"))
      while pi_idx <= num_physical_indeces
        physical_indeces_for_idx = []
        for sym_idx in 1:length(symmetries)
          pi_symbol = Symbol("physical_index[" * string(pi_idx) * "][" * string(sym_idx) * "]")
          curr_pi = parse(Int64, postpayload(pi_symbol, "0")) # TODO - What should the default be?
          append!(physical_indeces_for_idx, curr_pi)
        end

        range = (-1, -1) # Corresponds to whole network
        if non_uniform_flag
          range_start_symbol = Symbol("range_start[" * string(pi_idx) * "]")
          range_stop_symbol = Symbol("range_stop[" * string(pi_idx) * "]")

          range_start = parse(Int64, postpayload(range_start_symbol, "0"))
          range_stop = parse(Int64, postpayload(range_stop_symbol, "0"))

          range = (range_start, range_stop)
        end


        append!(physical_indeces, [(physical_indeces_for_idx, range)])
        pi_idx += 1

        if !non_uniform_flag
          # If the non-uniform flag is false, then there is only 1 physical index entry
          break;
        end
      end
    end
  catch e
    alert_message = "Invalid Input"
  end


  if isempty(alert_message)

    # Create Tensor Network with all the data collected from the form
    tensor_network = TensorNetwork(uuid=uuid,
                                   num_tensors=num_tensors,
                                   graph_type=graph_type,
                                   system=system,
                                   method=method,
                                   default_model=default_model,
                                   physical_dimension=physical_dimension,
                                   hamiltonian_constant=hamiltonian_constant,
                                   num_hamiltonian_components=num_hamiltonian_components,
                                   hamiltonian_components=hamiltonian_components,
                                   correlation_flag=correlation_flag,
                                   correlation_matrix_operators=correlation_matrix_operators,
                                   correlation_function_operators=correlation_function_operators,
                                   symmetry_flag=symmetry_flag,
                                   symmetry_set=symmetry_set,
                                   non_uniform_flag=non_uniform_flag,
                                   physical_indeces=physical_indeces)

    TensorNetworksController.DMRGenie(tensor_network)
  else
    TensorNetworksController.ErrorDMRGenie(alert_message)
  end
end






##########################
# Tensor Network Builder #
##########################

mutable struct tensorNode
  id::String
  T::nametens
end



# This post method takes all the data from the submitted form to create a tensor network
route("/build", method = POST) do
  # Initialize variables because of try-catch-block
  alert_message = ""
  computed_tensors = []
  output_tensors = []
  output_string = ""
  output_path = ""

  try
    # Collect Network History
    frontend_data = postpayload(:frontendData, "[]")

    # Run all steps
    computed_tensors, output_tensors, alert_message = parse_data(frontend_data)

# DEBUG
    # for tensor in computed_tensors
    #   println(tensor)
    #   display(tensor.T)
    # end


    i = 1
    for tensor in output_tensors
      if length(tensor.T.N) <= 5^4
        # Put the current tensor on the string
        output_string *= "\n\n" * "A$(i) = "
        output_string *= tensor_to_string(tensor.T)
        i += 1
      else
        output_string = "Output omitted - Resulting tensor(s) too large - Size limit is 5^4 elements"
        break
      end
    end

    if output_string != ""
      # output_path is returned for the download link
      # full_path is for creating the file
      output_path = "usergenerated/files/tensor_output_" * gen_uuid_with_no_hyphens()[1:8] * ".txt"
      full_path = "public/" * output_path

      touch(full_path)
      file = open(full_path, "w")
      write(file, output_string)
      close(file)
    else
      output_path = "VOID"
    end

  catch e
    if typeof(e) == String
      alert_message = e
    else
      alert_message = "Invalid Input"
    end
  end


  if isempty(alert_message) # Success
    TensorNetworkBuildersController.buildnetwork(output_path)
  else
    println("\n", alert_message)
    println("\nERROR\nERROR\nERROR\nERROR")
    TensorNetworkBuildersController.backendError(alert_message)
  end
end


function parse_data(frontend_data)
  # Initialize
  computed_tensors = []
  output_tensors = []
  alert_message = ""

  steps_JSON = JSON.parse(frontend_data)

  # Run computations based on history
  for step in steps_JSON
    curr_operation = get(step, "operation", "")

    if curr_operation == "UPLOAD"
      try
        println("Run Upload")
        output_tensors = run_upload(step, computed_tensors)
      catch e
        if e == ""
          alert_message = "Error in Upload"
        else
          throw(e)
        end
        break
      end

    elseif curr_operation == "CONTRACTION"
      try
        println("Run Contraction")
        output_tensors = run_contraction(step, computed_tensors)
      catch e
        if e == ""
          alert_message = "Error in Contraction"
        else
          throw(e)
        end
        break
      end

    elseif curr_operation == "EIGEN"
      try
        println("Run Eigen")
        output_tensors = run_eigen(step, computed_tensors)
      catch e
        if e == ""
          alert_message = "Error in Eigenvalue Decomposition"
        else
          throw(e)
        end
        break
      end

    elseif curr_operation == "SVD"
      try
        println("Run SVD")
        output_tensors = run_SVD(step, computed_tensors)
      catch e
        if e == ""
          alert_message = "Error in SVD"
        else
          throw(e)
        end
        break
      end

    elseif curr_operation == "LQ"
      try
        println("Run LQ")
        output_tensors = run_LQ_or_QR(step, computed_tensors, :LQ)
      catch e
        if e == ""
          alert_message = "Error in LQ decomposition"
        else
          throw(e)
        end
        break
      end

    elseif curr_operation == "QR"
      try
        println("Run QR")
        output_tensors = run_LQ_or_QR(step, computed_tensors, :QR)
      catch e
        if e == ""
          alert_message = "Error in QR decomposition"
        else
          throw(e)
        end
        break
      end

    elseif curr_operation == "COPY-PASTE"
      try
        println("Run Copy-Paste")
        copy_tensor(step, computed_tensors)
      catch e
        if e == ""
          alert_message = "Error in Copy-Paste"
        else
          throw(e)
        end
        break
      end

    elseif curr_operation == "CONNECT-EDGES"
      try
        println("Run Connect-Edges")
        connect_edges(step, computed_tensors)
      catch e
        if e == ""
          alert_message = "Error in Connect-Edges"
        else
          throw(e)
        end
        break
      end
    end

  end

  return computed_tensors, output_tensors, alert_message
end

function run_upload(JSON, computed_tensors)
  uploaded_tensor = get(JSON, "nodesInvolved", [])
  edges = get(JSON, "allEdgesAfter", [])

  id = get(uploaded_tensor, "id", "-1")
  file_text = get(get(uploaded_tensor, "data", ""), "input", "")

  # Get the names associated with edges, not the ids
  connected_edges = find_connected_edges(id, edges)
  names = [x[1] for x in connected_edges]
  tensor_size = [x[2] for x in connected_edges]

  # Important!
  # Do this check to prevent users from executing arbitrary julia code
  if match(r"^\s*\[(-|\s|\d|\.|\;|\[|\])*\]\s*$", file_text) === nothing
    throw("Invalid tensor string uploaded")
  end

  tensor = Meta.eval(Meta.parse(file_text))

  for i in 1:length(size(tensor))
    if parse(Int, tensor_size[i]) != size(tensor)[i]
      throw("Uploaded tensor size does not match given size: " * string(tensor_size) * " given, while " * string(size(tensor)) * " uploaded")
    end
  end

  # Enforce size limit
  Z = 1
  for s in size(tensor)
    Z *= s
  end
  if Z > 2^10 # TODO - How large do we want this?
    throw("Tensor too large")
  end

  T = nametens(tensor, names)
  upload_result = tensorNode(id, T)

  push!(computed_tensors, upload_result)

  return [upload_result]
end

function run_contraction(JSON, computed_tensors)
  # Nodes and edges
  nodes_involved = get(JSON, "nodesInvolved", [])
  all_edges = get(JSON, "allEdgesBefore", [])

  # Get tensors
  id1 = get(nodes_involved[1], "id", "-1")
  id2 = get(nodes_involved[2], "id", "-1")

  tensor1 = get_tensor(id1, computed_tensors, all_edges)
  tensor2 = get_tensor(id2, computed_tensors, all_edges)

  # Get the names associated with edges, not the ids
  connected_edges1 = find_connected_edges(id1, all_edges, get_ids_and_names=true)
  connected_edges2 = find_connected_edges(id2, all_edges, get_ids_and_names=true)

  edge_ids1 = [x[1] for x in connected_edges1]
  edge_names1 = [x[2] for x in connected_edges1]

  edge_ids2 = [x[1] for x in connected_edges2]
  edge_names2 = [x[2] for x in connected_edges2]

  # Reshape to force the Matrix type so that findall works correctly
  edge_names1 = reshape(edge_names1, length(edge_names1), 1)
  edge_names2 = reshape(edge_names2, length(edge_names2), 1)
  edges_with_common_names = findall(x->x in edge_names1, edge_names2)

  if !isempty(edges_with_common_names)
    for name_idx in edges_with_common_names
      idx1 = name_idx[1]
      idx2 = name_idx[2]
      rename!(tensor1.T, [[edge_ids1[idx1], edge_names1[idx1]]])
      rename!(tensor2.T, [[edge_ids2[idx2], edge_names2[idx2]]])
    end
  end

  # Contraction
  contraction_result = tensor1.T * tensor2.T

  resultant_node = get(JSON, "resultantNodes", [])[1]
  resultant_id = get(resultant_node, "id", "-1")

  resultant_tensor = tensorNode(resultant_id, contraction_result)
  push!(computed_tensors, resultant_tensor)

  return [resultant_tensor]
end


function run_eigen(JSON, computed_tensors)
  # Nodes and edges
  nodes_involved = get(JSON, "nodesInvolved", [])
  all_edges = get(JSON, "allEdgesBefore", [])

  # Get tensor
  id = get(nodes_involved[1], "id", "-1")
  tensor = get_tensor(id, computed_tensors, all_edges)
  connected_edges = find_connected_edges(id, all_edges)

  # Check if square. If not, throw error
  num_elements = 1
  for edge in connected_edges
    num_elements *= edge[2]
  end
  eigen_dims = sqrt(num_elements)
  if eigen_dims != floor(eigen_dims)
    throw("Invalid eigenvalue decomposition dimensions")
  end

  # Reshape to square rank-2 tensor
  tensor = reshape(tensor.T.N, (Int(eigen_dims), Int(eigen_dims)))

  # Eigenvalue decomposition
  eigenvals, eigenvecs = eigen(tensor)
  eigenvecs_transpose = eigenvecs'

  # Get data
  edges_after = get(JSON, "allEdgesAfter", [])
  resultant_nodes = get(JSON, "resultantNodes", [])
  eigenvals_id = get(resultant_nodes[1], "id", "-1")
  eigenvecs_id = get(resultant_nodes[2], "id", "-1")
  eigenvecs_transpose_id = get(resultant_nodes[3], "id", "-1")

  # Names
  eigenval_edges = find_connected_edges(eigenvals_id, edges_after)
  eigenvec_edges = find_connected_edges(eigenvecs_id, edges_after)
  eigenvecs_transpose_edges = find_connected_edges(eigenvecs_transpose_id, edges_after)
  eigenvals = nametens(eigenvals, [edge[1] for edge in eigenval_edges])
  eigenvecs = nametens(eigenvecs, [edge[1] for edge in eigenvec_edges])
  eigenvecs_transpose = nametens(eigenvecs_transpose, [edge[1] for edge in eigenvecs_transpose_edges])

  # We want to store all tensors in tens form for generality (diagonal breaks decompositions)
  eigenvals = convert_diagonal_to_tensor(eigenvals)

  # Tensors to store
  eigenvals_tensor = tensorNode(eigenvals_id, eigenvals)
  eigenvecs_tensor = tensorNode(eigenvecs_id, eigenvecs)
  eigenvecs_transpose_tensor = tensorNode(eigenvecs_transpose_id, eigenvecs_transpose)

  push!(computed_tensors, eigenvals_tensor)
  push!(computed_tensors, eigenvecs_tensor)
  push!(computed_tensors, eigenvecs_transpose_tensor)

  return [eigenvals_tensor, eigenvecs_tensor]
end

function run_SVD(JSON, computed_tensors)
  # Nodes and edges
  nodes_involved = get(JSON, "nodesInvolved", [])
  edgeGroups = get(JSON, "edgesInvolved", [])
  all_edges = get(JSON, "allEdgesBefore", [])

  # Get tensor
  id = get(nodes_involved[1], "id", "-1")
  tensor = get_tensor(id, computed_tensors, all_edges)

  # Get resultant ids
  resultant_nodes = get(JSON, "resultantNodes", [])
  U_id = get(resultant_nodes[1], "id", "-1")
  D_id = get(resultant_nodes[2], "id", "-1")
  V_id = get(resultant_nodes[3], "id", "-1")

  # Find D edges for naming
  edges_after = get(JSON, "allEdgesAfter", [])
  D_tensor_edges = find_connected_edges(D_id, edges_after)

  # SVD
  U, D, V = svd(tensor.T, [edgeGroups[1], edgeGroups[2]], name="", leftadd=D_tensor_edges[1][1], rightadd=D_tensor_edges[2][1])

  # We want to store all tensors in tens form for generality (diagonal breaks decompositions)
  D = convert_diagonal_to_tensor(D)

  U_tensor = tensorNode(U_id, U)
  D_tensor = tensorNode(D_id, D)
  V_tensor = tensorNode(V_id, V)

  push!(computed_tensors, U_tensor)
  push!(computed_tensors, D_tensor)
  push!(computed_tensors, V_tensor)

  return [U_tensor, D_tensor, V_tensor]
end

function run_LQ_or_QR(JSON, computed_tensors, decomp)
  # Nodes and edges
  nodes_involved = get(JSON, "nodesInvolved", [])
  edgeGroups = get(JSON, "edgesInvolved", [])
  all_edges = get(JSON, "allEdgesBefore", [])

  # Get tensor
  id = get(nodes_involved[1], "id", "-1")
  tensor = get_tensor(id, computed_tensors, all_edges)

  # L and Q or Q and R
  resultant_nodes = get(JSON, "resultantNodes", [])
  T1_id = get(resultant_nodes[1], "id", "-1")
  T2_id = get(resultant_nodes[2], "id", "-1")


  # Find edges for naming
  edges_after = get(JSON, "allEdgesAfter", [])
  T1_tensor_edges = find_connected_edges(T1_id, edges_after)
  T1_tensor_names = [x[1] for x in T1_tensor_edges]

  # Find the name of the inner index
  unique_name = ""
  for name in T1_tensor_names
    if !(name in edgeGroups[1] && name in edgeGroups[2])
      unique_name = name
    end
  end

  # LQ or QR decomposition
  T1, T2 = (decomp == :LQ) ? lq(tensor.T, [edgeGroups[1], edgeGroups[2]], name=unique_name, leftadd="") : qr(tensor.T, [edgeGroups[1], edgeGroups[2]], name=unique_name, leftadd="")

  T1_tensor = tensorNode(T1_id, T1)
  T2_tensor = tensorNode(T2_id, T2)

  push!(computed_tensors, T1_tensor)
  push!(computed_tensors, T2_tensor)

  return [T1_tensor, T2_tensor]
end


# If the tensor has already been computed, then copy the result and give it the
# corresponding id
function copy_tensor(JSON, computed_tensors)
  copied_nodes = get(JSON, "nodesInvolved", [])
  edgesAfter = get(JSON, "allEdgesAfter", [])

  # Get each id and search through the previously computed tensors
  # to find the one to copy
  for node in copied_nodes
    curr_id = get(node, "id", "-1")
    data = get(node, "data", "-1")
    parent_id = get(data, "parentNodeId", "-1")

    for tensor in computed_tensors
      if tensor.id == parent_id
        tensor_copy = copy(tensor.T.N)
        connected_edges = find_connected_edges(curr_id, edgesAfter)
        names = [x[1] for x in connected_edges]

        new_tensor = nametens(tensor_copy, names)
        new_tensor = tensorNode(curr_id, new_tensor)

        push!(computed_tensors, new_tensor)
      end
    end

    # Otherwise, do nothing and let them be initialized randomly.
    # If the user did not copy the tensor after an operation
    # do not assume they want the exact same values in the tensor.
  end
end

function connect_edges(JSON, computed_tensors)
  edge1, edge2, resultantEdge = get(JSON, "edgesInvolved", ["NULL", "NULL", "NULL"])

  edge1Id = get(edge1, "id", "")
  edge2Id = get(edge2, "id", "")
  resultantEdgeId = get(resultantEdge, "id", "")

  node1Id = get(edge1, "source", "")
  node2Id = get(edge2, "source", "")

  for tensor in computed_tensors
    if tensor.id == node1Id
      rename!(tensor.T, [[edge1Id, resultantEdgeId]])
    elseif tensor.id == node2Id
      rename!(tensor.T, [[edge2Id, resultantEdgeId]])
    end
  end
end


#########
# Misc. #
#########

function get_tensor(id, computed_tensors, edge_set)
  # Check if the tensor has already been used
  for tensor in computed_tensors
    if tensor.id == id
      return tensor
    end
  end

  # Otherwise, create tensor
  connected_edges = find_connected_edges(id, edge_set)
  names = [x[1] for x in connected_edges]
  tensor_size = [x[2] for x in connected_edges]

  # Enforce size limit to limit computational resource usage
  Z = 1
  for s in tensor_size
    Z *= s
  end
  if Z > 2^10 # TODO - How large do we want this?
    throw("Tensor too large")
  end



  # Make unitary tensor
  # Special case needed for rank 1
  if length(tensor_size) == 1
    U = rand(tensor_size[1])
    U = U ./ norm(U)
  else
    U = rand(tensor_size...)
    half_len = fld(length(tensor_size), 2)
    u, _d, v = svd(U, [[i for i in 1:half_len], [i for i in (half_len+1):length(tensor_size)]])
    U = u * v
  end

  T = nametens(U, names)

  return tensorNode(id, T)
end


function find_connected_edges(id, edge_set; get_ids_and_names=false)
  desired_edges = []

  for edge in edge_set
    source = get(edge, "source", "-1")
    target = get(edge, "target", "-1")

    if source == id || target == id
      edge_id = get(edge, "id", "")
      data = get(edge, "data", "")

      if data != ""
        dim = get(data, "dim", -1)

        if get_ids_and_names
          name = get(edge, "label", "")
          push!(desired_edges, (edge_id, name, dim))
        else
          push!(desired_edges, (edge_id, dim))
        end
      end
    end
  end

  return desired_edges
end


function convert_diagonal_to_tensor(D)
  return nametens(tens(D.N), D.names)
end

function tensor_to_string(tensor)
  shape = size(tensor)

  # 0 indicates a scalar result
  if shape[1] == 0
    return string(tensor[1])
  end

  t = typeof(tensor[1])

  # Convert to array for printing
  T_array = Array{t, length(shape)}(undef, shape...)
  for i in 1:length(tensor.N)
    T_array[i] = tensor[i]
  end
  
  # Pipe stdout to a variable to get the correlation matrices in string form
  original_stdout = stdout;
  (read_pipe, write_pipe) = redirect_stdout();

  println(T_array) # < DO NOT DELETE - FOR STDOUT!!!

  redirect_stdout(original_stdout);
  close(write_pipe)

  return readline(read_pipe)
end


# We want to generate UUIDs without hyphens because they are used in the
# function definition with @makeQNs, and functions cannot contain hyphens.
function gen_uuid_with_no_hyphens()
  uuid = string(uuid4())
  resultant_uuid = ""
  len = length(uuid)
  i = 1
  while i <= len
    if uuid[i] != '-'
      resultant_uuid = resultant_uuid * uuid[i]
    end
    i += 1
  end

  return resultant_uuid
end


##############
# DEV ROUTES #
##############
# !!!NOTE: The bootup code is after this section!!!

##                                       ##
# These are routes for Load Testing only. #
# Each route contains a set input for our #
# functions to test on.                   #
##                                       ##

route("/dev/hidden/build1") do
  # Initialize variables because of try-catch-block
  alert_message = ""
  computed_tensors = []
  output_tensors = []
  output_string = ""

  try
    # Collect Network History
    frontend_data = build1()

    # Run all steps
    computed_tensors, output_tensors, alert_message = parse_data(frontend_data)

  catch e
    if typeof(e) == String
      alert_message = e
    else
      alert_message = "Invalid Input"
    end
  end

  if isempty(alert_message) # Success
    # TODO - What should we give as input?
    TensorNetworkBuildersController.buildnetwork(output_string)
  else
    # TODO - Make better and more descriptive
    println("\n", alert_message)
    println("\nERROR\nERROR\nERROR\nERROR")
    TensorNetworkBuildersController.buildnetwork()
  end
end


route("/dev/hidden/build2") do
  # Initialize variables because of try-catch-block
  alert_message = ""
  computed_tensors = []
  output_tensors = []
  output_string = ""

  try
    # Collect Network History
    frontend_data = build2()

    # Run all steps
    computed_tensors, output_tensors, alert_message = parse_data(frontend_data)

  catch e
    if typeof(e) == String
      alert_message = e
    else
      alert_message = "Invalid Input"
    end
  end

  if isempty(alert_message) # Success
    # TODO - What should we give as input?
    TensorNetworkBuildersController.buildnetwork(output_string)
  else
    # TODO - Make better and more descriptive
    println("\n", alert_message)
    println("\nERROR\nERROR\nERROR\nERROR")
    TensorNetworkBuildersController.buildnetwork()
  end
end


route("/dev/hidden/build3") do
  # Initialize variables because of try-catch-block
  alert_message = ""
  computed_tensors = []
  output_tensors = []
  output_string = ""

  try
    # Collect Network History
    frontend_data = build3()

    # Run all steps
    computed_tensors, output_tensors, alert_message = parse_data(frontend_data)

  catch e
    if typeof(e) == String
      alert_message = e
    else
      alert_message = "Invalid Input"
    end
  end

  if isempty(alert_message) # Success
    # TODO - What should we give as input?
    TensorNetworkBuildersController.buildnetwork(output_string)
  else
    # TODO - Make better and more descriptive
    println("\n", alert_message)
    println("\nERROR\nERROR\nERROR\nERROR")
    TensorNetworkBuildersController.buildnetwork()
  end
end


route("/dev/hidden/build4") do
  # Initialize variables because of try-catch-block
  alert_message = ""
  computed_tensors = []
  output_tensors = []
  output_string = ""

  try
    # Collect Network History
    frontend_data = build4()

    # Run all steps
    computed_tensors, output_tensors, alert_message = parse_data(frontend_data)

  catch e
    if typeof(e) == String
      alert_message = e
    else
      alert_message = "Invalid Input"
    end
  end

  if isempty(alert_message) # Success
    # TODO - What should we give as input?
    TensorNetworkBuildersController.buildnetwork(output_string)
  else
    # TODO - Make better and more descriptive
    println("\n", alert_message)
    println("\nERROR\nERROR\nERROR\nERROR")
    TensorNetworkBuildersController.buildnetwork()
  end
end



route("/dev/hidden/build5") do
  # Initialize variables because of try-catch-block
  alert_message = ""
  computed_tensors = []
  output_tensors = []
  output_string = ""

  try
    # Collect Network History
    frontend_data = build5()

    # Run all steps
    computed_tensors, output_tensors, alert_message = parse_data(frontend_data)

  catch e
    if typeof(e) == String
      alert_message = e
    else
      alert_message = "Invalid Input"
    end
  end

  if isempty(alert_message) # Success
    # TODO - What should we give as input?
    TensorNetworkBuildersController.buildnetwork(output_string)
  else
    # TODO - Make better and more descriptive
    println("\n", alert_message)
    println("\nERROR\nERROR\nERROR\nERROR")
    TensorNetworkBuildersController.buildnetwork()
  end
end

route("/dev/hidden/runalgs1") do
    # Create Tensor Network with all the data collected from the form
    tensor_network = TensorNetwork(uuid=gen_uuid_with_no_hyphens(),
                                   num_tensors=15,
                                   graph_type="mpo",
                                   system="random",
                                   method="multiply",
                                   default_model="heisenbergMPO",
                                   physical_dimension=2,
                                   hamiltonian_constant=1.0,
                                   num_hamiltonian_components=1,
                                   hamiltonian_components=Any[(0.0, "Id", "")],
                                   correlation_flag=true,
                                   correlation_matrix_operators=("Sp", "Sm"),
                                   correlation_function_operators=Any["Sx"],
                                   symmetry_flag=true,
                                   symmetry_set= ("Spin", ["U1"]),
                                   non_uniform_flag=false,
                                   physical_indeces=Any[(Any[2], (-1, -1))])

    TensorNetworksController.DMRGenie(tensor_network)
end


route("/dev/hidden/runalgs2") do
  # Create Tensor Network with all the data collected from the form
  tensor_network = TensorNetwork(uuid=gen_uuid_with_no_hyphens(),
                                 num_tensors=15,
                                 graph_type="mpo",
                                 system="random",
                                 method="multiply",
                                 default_model="hubbardMPO",
                                 physical_dimension=2,
                                 hamiltonian_constant=1.0,
                                 num_hamiltonian_components=1,
                                 hamiltonian_components=Any[(0.0, "Id", "")],
                                 correlation_flag=true,
                                 correlation_matrix_operators=("Sp", "Sm"),
                                 correlation_function_operators=Any["Sx"],
                                 symmetry_flag=false,
                                 symmetry_set= ("Spin", ["U1"]),
                                 non_uniform_flag=false,
                                 physical_indeces=Any[(Any[5], (-1, -1))])

  TensorNetworksController.DMRGenie(tensor_network)
end


route("/dev/hidden/runalgs3") do
  # Create Tensor Network with all the data collected from the form
  tensor_network = TensorNetwork(uuid=gen_uuid_with_no_hyphens(),
                                 num_tensors=15,
                                 graph_type="mpo",
                                 system="random",
                                 method="multiply",
                                 default_model="tjMPO",
                                 physical_dimension=2,
                                 hamiltonian_constant=1.0,
                                 num_hamiltonian_components=1,
                                 hamiltonian_components=Any[(0.0, "Id", "")],
                                 correlation_flag=true,
                                 correlation_matrix_operators=("Sp", "Sm"),
                                 correlation_function_operators=Any["Sx"],
                                 symmetry_flag=true,
                                 symmetry_set= ("Spin", ["U1"]),
                                 non_uniform_flag=false,
                                 physical_indeces=Any[(Any[2], (-1, -1))])

  TensorNetworksController.DMRGenie(tensor_network)
end

route("/dev/hidden/runalgs4") do
  # Create Tensor Network with all the data collected from the form
  tensor_network = TensorNetwork(uuid=gen_uuid_with_no_hyphens(),
                                 num_tensors=15,
                                 graph_type="mpo",
                                 system="random",
                                 method="multiply",
                                 default_model="none",
                                 physical_dimension=2,
                                 hamiltonian_constant=-0.5,
                                 num_hamiltonian_components=7,
                                 hamiltonian_components=Any[(1.0, "Sx", "*"), (1.0, "Sx", "+"), (1.0, "Sy", "*"), (1.0, "Sy", "+"), (1.0, "Sz", "*"), (1.0, "Sz", "+"), (0.05, "Sz", "")],
                                 correlation_flag=true,
                                 correlation_matrix_operators=("Sp", "Sm"),
                                 correlation_function_operators=Any["Sx"],
                                 symmetry_flag=false,
                                 symmetry_set= ("Spin", ["U1"]),
                                 non_uniform_flag=false,
                                 physical_indeces=Any[(Any[2], (-1, -1))])

  TensorNetworksController.DMRGenie(tensor_network)
end





##########
# BOOTUP #
##########

up()

touch("bootup.log")
file = open("bootup.log", "w")
write(file, "INITIALIZATION COMPLETE")
close(file)