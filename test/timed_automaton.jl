######################################
# Testset for the type TimedAutomaton.
######################################

###
# Test the constructors and the generated objects
###

# Test the parameter values of newly created objects
a = Automaton(states=1:2,events=1:2,transitions=[(1,1,2),(2,2,1)])
ta = TimedAutomaton(a,Dict((1,1,2)=>1,(2,2,1)=>3))
@test nt(ta) == nt(a) == 2
@test duration(ta, (1,1,2))*3 == duration(ta, (2,2,1)) == 3
