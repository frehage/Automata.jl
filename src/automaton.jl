#workspace()

"""Typealias for the componbents of the automaton."""
typealias State Int
typealias Event Int
typealias Transition Tuple{State,Event,State}

"""A type representing an automaton."""
type Automaton

    """Parameters"""
    states::Set{State}
    events::Set{Event}
    transitions::Set{Transition}
    init::Set{State}
    marked::Set{State}

    """Verify the input values of the automaton. Decreases efficiency of the code but improves debugging"""
    function Automaton(
            states::Set{State},
            events::Set{Event},
            transitions::Set{Transition},
            init::Set{State},
            marked::Set{State}
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
Automaton(nq::Int) = Automaton(Set{State}(1:nq), Set{Event}(), Set{Transition}(), Set{State}(), Set{State}())
Automaton(nq::Int) = Automaton(Set{State}(1:nq), Set{Event}(), Set{Transition}(), Set{State}(), Set{State}())
Automaton() = Automaton(0)


"""Return the states of an automaton."""
states(a::Automaton) = a.states

"""Return the number of states in an automaton."""
ns(a::Automaton) = length(states(a))
