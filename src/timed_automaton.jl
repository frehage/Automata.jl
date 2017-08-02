"""A type representing an automaton with time duration on each transition."""
type TimedAutomaton

    """TimedAutomaton.automaton::Automaton - The element representing the basic automaton"""
    automaton::Automaton

    """TimedAutomaton.transitions::Dict{Event, Int64} - A dictionary representing the duration of each event"""
    durations::Array{Int64,1}

    """Verify the input values of the automaton. Decreases efficiency of the code but improves debugging"""
    function TimedAutomaton(
            automaton = Automaton(),
            durations = Array{Int64,1}()
        )

        # Verify number of durations
        (length(durations) == maximum(events(automaton))) || throw(ArgumentError("Nubmer of durations specified must equal number of events in the underlying automaton."))

        new(automaton, durations)
    end
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
"""Return ::Dict{Event,Int64} with durations of all events."""
durations(ta::TimedAutomaton) = ta.durations
"""Return the duration of a specifc event."""
duration(ta::TimedAutomaton, e::Event) = ta.durations[e]


##
# Utility functions for comparison and output
#
function ==(a::TimedAutomaton, b::TimedAutomaton)
  na=fieldnames(a)
  for n in 1:length(na)
     if getfield(a,na[n])!=getfield(b,na[n])
        return false
     end
  end
  return true
end

function show(io::IO,ta::TimedAutomaton)
    print(io, "Automata.TimedAutomaton(
        states: {", join(ta.automaton.states, ","), "}
        events: {", join(["$k => $(ta.durations[k])" for k in events(ta.automaton)], ","), "}
        transitions: {", join(["($s,$e,$t)" for (s,e,t) in ta.automaton.transitions],","), "}
        init: {", join(ta.automaton.init, ","), "}
        marked: {", join(ta.automaton.marked, ","), "}
        controllable: {", join(ta.automaton.controllable, ","), "}
        uncontrollable: {", join(ta.automaton.uncontrollable, ","), "}
    )")
end

# plot(ta::TimedAutomaton) = plot(ta.automaton)
