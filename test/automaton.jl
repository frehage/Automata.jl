
a1 = Automaton()
a2 = Automaton(5)

# Testset for the type Automaton.
@testset "Automaton" begin

    @testset "Automaton.constructors" begin

        @testset "Automaton.parameters" begin
            @test a1.states == states(a1) == Set{State}()
            @test a2.states == states(a2) == Set{State}(1:5)
            @test ns(a1) == length(states(a1)) == 0
            @test ns(a2) == length(states(a2)) == 5
        end

        # Test the input value assertion.
        @testset "InputValueConsistency" begin
            # Test transitions.
            @test_throws ArgumentError Automaton(Set{State}([1]), Set{Event}([1]), Set{Transition}([(1,1,2)]), Set{State}(), Set{State}())
            @test_throws ArgumentError Automaton(Set{State}([1]), Set{Event}([1]), Set{Transition}([(2,1,1)]), Set{State}(), Set{State}())
            @test_throws ArgumentError Automaton(Set{State}([1]), Set{Event}([1]), Set{Transition}([(1,2,1)]), Set{State}(), Set{State}())

            # Test init states.
            @test_throws ArgumentError Automaton(Set{State}(), Set{Event}(), Set{Transition}(), Set{State}([1]), Set{State}())

            # Test marked states.
            @test_throws ArgumentError Automaton(Set{State}(), Set{Event}(), Set{Transition}(), Set{State}(), Set{State}([1]))
        end
    end
end
