#__precompile__(true)

module Automata
export
    # Automaton
    Automaton, State, Event, Transition,
    states, ns, events, ne,
    add_state!, add_states!, rem_state!, rem_states!,
    add_event!, add_events!, rem_event!, rem_events!, controllable, uncontrollable,
    add_transition!, add_transitions!, rem_transition!, rem_transitions!

Automata

# source files
include("automaton.jl")
#include("automata.jl")

end
