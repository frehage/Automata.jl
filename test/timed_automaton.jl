######################################
# Testset for the type TimedAutomaton.
######################################

###
# Test the constructors and the generated objects
###

# Test the parameter values of newly created objects
a = Automaton(states=1:2,events=1:2,transitions=[(1,1,2),(2,2,1)], init=[1], marked=[2], uncontrollable=[2])
ta = TimedAutomaton(a,Dict((1,1,2)=>1,(2,2,1)=>3))
@test nt(ta) == nt(a) == ns(ta) == ne(ta) == 2
@test duration(ta, (1,1,2))*3 == duration(ta, (2,2,1)) == 3
@test durations(ta) == Dict{Transition,Int64}((1,1,2)=>1,(2,2,1)=>3)
@test transitions(ta) == Set{Transition}([(1,1,2),(2,2,1)])
@test states(ta) == events(ta) == IntSet(1:2)
@test init(ta) == IntSet([1])
@test marked(ta) == uncontrollable(ta) == IntSet([2])

# Custom constructors
ta2 = TimedAutomaton(Dict((1,1,2)=>1,(2,2,1)=>3), init=[1], marked=[2], uncontrollable=[2])
@test ta2 == ta



# Test the show function
originalSTDOUT = STDOUT
(outRead, outWrite) = redirect_stdout()
show(ta)
close(outWrite)
data = String(readavailable(outRead))
close(outRead)
redirect_stdout(originalSTDOUT)
@test data == "Automata.TimedAutomaton(
        states: {1,2}
        events: {1,2}
        transitions: {(2,2,1) => 3,(1,1,2) => 1}
        init: {1}
        marked: {2}
        controllable: {1}
        uncontrollable: {2}
    )"
