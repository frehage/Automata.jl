#__precompile__(true)

module Automata

# Dependencies of the graph visualization in plot(::Automaton)
#using LightGraphs       # For Graph representation
#using GraphPlot         # For graph visualization
#using Colors            # For coloring of the nodes
#using Compose           # For drawing to file

# used by the synch
using DataStructures    # For Queue

import Base: ==, show

export
    # Automaton
    Automaton, State, Event, Transition, # type defs
    states, ns, add_state!, add_states!, rem_state!, rem_states!, # funcitons for states
    events, ne, add_event!, add_events!, rem_event!, rem_events!, controllable, uncontrollable, disturbance,# funcitons for events
    transitions, nt, add_transition!, add_transitions!, rem_transition!, rem_transitions!,  # funcitons for transitions
    source,event,target, # elements in a transition
    init, marked, # lists init/marked states
    get_details, # return only number of states, events and transitions. Used for large Automaton

    # TimedAutomaton
    TimedAutomaton, # type defs
    durations, duration,

    # Syncronization
    sync

# source files
include("automaton.jl")
include("timed_automaton.jl")
include("synchronization.jl")

end
