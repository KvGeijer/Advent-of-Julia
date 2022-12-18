# Copy paste utils into file 
include("utils.jl")

function dfs(at, time, open, graph, relevant, flows, cache)
    # take a path to one of the closed valves and open it.
    hash = (at, time, open)
    if haskey(cache, hash)
        return cache[hash]
    end
    
    options = [0]
    for (ind, valve) in enumerate(relevant)
        opened_time = time - graph[at, valve] - 1
        new_open = open | (1 << ind)
        released = opened_time*flows[valve]
        if open & (1 << ind) == 0 && opened_time > 0
            # The valve is closed, and we have time to open it
            push!(options, released + dfs(valve, opened_time, new_open, graph, relevant, flows, cache))
        end
    end
    
    res = maximum(options)
    cache[hash] = res
    res 
    
end

function main(input="input.txt")
    rstr = r"Valve (..) has flow rate=(\d+); tunnels? leads? to valves? (.*)"
    valves = parse_re_lines(input, rstr)

    graph = fill(Inf, (length(valves), length(valves)))
    flows = []

    # Initialize graph edges
    for (ind, (from, flow, to)) in enumerate(valves)
        push!(flows, parse(Int, flow))
        for neigh in split(to, ", ") 
            neigh_ind = findfirst(==(neigh), first.(valves))
            graph[ind, neigh_ind] = 1
        end
    end

    # Floyd Warshall        
    # Maybe splice it to only keep AA and the nonzero ones?
    for (j, i, k) in Iterators.product(1:length(valves), 1:length(valves), 1:length(valves))
        graph[i, j] = min(graph[i, j], graph[i, k] + graph[k, j])
    end
    aa_ind = findfirst(==("AA"), first.(valves))

    relevant = findall(>(0), flows)
    cache = Dict()

    # Part 1
    @time part1 = dfs(aa_ind, 30, 0, graph, relevant, flows, cache)
    println(part1)

    # Part 2
    # Basically, partition valves so elephans is only allowed to open some subset,
    # and you are only allowed to open the others. A very clean solution at least. 
    @time maximum(0:2^length(relevant) - 1) do open
        dfs(aa_ind, 26, open, graph, relevant, flows, cache) +
        dfs(aa_ind, 26, ~open, graph, relevant, flows, cache)
    end |> println    
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end