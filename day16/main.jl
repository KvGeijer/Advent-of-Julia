# Copy paste utils into file 
include("utils.jl")

#using DataStructures

# State is just (at, open)

function get_neigh_states(state, graph, time)
    at = state[1]
    open = state[2]

    time_states = []
    for (neigh, dist) in graph[at]
        # We dont open anything, just move
        new_time = time + dist
        new_at = neigh
        new_open = open 
        push!(time_states, (new_time, (new_at, new_open)))
    end
    time_states
end

function maybe_add_state(state, reachable_dict, pressure)
    if state in keys(reachable_dict)
        # Already reachable then, so just keep best one!
        # TODO: Do we avoid states if they already have been reached with better results?
        reachable_dict[state] = max(
            pressure,
            reachable_dict[state]
        )
    else
        reachable_dict[state] = pressure
    end
end

function bfs(starting_state, graph, flows)
    states = Dict()

    # Init reachable list, don't add chance to turn on A...
    # Reachable at each index is all states we can reach in that time,
    # And how much they will have released then.
    reachable = [Dict() for _ in 1:100]
    for (neigh, dist) in graph[starting_state[1]]
        neigh_state = (neigh, 0)
        reachable[dist][neigh_state] = 0
    end

    best = 0

    for time in 1:29
        for (state, pressure) in reachable[time]
            # println("State $state, pressure $pressure")
        
            # Is this state already visited? If so keep the one with the best flow
            if state in keys(states) && states[state] >= pressure
                # Must have come here faster, but while not having lost pressure
                continue
            end
            # Memoize the state
            states[state] = pressure

            # We can either open the valve (if not already open, or walk)
            valve_mask = 1<<state[1]
            if (state[2] & valve_mask) == 0
                # Closed, we can open it
                # ERROR: This can be off by one?
                open_pressure = flows[state[1]]*(30-(time+1)) + pressure
                open_state = (state[1], state[2] | valve_mask)
                open_time = time + 1
                # println("valve_mask $valve_mask, open_pressure: $open_pressure")
                
                
                maybe_add_state(open_state, reachable[open_time], open_pressure)
                best = max(best, open_pressure)
                # println("Opening $(state[1]) at $(time+1), with total pressure $open_pressure, and prev $pressure")
            end

            # Now, which new states can we reach from this one?
            new_reachable = get_neigh_states(state, graph, time)
            for (neigh_time, neigh_state) in new_reachable
                maybe_add_state(neigh_state, reachable[neigh_time], pressure)
            end
            
        end
    end
    println("Part1: $best")
end

function get_neighs(valve, valves, visited)
    # Find all neighs, using bfs style
    reachable = [neigh for neigh in valves[valve][3]]
    neighs = Dict()
    visited = Set()

    steps = 1
    while !isempty(reachable)
        new_reachable = []
        for name in reachable
            if !(name in visited)
                push!(visited, name)
                neigh = valves[name]
                if neigh[2] != 0    # Real neighbor
                    neighs[name] = steps
                else    # Just a link
                    for new_name in valves[name][3]
                        push!(new_reachable, new_name)
                    end
                end
            end
        end
        reachable = new_reachable
        steps += 1
    end

    neighs
end

function main(input="input.txt")
    # Could optimize away all valves without flow to just get a graph!
    rstr = r"Valve (..) has flow rate=(\d+); tunnels? leads? to valves? (.*)"
    valves = map(parse_re_lines(input, rstr)) do (valve, flow, paths)
        (valve, parse(Int,flow), split(paths, ", "))
    end


    valves_dict = Dict()

    # Dynamic programming?
    ind = 1
    val_to_int = Dict()
    int_to_val = Dict()
    for valve in valves
        val_to_int[valve[1]] = ind
        int_to_val[ind] = valve[1]
        ind += 1
    end

    int_valves = []
    for valve in valves
        new_valve = val_to_int[valve[1]]
        new_neighs = map(n -> val_to_int[n], valve[3]) 
        push!(int_valves, (new_valve, valve[2], new_neighs))
        # println(int_valves[end])
    end

    real_valves = filter(s -> s[2] != 0, int_valves)
    graph = Dict()
    for (valve, flow, neighs) in real_valves
        neighs = get_neighs(valve, int_valves, Set([valve[1]]))
        graph[valve] = neighs
    end

    aa_ind = val_to_int["AA"]
    graph[aa_ind] = get_neighs(aa_ind, int_valves, Set(aa_ind))

    flows = Dict([(valve, flow) for (valve, flow, _) in int_valves])

    starting_state = (aa_ind, 0)
    # Maybe make this nicer?

    # Make a bfs like search, reacbhable is which states we can reach togher in what time
    # Then we iterate over time, adding the best possible states
    bfs(starting_state, graph, flows)

    # beststate = values(states) |> maximum |> println
    # dfs(states, startin_state.at, valves_to_inds)

    # (graph, valves_dict)    
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end