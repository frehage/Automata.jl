#workspace()

"""Typealias for the componbents of the automaton."""
typealias State Int
typealias Event Int
typealias Transition Tuple{State,Event,State}

"""A type representing an automaton."""
type Automaton

    """Parameters"""
    states::IntSet
    events::IntSet
    transitions::Set{Transition}
    init::IntSet
    marked::IntSet

    """Verify the input values of the automaton. Decreases efficiency of the code but improves debugging"""
    function Automaton(
            states::IntSet,
            events::IntSet,
            transitions::Set{Transition},
            init::IntSet,
            marked::IntSet
        )

        # Verify transitions
        for (source,event,target) = transitions
            source in states || throw(BoundsError(states, source))
            event in events || throw(BoundsError(states, event))
            target in states || throw(BoundsError(states, target))
        end

        # Verify init states
        for q = init
            if !(q in states)
                throw(BoundsError(states, q))
            end
        end

        # Verify marked states
        for q = marked
            (q in states) || throw(BoundsError(states, q))
        end

        new(states, events, transitions, init, marked)
    end
end
Automaton(nq::Int) = Automaton(IntSet(1:nq), IntSet(), Set{Transition}(), IntSet(), IntSet())
Automaton() = Automaton(0)



#
# States
#
"""Return the states of an automaton."""
states(a::Automaton) = a.states
"""Return the number of states in an automaton."""
ns(a::Automaton) = length(states(a))

"""Add one state to the automaton."""
add_state!(a::Automaton, state::State) = push!(a.states, state)
"""Add set of states to the automaton."""
add_states!(a::Automaton, states::IntSet) = union!(a.states, states)
add_states!(a::Automaton, states::Array{State}) = add_states!(a, IntSet(states))
"""Remove one state from the automaton."""
rem_state!(a::Automaton, state::State) = setdiff!(a.states, state)
"""Remove a set of states from the automaton."""
rem_states!(a::Automaton, states::IntSet) = setdiff!(a.states, states)
rem_states!(a::Automaton, states::Array{State}) = rem_events!(a, IntSet(states))



#
# Events
#
"""Return the events of an automaton."""
events(a::Automaton) = a.events
"""Return the number of events in an automaton."""
ne(a::Automaton) = length(events(a))

"""Add one event to the automaton."""
add_event!(a::Automaton, event::Event) = push!(a.events, event)
"""Add set of events to the automaton."""
add_events!(a::Automaton, events::IntSet) = union!(a.events, events)
add_events!(a::Automaton, events::Array{Int}) = add_events!(a, IntSet(events))
"""Remove one event from the automaton."""
rem_event!(a::Automaton, event::Event) = setdiff!(a.events, event)
"""Remove a set of events from the automaton."""
rem_events!(a::Automaton, events::IntSet) = setdiff!(a.events, events)
rem_events!(a::Automaton, events::Array{Int}) = rem_events!(a, IntSet(events))



#
# Transitions
#
"""Return the transitions of an automaton."""
transitions(a::Automaton) = a.transitions
"""Return the number of transitions in an automaton."""
nt(a::Automaton) = length(transitions(a))

"""Add one transition to the automaton."""
function add_transition!(a::Automaton, transition::Transition)
    transition[1] in states(a) || throw(BoundsError(states(a), transition[1]))
    transition[2] in events(a) || throw(BoundsError(events(a), transition[2]))
    transition[3] in states(a) || throw(BoundsError(states(a), transition[3]))
    push!(a.transitions, transition)
end
"""Add set of transitions to the automaton."""
function add_transitions!(a::Automaton, transitions::IntSet)
    transition[1] in states(a) || throw(BoundsError(states(a), transition[1]))
    transition[2] in events(a) || throw(BoundsError(events(a), transition[2]))
    transition[3] in states(a) || throw(BoundsError(states(a), transition[3]))
    push!(a.transitions, transition)
end
function add_transitions!(a::Automaton, transitions::Set{Transition})
    for transition = transitions
        transition[1] in states(a) || throw(BoundsError(states(a), transition[1]))
        transition[2] in events(a) || throw(BoundsError(events(a), transition[2]))
        transition[3] in states(a) || throw(BoundsError(states(a), transition[3]))
    end
    union!(a.transitions, transitions)
end
add_transitions!(a::Automaton, transitions::Array{Transition}) = add_transitions!(a, Set{Transition}(transitions))

"""Remove a set of transitions from the automaton."""
rem_transitions!(a::Automaton, transitions::Set{Transition}) = setdiff!(a.transitions, transitions)
rem_transitions!(a::Automaton, transitions::Array{Transition}) = rem_transitions!(a, Set{Transition}(transitions))
"""Remove one transition from the automaton."""
rem_transition!(a::Automaton, transition::Transition) = rem_transitions!(a, Set{Transition}([transition]))
