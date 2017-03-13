# The graph from Example 7 in Huangs final thesis
include("src/Automata.jl")
using Automata

# Include dependencies
using LightGraphs       # For Graph representation
using GraphPlot         # For graph visualization
using Colors            # For coloring of the nodes
using Compose           # For drawing to file

a = Automaton(
        states=[7,2,3,4,5,6,8],
        events=1:3,
        transitions=[
                (7,1,2), (7,2,3),
                (2,1,4), (2,3,8),
                (3,1,4), (3,2,5),
                (4,3,5), (4,1,6), (4,2,8),
                (5,1,6),
                (6,1,8)
            ],
        init=[7],
        marked=[4,5,8],
        uncontrollable=[3]
    )


# create a graph representation
g = DiGraph(ns(a))
vertices = collect(states(a))
edgelabel = ["$(event(t) in uncontrollable(a) ? "!" : "")$(event(t))" for t in transitions(a)]
for t in transitions(a)
    add_edge!(g,findfirst(vertices .== source(t)),findfirst(vertices .== target(t)))
end

# assert
for v in LightGraphs.vertices(g)
    @assert length(neighbors(g,v)) > 0 "No zero degree vertex allowed when plotting."
end

#=
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
