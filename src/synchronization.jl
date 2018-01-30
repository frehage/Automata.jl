
function sync(a::Automaton, b::Automaton, get_original::Bool = false)

    msg = "Synchronization requires both automata to have at least one initial
        state each error on:"
    !isempty(init(a)) || throw(ArgumentError("$msg $a"))
    !isempty(init(b)) || throw(ArgumentError("$msg $b"))
    automaton = Automaton()

    # Calculate events and add them to the new automaton
    Sigma = union(events(a),events(b))
    Sigma12s = intersect(events(a),events(b))
    Sigma12u = union(uncontrollable(a),uncontrollable(b))
    Sigma12d = union(disturbance(a),disturbance(b))
    Sigma1i = setdiff(events(a),Sigma12s)
    Sigma2i = setdiff(events(b),Sigma12s)
    add_events!(automaton, Sigma, Sigma12u, disturbance=Sigma12d)

    # For each state in a and b, calculate outgoing events and outgoing states.
    Gamma1,Q1prime = outgoing_trans(a)
    Gamma2,Q2prime = outgoing_trans(b)

    queue = Queue(Tuple{State,State}) # queue with states to be explored
    Q = Dict{Tuple{State,State}, Int64}() # state index for new automaton

    # add init states to the queue
    n = 0
    for q1 in init(a), q2 in init(b)
        n += 1
        Q[(q1,q2)] = n
        add_state!(automaton, n, (q1 in init(a) && q2 in init(b)), (q1 in marked(a) && q2 in marked(b)))
        enqueue!(queue, (q1,q2))
    end

    max_s_a = maximum(states(a))
    max_s_b = maximum(states(b))
    outtrans = Tuple{Event,State,State}[]
    # iterate until queue is empty
    while !isempty(queue)
        q1,q2 = dequeue!(queue)
        q12 = Q[(q1,q2)]

        # look for feasible transitions of three type of events: (i) shared, (ii) local in a, (iii) local in b
        empty!(outtrans)
        for e in Gamma1[q1]
            if e in Sigma12s && e in Gamma2[q2]
                push!(outtrans, (e, Q1prime[q1+max_s_a*e], Q2prime[q2+max_s_b*e]))
            end
        end
        for  e in Gamma1[q1]
            if e in Sigma1i
                push!(outtrans, (e, Q1prime[q1+max_s_a*e], q2))
            end
        end
        for e in Gamma2[q2]
            if e in Sigma2i
                push!(outtrans, (e, q1, Q2prime[q2+max_s_b*e]))
            end
        end




        for (e,q1p,q2p) in outtrans
            q12prime1 = (q1p, q2p)
            if !haskey(Q,q12prime1)
                n += 1
                Q[q12prime1] = n
                enqueue!(queue, q12prime1)
                q12prime2 = n
                add_state!(automaton, q12prime2, false, (q1p in marked(a) && q2p in marked(b)))
            else
                q12prime2 = Q[q12prime1]
            end
            add_transition!(automaton, (q12,e,q12prime2))
        end
    end
    if get_original
        automaton, Q
    else
        automaton
    end
end

"""
    sync(ta1::TimedAutomaton, ta2::TimedAutomaton)

Synchronization of ::TimedAutomaton. Only syncs on event and not on duration. If
a transition in the synchronous composition activates a transitions in both  the
automatons, the duration of both transitions is expected to have same duration.
"""
function sync(ta1::TimedAutomaton, ta2::TimedAutomaton)

    automaton, Q = sync(ta1.automaton, ta2.automaton, true)
    Qi = Dict(v => k for (k,v) in Q)

    #println(automaton)

    dur = Dict{Transition,Float64}()

    for trans in transitions(automaton)
        if event(trans) in events(ta1)
            t_original =  (first(Qi[source(trans)]),event(trans), first(Qi[target(trans)]))
            d = duration(ta1, t_original)

        else
            t_original =  (last(Qi[source(trans)]), event(trans), last(Qi[target(trans)]))
            d = duration(ta2, t_original)

        end
        push!(dur, trans=>d)
    end
    dur
    ta = TimedAutomaton(automaton, dur)

end

function outgoing_trans(a::Automaton)       # OK RT 2016-12-18
    Gamma = Dict([(s, IntSet()) for s in states(a)])
    Qprime = Dict{Int128,State}()

    max_s = maximum(states(a))

    for (s,e,t) in transitions(a)
        se = Int128(s+max_s*e)
        push!(Gamma[s],e)
        Qprime[se] = t
    end

    return Gamma,Qprime
end
