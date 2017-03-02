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
            ; states = IntSet(),
            events = IntSet(),
            transitions = Set{Transition}(),
            init = IntSet(),
            marked = IntSet()
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

        new(IntSet(states), IntSet(events), Set{Transition}(transitions), IntSet(init), IntSet(marked))
    end
end
Automaton(ns::Int) = Automaton(states = IntSet(1:ns))

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
add_states!(a::Automaton, states) = union!(a.states, states)
"""Remove one state from the automaton."""
rem_state!(a::Automaton, state::State) = setdiff!(a.states, state)
"""Remove a set of states from the automaton."""
rem_states!(a::Automaton, states) = setdiff!(a.states, states)



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
add_events!(a::Automaton, events) = union!(a.events, events)
"""Remove one event from the automaton."""
rem_event!(a::Automaton, event::Event) = setdiff!(a.events, event)
"""Remove a set of events from the automaton."""
rem_events!(a::Automaton, events) = setdiff!(a.events, events)



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
function add_transitions!(a::Automaton, transitions)
    for transition = transitions
        typeof(transitions) == Transition
        transition[1] in states(a) || throw(BoundsError(states(a), transition[1]))
        transition[2] in events(a) || throw(BoundsError(events(a), transition[2]))
        transition[3] in states(a) || throw(BoundsError(states(a), transition[3]))
    end
    union!(a.transitions, transitions)
end
"""Remove a set of transitions from the automaton."""
rem_transitions!(a::Automaton, transitions) = setdiff!(a.transitions, transitions)
"""Remove one transition from the automaton."""
rem_transition!(a::Automaton, transition::Transition) = rem_transitions!(a, Set{Transition}([transition]))
