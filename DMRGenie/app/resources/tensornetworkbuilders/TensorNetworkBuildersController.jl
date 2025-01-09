module TensorNetworkBuildersController
  using Genie.Renderer.Html
  using DMRJtensor
  using TensorPACK
  # using DMRGenie.TensorNetworks

  function buildnetwork()
    clear_usergenerated_folder()
    html(:tensornetworkbuilders, :buildnetwork, outputPath = "VOID", error="")
  end

  function buildnetwork(outputPath)
    html(:tensornetworkbuilders, :buildnetwork, outputPath = outputPath, error="")
  end

  function backendError(error)
    html(:tensornetworkbuilders, :buildnetwork, outputPath = "VOID", error = error)
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

end
