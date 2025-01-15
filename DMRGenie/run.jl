import Pkg
Pkg.instantiate()
Pkg.activate(".")

using Genie
Genie.loadapp()

if Sys.islinux()
    run(`xdg-open http://127.0.0.1:8000`)
elseif Sys.iswindows()
    run(`start http://127.0.0.1:8000`)
elseif Sys.isapple()
    run(`open http://127.0.0.1:8000`)
else
    println("Unknown operating system!\nOpen website manually at http://127.0.0.1:8000")
end