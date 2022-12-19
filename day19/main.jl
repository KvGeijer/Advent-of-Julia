# Copy paste utils into file 
include("utils.jl")


function can_build_in(robots, inv, cost)
    robots = robots[1:3]
    if all(inv .>= cost)
        1
    else
        nonzero = findall(.!=(0), cost)
        time = (cost - inv)./robots
        time = maximum(time[nonzero])
        if time == Inf
            false
        else
            1 + ceil(Int, time)
        end
    end    
end

function bfs2(total_time, costs, init_robots)
    # The basic idea is, if we have already reached a certain configuration of robots, it is worse if we reach them again
    # Reachable states:: (robots, inv, geodes, next_build)
    reachable = [[] for _ in 1:total_time]
    for build in 1:3
        can_build = can_build_in(init_robots, [0,0,0], costs[build, :])
        if can_build != false
            # How much we have after completng the robot
            new_inv = can_build.*init_robots[1:3] - costs[build, :]
            robots = copy(init_robots)
            robots[build] += 1
            push!(reachable[can_build], (robots, new_inv, 0))
        end
    end

    # Keepts track of which robot configurations we have reached, and when. 
    # Always better to reach faster?
    # TODO: Implement this!
    reached = Set()

    max_costs = [maximum(costs[1:end, type]) for type in 1:3]

    best = 0
    for time in 1:(total_time - 1)
        for (robots, inv, geo) in reachable[time]
            builds = [4]
            for type in 1:3
                if robots[type] == max_costs[type]
                    inv[type] = min(max_costs[type], inv[type])
                else
                    push!(builds, type)
                end
            end
        
            # If we have already reached the state, just continue
            hash = tuple(robots..., inv..., geo)
            if hash in reached
                continue
            else
                push!(reached, hash)
            end
            
            # Which is the next robot we shall build?
            for build in builds
                can_build = can_build_in(robots, inv, costs[build, :])
                if can_build != false && can_build + time < total_time
                    # Can build is the time until the robot is finished
                    new_time = time + can_build
                    new_inv = inv + can_build.*robots[1:3] - costs[build, :]
                    new_robots = copy(robots)
                    new_robots[build] += 1

                    if build == 4
                        new_geo = geo + total_time - new_time
                        best = max(best, new_geo)
                        push!(reachable[new_time], (new_robots, new_inv, new_geo))
                        # If we can build geo, we always do
                        if can_build == 1
                            break
                        end
                    else
                        push!(reachable[new_time], (new_robots, new_inv, geo))
                    end
                end
            end
        end
    end

    best
    
end

function main(input="input.txt")
    # rstr = r"Blueprint (\d+): Each ore robot costs (:?(\d+) ore)?(:? and (\d+) clay)?(:? and (\d+) obsidian)?. Each clay robot costs (:?(\d+) ore)?(:? and (\d+) clay)?(:? and (\d+) obsidian)?. Each obsidian robot costs (:?(\d+) ore)?(:? and (\d+) clay)(:? and (\d+) obsidian). Each geode robot costs 3 ore and 9 obsidian."
    blueprints = []
    for line in readlines(input)
        (start, line) = split(line, ":")
        splitted = split(line[1:end-1], ". ")
        id = parse(Int, split(start)[2])
        costmat = zeros(Int, (4,3))
        for (row, rec) in enumerate(splitted[1:4])
            costs = split(rec, "costs ")[2]
            for cost in split(costs, " and ")
                words = split(cost, " ")
                col = 
                    if words[end] == "ore"
                        1
                    elseif words[end] == "clay"
                        2
                    elseif words[end] == "obsidian"
                        3
                    end
                costmat[row, col] = parse(Int, words[end-1])
            end
        end
        push!(blueprints, (id, costmat))
    end

    scores = []
    for (ind, costs) in blueprints
        geo = bfs2(24, costs, [1, 0, 0, 0])
        push!(scores, geo*ind) 
        println("FINISHED $ind / $(length(blueprints))")
    end
    scores |> sum |> println

    scores = []
    for (ind, costs) in blueprints[1:3]
        geo = bfs2(32, costs, [1, 0, 0, 0])
        push!(scores, geo) 
        println("FINISHED $ind / 3")
    end
    scores |> prod |> println
        
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end