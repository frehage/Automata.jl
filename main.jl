##################
#
# This file is used to execute examples and tests on the DirectedControl Package
#
##################
workspace()

try
    include("src/Automata.jl")
    include("test/runtests.jl")
catch e
    print(e)
end
