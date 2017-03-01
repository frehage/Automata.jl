#__precompile__(true)

module Automata
export
    # Automaton
    Automaton, State, Event, Transition,
    states, ns, events, ne,
    add_state!, add_states!, rem_state!, rem_states!,
    add_event!, add_events!, rem_event!, rem_events!

Automata

# source files
include("automaton.jl")
#include("automata.jl")

end
