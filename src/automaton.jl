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
    controllable::IntSet
    uncontrollable::IntSet

    function Automaton(
            states::IntSet,
            events::IntSet,
            transitions::Set{Transition},
            init::IntSet,
            marked::IntSet,
            controllable::IntSet,
            uncontrollable::IntSet
        )
        new(states, events, transitions, init, marked, controllable, uncontrollable)
    end

    """Verify the input values of the automaton. Decreases efficiency of the code but improves debugging"""
    function Automaton(
            ; states = IntSet(),
            events = IntSet(),
            transitions = Set{Transition}(),
            init = IntSet(),
            marked = IntSet(),
            uncontrollable = IntSet()
        )

        events = IntSet(events)
        uncontrollable = IntSet(uncontrollable)

        # Verify transitions
        for (source,event,target) = transitions
            source in states || throw(BoundsError(states, source))
            event in events || throw(BoundsError(states, event))
            target in states || throw(BoundsError(states, target))
        end

        # Verify init states
        for q = init
            (q in states) || throw(BoundsError(states, q))
        end

        # Verify marked states
        for q = marked
            (q in states) || throw(BoundsError(states, q))
        end

        # Verify uncontrollable events
        for e = uncontrollable
            (e in events) || throw(BoundsError(events, e))
        end

        new(IntSet(states), events, Set{Transition}(transitions), IntSet(init), IntSet(marked), setdiff(events, uncontrollable), uncontrollable)
    end
end
Automaton(ns::Int) = Automaton(states = IntSet(1:ns))
Automaton(ns::Int, ne::Int) = Automaton(states = IntSet(1:ns), events = IntSet(1:ne))
Automaton(ns::Int, ne::Int) = Automaton(states = IntSet(1:ns), events = IntSet(1:ne))

##
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
"""Remove one or multiple states from the automaton."""
rem_states!(a::Automaton, states) = setdiff!(a.states, states)



##
# Events
#
"""Return the events of an automaton."""
events(a::Automaton) = a.events
controllable(a::Automaton) = a.controllable
uncontrollable(a::Automaton) = a.uncontrollable
"""Return the number of events in an automaton."""
ne(a::Automaton) = length(events(a))

"""Add one event to the automaton."""
add_event!(a::Automaton, event::Event) = push!(a.events, event)
function add_event!(a::Automaton, event::Event, uncontrollable::Bool = false)
    if uncontrollable
        setdiff!(a.controllable, event)
        push!(a.uncontrollable, event)
    else
        setdiff!(a.uncontrollable, event)
        push!(a.controllable, event)
    end
    push!(a.events, event)
end
"""Add set of events to the automaton."""
function add_events!(a::Automaton, events, uncontrollable::IntSet = IntSet())
    controllable = setdiff(events, uncontrollable)
    setdiff!(a.uncontrollable, controllable)
    union!(a.uncontrollable, uncontrollable)
    setdiff!(a.controllable, uncontrollable)
    union!(a.controllable, controllable)
    union!(a.events, events)
end
"""Remove one or multiple event from the automaton."""
function rem_events!(a::Automaton, events)
    setdiff!(a.controllable, events)
    setdiff!(a.uncontrollable, events)
    setdiff!(a.events, events)
end



##
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
rem_transitions!(a::Automaton, transition::Transition) = rem_transitions!(a, Set{Transition}([transition]))
