######################################
# Testset for the type Automaton.
######################################

###
# Test the constructors and the generated objects
###

# Test the parameter values of newly created objects
a = Automaton()
@test a.states == states(a) == events(a) == init(a) == marked(a) == IntSet()
@test ns(a) == length(states(a)) == 0
a = Automaton(5)
@test states(a) == IntSet(1:5)
@test ns(a) == 5
a = Automaton(5,5)
@test states(a) == events(a) == IntSet(1:5)
@test ns(a) == ne(a) == 5

# Uncontrollable events
a = Automaton(states=[1,2], events=[1,2], transitions=[(1,1,2)], uncontrollable=[2])
@test a.controllable == controllable(a) == IntSet([1])
@test a.uncontrollable == uncontrollable(a) == IntSet([2])

# Test transitions.
@test_throws BoundsError Automaton(states=[1],events=[1], transitions=[(1,1,2)])
@test_throws BoundsError Automaton(states=[1],events=[1], transitions=[(2,1,1)])
@test_throws BoundsError Automaton(states=[1],events=[1], transitions=[(1,2,1)])
# Test init states.
@test_throws BoundsError Automaton(init=[1])
# Test marked states.
@test_throws BoundsError Automaton(marked=[1])

###
# Test the different functions
###

# Test manipulation of states.
a = Automaton()
@test add_state!(a, 1) == IntSet([1])
@test add_state!(a, 1) == IntSet([1])
@test add_states!(a, IntSet([6,9])) == IntSet([1, 6, 9])
@test add_states!(a, [7,8]) == IntSet([1, 6, 7, 8, 9])
@test rem_states!(a, 1) == IntSet([6, 7, 8, 9])
@test rem_states!(a, 1) == IntSet([6, 7, 8, 9])
@test rem_states!(a, IntSet([6,9])) == IntSet([7, 8])
@test rem_states!(a, [7,8]) == IntSet()

# Test manipulation of events.
a = Automaton()
@test add_event!(a, 1) == IntSet([1])
@test add_event!(a, 1, true) == IntSet([1])
@test add_events!(a, IntSet([6,9])) == IntSet([1, 6, 9])
@test add_events!(a, [7,8]) == IntSet([1, 6, 7, 8, 9])
@test controllable(a) == IntSet([6, 7, 8, 9])
@test uncontrollable(a) == IntSet([1])
@test rem_events!(a, 1) == IntSet([6, 7, 8, 9])
@test uncontrollable(a) == IntSet()
@test rem_events!(a, 1) == IntSet([6, 7, 8, 9])
@test rem_events!(a, IntSet([6,9])) == IntSet([7, 8])
@test rem_events!(a, [7,8]) == IntSet()
@test controllable(a) == IntSet()

# Test manipulation of transitions.
a = Automaton()
add_states!(a,[1,2,3])
add_events!(a,[1,2])
@test add_transition!(a, (1,1,1)) == Set{Transition}([(1,1,1)])
@test add_transition!(a, (1,1,1)) == Set{Transition}([(1,1,1)])
@test add_transitions!(a, Set{Transition}([(1,1,2),(1,2,2)])) == Set{Transition}([(1,1,1), (1,1,2), (1,2,2)])
@test add_transitions!(a, [(1,1,3),(1,2,3)]) == Set{Transition}([(1,1,1), (1,1,2), (1,2,2), (1,1,3), (1,2,3)])
@test_throws BoundsError add_transition!(a, (1,1,4))
@test rem_transitions!(a, (1,1,1)) == Set{Transition}([(1,1,2), (1,2,2), (1,1,3), (1,2,3)])
@test rem_transitions!(a, Set{Transition}([(1,1,2),(1,2,2)])) == Set{Transition}([(1,1,3), (1,2,3)])
@test rem_transitions!(a, [(1,1,3)]) == Set{Transition}([(1,2,3)])

# Test the show function
a = Automaton(states=1:2, events=1:2, transitions=[(1,1,2),(2,2,1)], init=[1], marked=[2], uncontrollable=[2])
originalSTDOUT = STDOUT
(outRead, outWrite) = redirect_stdout()
show(a)
close(outWrite)
data = String(readavailable(outRead))
close(outRead)
redirect_stdout(originalSTDOUT)
@test data == "Automata.Automaton(
        states: {1,2}
        events: {1,2}
        transitions: {(2,2,1),(1,1,2)}
        init: {1}
        marked: {2}
        controllable: {1}
        uncontrollable: {2}
    )"
