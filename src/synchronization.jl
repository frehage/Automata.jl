#(n1,Sigma1,T1,Qi1,n2,Sigma2,T2,Qi2,Sigma_s)                   # OK T 2016-12-20  R 2016-12-22
# n1 = number of states in Q1, n2 = number of states in Q2
# No states larger than ni are allowed in Qi and Ti i=1,2
function sync(a::Automaton, b::Automaton)

    automaton = Automaton()

    # Calculate events and add them to the new automaton
    Sigma = union(events(a),events(b))
    Sigma12s = intersect(events(a),events(b))
    Sigma12u = union(uncontrollable(a),uncontrollable(b))
    Sigma1i = setdiff(events(a),Sigma12s)
    Sigma2i = setdiff(events(b),Sigma12s)
    add_events!(automaton, Sigma, Sigma12u)

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

    # iterate until queue is empty
    while !isempty(queue) && n < 10
        q1,q2 = dequeue!(queue)
        q12 = Q[(q1,q2)]

        # look for feasible transitions of three type of events: (i) shared, (ii) local in a, (iii) local in b
        outtrans = Queue(Tuple{Event,State,State})
        for e in intersect(Sigma12s,Gamma1[q1],Gamma2[q2])
            enqueue!(outtrans, (e, Q1prime[q1+ns(a)*e], Q2prime[q2+ns(b)*e]))
        end
        for e in intersect(Sigma1i,Gamma1[q1])
            enqueue!(outtrans, (e, Q1prime[q1+ns(a)*e], q2))
        end
        for e in intersect(Sigma2i,Gamma2[q2])
            enqueue!(outtrans, (e, q1, Q2prime[q2+ns(b)*e]))
        end
        for (e,q1p,q2p) in outtrans
            q12prime1 = (q1p, q2p)
            if !haskey(Q,q12prime1)
                n += 1
                Q[q12prime1] = n
                enqueue!(queue, q12prime1)
                q12prime2 = n
            else
                q12prime2 = Q[q12prime1]
            end
            add_state!(automaton, q12prime2, (q1p in init(a) && q2p in init(b)), (q1p in marked(a) && q2p in marked(b)))
            add_transition!(automaton, (q12,e,q12prime2))
        end
    end
    automaton
end

function outgoing_trans(a::Automaton)       # OK RT 2016-12-18
    Gamma = Dict([(s, IntSet()) for s in states(a)])
    Qprime = Dict{Int128,State}()

    for (s,e,t) in transitions(a)
        se = Int128(s+ns(a)*e)
        push!(Gamma[s],e)
        Qprime[se] = t
    end
    return Gamma,Qprime
end
