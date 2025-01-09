module TensorNetworks

  import SearchLight: AbstractModel, DbId
  import Base: @kwdef
  using DMRJtensor
  using UUIDs

  export TensorNetwork

  # TODO - Add safety using available strings
  @kwdef mutable struct TensorNetwork <: AbstractModel
    id::DbId = DbId()
    uuid::String = "" # UUID set in routes
    num_tensors::Int64 = 3

    graph_type::String = "mpo"
    available_graph_types::Vector{String} = ["scalar", "vector", "matrix", "mps", "mpo", "peps", "mera"]

    system::String = "random"
    available_systems::Vector{String} = ["random", "input"]

    method::String = "multiply"
    available_methods::Vector{String} = ["multiply", "contract", "svd"]

    default_model::String = "heisenbergMPO"
    available_models::Vector{String} = ["none", "heisenbergMPO", "hubbardMPO", "tjMPO"]

    correlation_flag::Bool = false
    correlation_matrix_operators::Tuple{String, String} = ("Id", "Id")
    correlation_function_operators::Vector{String} = ["Id"]

    physical_dimension::Int64 = 2
    hamiltonian_constant::Number = 1
    num_hamiltonian_components::Int64 = 0
    hamiltonian_components::Vector{Tuple{Float64, String, String}} = []

    symmetry_flag::Bool = false
    # A symmetry_sets object takes the form ("Spin", ["U1", "Zn{5}", ...])
    symmetry_set::Tuple{String, Vector{String}} = ("", [])

    non_uniform_flag::Bool = false
    #                                            <physical idx>  <range>
    # A physical_indeces object takes the form [([1, 5, 1, ...], (1, 10)), ...]
    physical_indeces::Vector{Tuple{Vector{Int64}, Tuple{Int64, Int64}}} = []
  end

end

