#__precompile__(true)

module Automata
export
    # Automaton
    Automaton, State, Event, Transition, states, ns,
    add_state!, add_states!, rem_state!, rem_states!

Automata

# source files
include("automaton.jl")
#include("automata.jl")

end
