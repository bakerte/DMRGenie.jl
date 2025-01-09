module DMRGenie

using Genie

const up = Genie.up
export up

function main()
  # Clear the bootup log
  run(`rm bootup.log`)
  touch("bootup.log")

  Genie.genie(; context = @__MODULE__)
end

end
