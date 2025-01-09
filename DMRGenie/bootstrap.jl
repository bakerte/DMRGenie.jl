(pwd() != @__DIR__) && cd(@__DIR__) # allow starting app from bin/ dir

using DMRGenie
const UserApp = DMRGenie
DMRGenie.main()
