"""A type representing an automaton with time duration on each transition."""
type TimedAutomaton

    """TimedAutomaton.automaton::Automaton - The element representing the basic automaton"""
    automaton::Automaton

    """TimedAutomaton.transitions::Dict{Transition, Int64} - A dictionary representing the duration of each transition"""
    transitions::Dict{Transition, Int64}

    """Verify the input values of the automaton. Decreases efficiency of the code but improves debugging"""
    function TimedAutomaton(
            automaton = Automaton(),
            transitions = Dict{Transition, Int64}()
        )

        # Verify uncontrollable events
        (length(transitions) == nt(automaton)) || throw(ArgumentError("Nubmer of duration specified must equal number of transitions."))

        new(automaton, transitions)
    end
end
function TimedAutomaton(transitions::Dict{Transition, Int64})
    a = Automaton()
    for (transition,duration) in transitions
        add_state!(a, source(transition))
        add_event!(a, event(transition))
        add_state!(a, target(transition))
        add_transition!(a, transition)
    end
    return TimedAutomaton(a, transitions)
end

##
# Transitions
#
"""Return the transitions of an automaton."""
transitions(a::TimedAutomaton) = a.transitions
"""Return the number of transitions in an automaton."""
nt(a::TimedAutomaton) = length(transitions(a))
"""Return the duration of a specifc transition."""
duration(a::TimedAutomaton, t::Transition) = a.transitions[t]


##
# The default output format
#
import Base.show
function show(io::IO,ta::TimedAutomaton)
    print(io, "Automata.TimedAutomaton(
        states: {", join(ta.automaton.states, ","), "}
        events: {", join(ta.automaton.events, ","), "}
        transitions: {", join(["$k => $v" for (k,v) in ta.transitions],","), "}
        init: {", join(ta.automaton.init, ","), "}
        marked: {", join(ta.automaton.marked, ","), "}
        controllable: {", join(ta.automaton.controllable, ","), "}
        uncontrollable: {", join(ta.automaton.uncontrollable, ","), "}
    )")
end

plot(ta::TimedAutomaton) = plot(ta.automaton)
