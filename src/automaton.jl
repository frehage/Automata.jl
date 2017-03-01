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
            if !(source in states && event in events && target in states)
                throw(ArgumentError("Invalid set of transitions: ($(source),$(event),$(target)) not in states or events"))
            end
        end

        # Verify init states
        for q = init
            if !(q in states)
                throw(ArgumentError("Invalid set of initial states: $(q) not in states"))
            end
        end

        # Verify marked states
        for q = marked
            if !(q in states)
                throw(ArgumentError("Invalid set of marked states: $(q) not in states"))
            end
        end

        new(states, events, transitions, init, marked)
    end
end
Automaton(nq::Int) = Automaton(IntSet(1:nq), IntSet(), Set{Transition}(), IntSet(), IntSet())
Automaton() = Automaton(0)


"""Return the states of an automaton."""
states(a::Automaton) = a.states

"""Return the number of states in an automaton."""
ns(a::Automaton) = length(states(a))

"""Add one state to the automaton."""
add_state!(a::Automaton, state::State) = push!(a.states, state)
"""Add set of states to the automaton."""
add_states!(a::Automaton, states::IntSet) = union!(a.states, states)
add_states!(a::Automaton, states::Array{Int}) = add_states!(a, IntSet(states))

"""Remove one state from the automaton."""
rem_state!(a::Automaton, state::State) = setdiff!(a.states, state)
"""Remove a set of states from the automaton."""
rem_states!(a::Automaton, states::IntSet) = setdiff!(a.states, states)
rem_states!(a::Automaton, states::Array{Int}) = rem_states!(a, IntSet(states))
