# Copy paste utils into file 
include("utils.jl")

# Memoization state is (at_you, at_elephant, open)
# Move_state is ((you, you_arrive, you_next), (el, el_arrive, el_next), open)

# Should return which 
function get_move_states(at, graph, time)
    
    move_states = []
    for (neigh, dist) in graph[at]
    
        # We dont open anything, just move
        arr = time + dist
        push!(move_states, (at, arr, neigh))
    end
    move_states
end

function maybe_add_state(state, memo_dict, memo_value)
    if haskey(memo_dict, state)
        # Already reachable then, so just keep best one!
        memo_dict[state] = max(
            memo_value,
            memo_dict[state]
        )
    else
        memo_dict[state] = memo_value
    end
end

# All possible personal move states you can transition to, 
# and how it increases pressure and changes open
function possible_moves(person_state, time, graph, open, flows)
    if time != person_state[2]
        # It is still travelling, so it can't do anything
        return [(open, 0, person_state)]
    end

    # type: [(open, pressure-delta, personal_move_state)]
    results = []

    # We have just arrived at our destination
    at = person_state[3]

    # If valve closed, create state to open it
    valve_mask = 1 << at
    if (open & valve_mask) == 0
        # Closed, we can open it
        open_pressure = flows[at]*(26-time)
        open_state = (at, time + 1, at)
        new_open = open | valve_mask

        push!(results, (new_open, open_pressure, open_state))
    end

    # Now, which new states can we travel to from this one?
    for move_state in get_move_states(at, graph, time)
        # We don't change the pressure or open in any of the move states
        push!(results, (open, 0, move_state))
    end
    results
end

function get_next_states(you_state, el_state, time, pressure, graph, open, flows)
    # All possible states the human and elephant can get to currently
    states = []
    for (you_open, you_press, you_state) in possible_moves(you_state, time, graph, open, flows)
        for (el_open, el_press, el_state) in possible_moves(el_state, time, graph, open, flows)
            if you_open == el_open != open
                # Don't let them open the same valve!
                continue
            end
            
            # Now we have a new possible move_state, so add it!
            new_pressure = pressure + you_press + el_press
            new_time = min(you_state[2], el_state[2])
            move_state = (you_state, el_state, el_open | you_open)

            push!(states, (new_pressure, new_time, move_state))
        end
    end
    states
end

function bfs(aa_ind, graph, flows)
    # This function runs a bfs style search through all reachable states,
    # Using memoization to not have to visit already visited states,
    # or states which are strictly worse thn a visited one.
    # This is the bottle neck, by far...

    # Maybe not optimal to use a dict of nested tuples, but only constant time worse
    states = Dict()

    # Reachable at each index is all move_states we can reach at that time,
    # and the key is how much they will have released then. 
    # When we open a valve, we count as if all pressure is being let out instantaneously.
    reachable = [Dict() for _ in 1:100]    # to 100 just to not worry about index out of bound

    # Say AA starts as open, just to not open it, as it has pressure 0
    start_open = 1 << aa_ind
    # A presonal move state, (from_valve, arrival_time, next_valve)
    start_state = (0, 1, aa_ind)
    reachable[1][(start_state, start_state, start_open)] = 0

    best = 0

    # Change to 29 for part 1
    for time in 1:25
        # Log each iteration
        println("Time: $time, best: $best, nbr reachable: $(length(reachable[time]))")
        for (move_state, pressure) in reachable[time]
            you_state = move_state[1]
            el_state = move_state[2]
            open = move_state[3]

            # Check if the state we are going to is already visited. (symmetry also checked)
            stat_state = (you_state[3], el_state[3], open)
            stat_state_symm = (el_state[3], you_state[3], open)

            # This check might be very slow, don't know how sets are implemented in Julia
            if haskey(states, stat_state) && states[stat_state] >= pressure ||
               haskey(states, stat_state_symm) && states[stat_state_symm] >= pressure
                # Must have come here faster, but while not having lost pressure
                continue
            end
            
            # Memoize the current state (actually most recently visited)
            stat_past_state = (
                if you_state[2] == time you_state[3] else you_state[1] end,
                if el_state[2] == time el_state[3] else el_state[1] end,
                open
            )
            maybe_add_state(stat_past_state, states, pressure)

            # Now we check all possible moves for the elephant and the human
            new_states = get_next_states(you_state, el_state, time, pressure, graph, open, flows)
            for (new_pressure, new_time, new_state) in new_states
                # Add them to reachable
                maybe_add_state(new_state, reachable[new_time], new_pressure)
                best = max(best, new_pressure)
            end
        end
    end
    println("Part2: $best")
end

function get_neighs(valve, valves, visited)
    # Reduce graph by removing all valves with 0 pressure
    # Nit the prettiest, but the idea is nice and we have bigger problems...
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

    collect(neighs)
end

function main(input="input.txt")
    rstr = r"Valve (..) has flow rate=(\d+); tunnels? leads? to valves? (.*)"
    valves = map(parse_re_lines(input, rstr)) do (valve, flow, paths)
        (valve, parse(Int,flow), split(paths, ", "))
    end

    # Use ints instead of strings for faster computation
    val_to_int = Dict()
    for (ind, valve) in enumerate(valves)
        val_to_int[valve[1]] = ind
    end
    int_valves = []
    for valve in valves
        new_valve = val_to_int[valve[1]]
        new_neighs = map(n -> val_to_int[n], valve[3]) 
        push!(int_valves, (new_valve, valve[2], new_neighs))
    end

    # Reduce the valves to a map with only the relevant ones
    graph = []
    for (valve, flow, neighs) in int_valves
        neighs = 
            if flow > 0
                get_neighs(valve, int_valves, Set([valve[1]]))
            else
                []
            end
        push!(graph, neighs)   
    end

    # Add "AA" to graph, as we start there
    aa_ind = val_to_int["AA"]
    graph[aa_ind] = get_neighs(aa_ind, int_valves, Set(aa_ind))

    # Just an array for how muh flow is in each valve
    flows = [flow for (_valve, flow, _) in int_valves]

    # The meat, do a bfs style search over the search space, with memoization
    bfs(aa_ind, graph, flows)
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end