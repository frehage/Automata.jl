"""A type representing an automaton with time duration on each transition."""
type TimedAutomaton

    """TimedAutomaton.automaton::Automaton - The element representing the basic automaton"""
    automaton::Automaton

    """TimedAutomaton.transitions::Dict{Event, Float64} - A dictionary representing the duration of each transition"""
    durations::Dict{Transition,Float64}

    """Verify the input values of the automaton. Decreases efficiency of the code but improves debugging"""
    function TimedAutomaton(
            automaton::Automaton = Automaton(),
            durations = Dict{Transition,Float64}()
        )

        # Verify number of durations
        if length(durations) == 0
            nt(automaton) == 0 || throw(ArgumentError("Number of durations specified must be > than the number of transitions in the underlying automaton."))
        else
            (length(durations) >= length(automaton.transitions)) || throw(ArgumentError("Number of durations specified must be > than the number of transitions in the underlying automaton."))
            for (t,d) in durations
                t in transitions(automaton) || add_transition!(automaton, t)
            end
        end

        new(automaton, durations)
    end
end
TimedAutomaton(;durations = Dict{Transition,Float64}()) =
    TimedAutomaton(
        Automaton(transitions=collect(keys(durations))),
        durations
    )

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
disturbance(ta::TimedAutomaton) = disturbance(ta.automaton)
"""Return the number of events in an automaton."""
ne(ta::TimedAutomaton) = ne(ta.automaton)
"""Return the transitions of an automaton."""
transitions(ta::TimedAutomaton) = transitions(ta.automaton)
"""Return the number of transitions in an automaton."""
nt(ta::TimedAutomaton) = nt(ta.automaton)
"""Add one transition to the automaton."""
function add_transition!(ta::TimedAutomaton, transition::Pair{Transition,Float64})
    add_transition!(ta.automaton, transition[1])
    push!(ta.durations, transition)
end
"""Add set of transitions to the automaton."""
function add_transitions!(ta::TimedAutomaton, transitions::Dict{Transition,Float64})
    for t in transitions
        add_transition!(ta, t)
    end
end
"""Remove one transition from the automaton."""
function rem_transition!(ta::TimedAutomaton, transition::Transition)
    delete!(ta.automaton.transitions, transition)
    delete!(ta.durations, transition)
end
"""Remove a set of transitions from the automaton."""
function rem_transitions!(ta::TimedAutomaton, transitions)
    for t in transitions
        rem_transition!(ta, t)
    end
end

##
# Durations
#
"""Return ::Dict{Event,Float64} with durations of all events."""
durations(ta::TimedAutomaton) = ta.durations
"""Return the duration of a specifc event."""
duration(ta::TimedAutomaton, t::Transition) = ta.durations[t]


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
        events: {", join(ta.automaton.events, ","), "}
        transitions: {", join(["($s,$e,$t) => $(ta.durations[(s,e,t)])" for (s,e,t) in ta.automaton.transitions],","), "}
        init: {", join(ta.automaton.init, ","), "}
        marked: {", join(ta.automaton.marked, ","), "}
        controllable: {", join(ta.automaton.controllable, ","), "}
        uncontrollable: {", join(ta.automaton.uncontrollable, ","), "}
        disturbance: {", join(ta.automaton.disturbance, ","), "}
    )")
end
get_details(ta::TimedAutomaton) = get_details(ta.automaton)

# plot(ta::TimedAutomaton) = plot(ta.automaton)
|
