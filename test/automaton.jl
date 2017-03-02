######################################
# Testset for the type Automaton.
######################################

###
# Test the constructors and the generated objects
###

# Test the parameter values of newly created objects
a = Automaton()
@test a.states == states(a) == IntSet()
@test ns(a) == length(states(a)) == 0
a = Automaton(5)
@test a.states == states(a) == IntSet(1:5)
@test ns(a) == length(states(a)) == 5

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
@test rem_state!(a, 1) == IntSet([6, 7, 8, 9])
@test rem_state!(a, 1) == IntSet([6, 7, 8, 9])
@test rem_states!(a, IntSet([6,9])) == IntSet([7, 8])
@test rem_states!(a, [7,8]) == IntSet()

# Test manipulation of events.
a = Automaton()
@test add_event!(a, 1) == IntSet([1])
@test add_event!(a, 1) == IntSet([1])
@test add_events!(a, IntSet([6,9])) == IntSet([1, 6, 9])
@test add_events!(a, [7,8]) == IntSet([1, 6, 7, 8, 9])
@test rem_event!(a, 1) == IntSet([6, 7, 8, 9])
@test rem_event!(a, 1) == IntSet([6, 7, 8, 9])
@test rem_events!(a, IntSet([6,9])) == IntSet([7, 8])
@test rem_events!(a, [7,8]) == IntSet()

# Test manipulation of transitions.
a = Automaton()
add_states!(a,[1,2,3])
add_events!(a,[1,2])
@test add_transition!(a, (1,1,1)) == Set{Transition}([(1,1,1)])
@test add_transition!(a, (1,1,1)) == Set{Transition}([(1,1,1)])
@test add_transitions!(a, Set{Transition}([(1,1,2),(1,2,2)])) == Set{Transition}([(1,1,1), (1,1,2), (1,2,2)])
@test add_transitions!(a, [(1,1,3),(1,2,3)]) == Set{Transition}([(1,1,1), (1,1,2), (1,2,2), (1,1,3), (1,2,3)])
@test_throws BoundsError add_transition!(a, (1,1,4))
@test rem_transition!(a, (1,1,1)) == Set{Transition}([(1,1,2), (1,2,2), (1,1,3), (1,2,3)])
@test rem_transitions!(a, Set{Transition}([(1,1,2),(1,2,2)])) == Set{Transition}([(1,1,3), (1,2,3)])
@test rem_transitions!(a, [(1,1,3)]) == Set{Transition}([(1,2,3)])
