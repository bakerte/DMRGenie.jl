module TensorNetworkBuilders

import SearchLight: AbstractModel, DbId
import Base: @kwdef

export TensorNetworkBuilder

@kwdef mutable struct TensorNetworkBuilder <: AbstractModel
  id::DbId = DbId()
end

end
