(pwd() != @__DIR__) && cd(@__DIR__) # allow starting app from bin/ dir

using TensEZ
const UserApp = TensEZ
TensEZ.main()
