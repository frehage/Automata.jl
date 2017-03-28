"""A type representing an automaton with time duration on each transition."""
type TimedAutomaton

    """TimedAutomaton.automaton::Automaton - The element representing the basic automaton"""
    automaton::Automaton

    """TimedAutomaton.transitions::Dict{Transition, Int64} - A dictionary representing the duration of each transition"""
    durations::Dict{Transition, Int64}

    """Verify the input values of the automaton. Decreases efficiency of the code but improves debugging"""
    function TimedAutomaton(
            automaton = Automaton(),
            durations = Dict{Transition, Int64}()
        )

        # Verify uncontrollable events
        (length(durations) == nt(automaton)) || throw(ArgumentError("Nubmer of durations specified must equal number of transitions in the underlying automaton."))

        new(automaton, durations)
    end
end
function TimedAutomaton(durations::Dict{Transition, Int64})
    a = Automaton()
    for (transition,duration) in durations
        add_state!(a, source(transition))
        add_event!(a, event(transition))
        add_state!(a, target(transition))
        add_transition!(a, transition)
    end
    return TimedAutomaton(a, durations)
end

##
# Automaton functions
#
"""Return the states of an automaton."""
states(ta::TimedAutomaton) = states(ta.automaton)
"""Return the number of states in an automaton."""
ns(ta::TimedAutomaton) = ns(ta.automaton)
init(ta::TimedAutomaton) = init(ta.automaton)
marked(ta::TimedAutomaton) = marked(ta.automaton)
"""Return the events of an automaton."""
events(ta::TimedAutomaton) = events(ta.automaton)
controllable(ta::TimedAutomaton) = controllable(ta.automaton)
uncontrollable(ta::TimedAutomaton) = uncontrollable(ta.automaton)
"""Return the number of events in an automaton."""
ne(ta::TimedAutomaton) = ne(ta.automaton)
"""Return the transitions of an automaton."""
transitions(ta::TimedAutomaton) = transitions(ta.automaton)
"""Return the number of transitions in an automaton."""
nt(ta::TimedAutomaton) = nt(ta.automaton)

##
# Durations
#
"""Return ::Dict{Transition,Int64} with durations of all transitions."""
durations(ta::TimedAutomaton) = ta.durations
"""Return the duration of a specifc transition."""
duration(ta::TimedAutomaton, t::Transition) = ta.durations[t]


##
# The default output format
#
import Base.show
function show(io::IO,ta::TimedAutomaton)
    print(io, "Automata.TimedAutomaton(
        states: {", join(ta.automaton.states, ","), "}
        events: {", join(ta.automaton.events, ","), "}
        transitions: {", join(["$k => $v" for (k,v) in ta.durations],","), "}
        init: {", join(ta.automaton.init, ","), "}
        marked: {", join(ta.automaton.marked, ","), "}
        controllable: {", join(ta.automaton.controllable, ","), "}
        uncontrollable: {", join(ta.automaton.uncontrollable, ","), "}
    )")
end

plot(ta::TimedAutomaton) = plot(ta.automaton)
