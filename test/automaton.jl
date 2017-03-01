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
@test_throws ArgumentError Automaton(IntSet([1]), IntSet([1]), Set{Transition}([(1,1,2)]), IntSet(), IntSet())
@test_throws ArgumentError Automaton(IntSet([1]), IntSet([1]), Set{Transition}([(2,1,1)]), IntSet(), IntSet())
@test_throws ArgumentError Automaton(IntSet([1]), IntSet([1]), Set{Transition}([(1,2,1)]), IntSet(), IntSet())
# Test init states.
@test_throws ArgumentError Automaton(IntSet(), IntSet(), Set{Transition}(), IntSet([1]), IntSet())
# Test marked states.
@test_throws ArgumentError Automaton(IntSet(), IntSet(), Set{Transition}(), IntSet(), IntSet([1]))

###
# Test the different functions
###

a = Automaton()
# Test manipulation of states.
@test add_state!(a, 1) == IntSet([1])
@test add_state!(a, 1) == IntSet([1])
@test add_states!(a, IntSet([6,9])) == IntSet([1, 6, 9])
@test add_states!(a, [7,8]) == IntSet([1, 6, 7, 8, 9])
@test rem_state!(a, 1) == IntSet([6, 7, 8, 9])
@test rem_state!(a, 1) == IntSet([6, 7, 8, 9])
@test rem_states!(a, IntSet([6,9])) == IntSet([7, 8])
@test rem_states!(a, [7,8]) == IntSet()
