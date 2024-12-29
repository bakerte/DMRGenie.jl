###############################################################################
#
#  Density Matrix Renormalization Group as a GUI in Genie (DMRGenie)
#                               v1.0
#
###############################################################################
# Made by Aaron Dayton, Kiana Gallagher, Thomas E. Baker and « les qubits volants » (2024)
# See accompanying license with this program
# This code is native to the julia programming language (v1.11.0+)
#

module DMRGenie

using DMRJtensor
using TensorPACK

psi = randMPS(2,100)
mpo = makeMPO(XXZ,2,100)
dmrg(psi,mpo,sweeps=300,goal=1E-10,cutoff=1E-9,m=100)

println("Success! This is where DMRGenie will boot from in a subsequent push and produce the GUI on a machine")

end