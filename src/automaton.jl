"""Typealias for the componbents of the automaton."""
const State = Int
const Event = Int
const Transition = Tuple{State,Event,State}

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

    """Verify the input values of the automaton. Decreases efficiency of the code but improves debugging"""
    function Automaton(
            ; states = IntSet(),
            events = IntSet(),
            transitions = Set{Transition}(),
            init = IntSet(),
            marked = IntSet(),
            uncontrollable = IntSet()
        )

        # Verify transitions
        for (source,event,target) = transitions
            source in states || throw(BoundsError(states, source))
            event in events || throw(BoundsError(events, event))
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

        controllable = setdiff(events, uncontrollable)
        new(IntSet(states), IntSet(events), Set{Transition}(transitions), IntSet(init), IntSet(marked), IntSet(controllable), IntSet(uncontrollable))
    end
end
Automaton(ns::Int) = Automaton(states = IntSet(1:ns))
Automaton(ns::Int, ne::Int; transitions = Set{Transition}(), init = IntSet(), marked = IntSet(), uncontrollable = IntSet()) =
    Automaton(states = IntSet(1:ns), events = IntSet(1:ne), transitions = transitions, init = init, marked = marked, uncontrollable = uncontrollable)

##
# States
#
"""Return the states of an automaton."""
states(a::Automaton) = a.states
"""Return the number of states in an automaton."""
ns(a::Automaton) = length(states(a))
init(a::Automaton) = a.init
marked(a::Automaton) = a.marked

"""Add one state to the automaton."""
function add_state!(a::Automaton, state::State, init::Bool = false, marked::Bool = false)
    push!(a.states, state)
    !init || push!(a.init, state)
    !marked || push!(a.marked, state)
    a.states
end
"""Add set of states to the automaton."""
function add_states!(a::Automaton, states, init = IntSet(), marked = IntSet())
    union!(a.states, states)
    union!(a.init, init)
    union!(a.marked, marked)
    a.states
end
"""Remove one or multiple states from the automaton."""
function rem_states!(a::Automaton, states)
    setdiff!(a.states, states)
    setdiff!(a.init, states)
    setdiff!(a.marked, states)
    a.states
end



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
source(t::Transition) = t[1]
event(t::Transition) = t[2]
target(t::Transition) = t[3]

"""Add one transition to the automaton."""
function add_transition!(a::Automaton, t::Transition)
    source(t) in states(a) || throw(BoundsError(states(a), source(t)))
    event(t) in events(a) || throw(BoundsError(events(a), event(t)))
    target(t) in states(a) || throw(BoundsError(states(a), target(t)))
    push!(a.transitions, t)
end

"""Add set of transitions to the automaton."""
function add_transitions!(a::Automaton, transitions)
    for t = transitions
        typeof(t) == Transition || throw(ArgumentError("transitions requires a collection of ::Transition, error on: ($(source(t)),$(event(t)),$(target(t)))"))
        source(t) in states(a) || throw(BoundsError(states(a), source(t)))
        event(t) in events(a) || throw(BoundsError(events(a), event(t)))
        target(t) in states(a) || throw(BoundsError(states(a), target(t)))
    end
    union!(a.transitions, transitions)
end
"""Remove a set of transitions from the automaton."""
rem_transitions!(a::Automaton, transitions) = setdiff!(a.transitions, transitions)
"""Remove one transition from the automaton."""
rem_transitions!(a::Automaton, transition::Transition) = rem_transitions!(a, Set{Transition}([transition]))

##
# The default output format
#
function ==(a::Automaton, b::Automaton)
  na=fieldnames(a)
  for n in 1:length(na)
     if getfield(a,na[n])!=getfield(b,na[n])
        return false
     end
  end
  return true
end
function show(io::IO,a::Automaton)
    print(io, "Automata.Automaton(
        states: {", join(a.states, ","), "}
        events: {", join(a.events, ","), "}
        transitions: {", join(a.transitions, ","), "}
        init: {", join(a.init, ","), "}
        marked: {", join(a.marked, ","), "}
        controllable: {", join(a.controllable, ","), "}
        uncontrollable: {", join(a.uncontrollable, ","), "}
    )")
end

#=function plot(a::Automaton)

    error("Ploting is not yet working...")
    # TODO: The edgelabels don't map correctly to the edges (the sorting is different).
    # TODO: Potential problem when there are multiple transitions from state a to state b.
    # TODO: Fix an assertion to prevent multiple zero degree vertices

    # create a graph representation
    g = DiGraph(ns(a))
    vertices = collect(states(a))
    edgelabel = ["$(event(t) in uncontrollable(a) ? "!" : "")$(event(t))" for t in transitions(a)]
    for t in transitions(a)
        add_edge!(g,findfirst(vertices .== source(t)),findfirst(vertices .== target(t)))
    end

    for v in LightGraphs.vertices(g)
        @assert length(in_edges(g,v)) + length(out_edges(g,v)) > 0 "No zero degree vertex allowed when plotting: vertex $(v) has no neighbor."
    end

    # Color the graph, init=blue, marked=green, default=lightblue
    membership = [s in init(a) ? 1 : (s in marked(a) ? 2 : 3) for s in states(a)]
    nodecolor = [colorant"blue", colorant"green", colorant"lightblue"]
    nodefillc = nodecolor[membership]

    # Find a new filename
    count = 1; while isfile(joinpath(pwd(), "Automaton$(count).pdf")); count += 1; end;
    file_name = "Automaton$(count).pdf"

    # draw the automaton to a file
    draw(PDF(file_name, 16cm, 16cm), gplot(
                g,

                nodefillc=nodefillc,
                nodelabel=vertices,

                edgelabel=edgelabel,
                edgelabeldistx=0.5,
                edgelabeldisty=0.5
            ))


end=#
