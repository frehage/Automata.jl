using Automata
using Base.Test

tests = [
    "automaton"
    "timed_automaton"
    "synchronization"
]

testdir = dirname(@__FILE__)
for t in tests
    tp = joinpath(testdir,"$(t).jl")
    println("running test for: $(t).jl ...")
    include(tp)
end
println("done testing ...")
