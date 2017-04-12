######################################
# Testset for the synchronization fucntions.
######################################

a1 = Automaton(
    states=1:4,
    events=1:2,
    transitions=[
            (1,1,2),
            (2,1,3),
            (3,1,4),
            (4,1,2), (4,2,2)
        ],
    init=[1],
    marked=[3],
    uncontrollable=[2])
a2 = Automaton(
    states=1:3,
    events=1:3,
    transitions=[
            (1,1,1),(1,3,3),
            (2,1,1),(2,2,2),
            (3,2,3),(3,1,2),(3,3,2)
        ],
    init=[1],
    marked=[1,3])
a3 = Automaton(
    states=1:2,
    events=1:3,
    transitions=[
            (1,1,2),(1,2,1),
            (2,1,2),(2,2,1)
        ],
    init=[1],
    marked=[2])
a4 = Automaton(
    states=1:2,
    events=1:3,
    transitions=[
            (1,1,2),
            (2,1,2)
        ],
    init=[1],
    marked=[2])
a5 = Automaton(
    states=1:6,
    events=1:3,
    transitions=[
            (1,1,2),(1,3,3),
            (2,1,2),(2,3,4),
            (3,2,3),(3,1,5),(3,3,6),
            (4,2,3),(4,1,5),(4,3,5),
            (5,1,2),(5,2,6),
            (6,1,2),(6,2,6)
        ],
    init=[1],
    marked=[2,4])

@test sync(a1,a1) == a1
@test sync(a2,a3) == a4

rem_events!(a3, [3])
@test sync(a2,a3) == a5
@test sync(a3,a2) == a5
