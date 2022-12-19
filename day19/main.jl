# Copy paste utils into file 
include("utils.jl")

function canbuild(cost, inv)
    all(inv - cost .>= 0)
end

function dfs(time, robots, inv, cache, costs)
    hash = (time, robots...)
    if haskey(cache, hash)
        return cache[hash]
    end

    # Let the robots produce their stuff
    inv += robots

    if time == 1
        return 0
    elseif time == 0
        println("TIOME 0")
    end

    # Five actions to do,
    # 1. Wait
    # 2. Build ore robot
    # 3. Build clay robot
    # 4. Build obsidian robot
    # 5. Build geode robot

    # Should only allow waiting if we can't build all robots
    # This can be optimized a lot
    broke = false
    options = []
    for robot in 1:3
        if canbuild(costs[robot, :], inv)
            new_robots = [0, 0, 0]
            new_robots[robot] = 1
            geo = dfs(time+1, robots + new_robots, inv - costs[robot, :], cache, costs)
            push!(options, geo)
        else
            broke = true
        end
    end
    robot = 4
    if canbuild(costs[robot, :], inv)
        geo = dfs(time+1, robots, inv - costs[robot, :], cache, costs)
        push!(options, geo + (time - 1)) 
    else
        broke = true
    end
    
    if broke
        push!(options, dfs(time+1, robots, inv, cache, costs))
    end

    geodes = maximum(options)
    cache[hash] = geodes
    geodes
end

function dfs2(time, robots, inv, cache, costs)
    hash = (time, robots..., inv...)
    if haskey(cache, hash)    
        return cache[hash]
    end

    # Let the robots produce their stuff
    inv += robots

    if time == 1
        return 0
    elseif time == 0
        println("TIOME 0")
    end

    # Five actions to do,
    # 1. Wait
    # 2. Build ore robot
    # 3. Build clay robot
    # 4. Build obsidian robot
    # 5. Build geode robot

    # Should only allow waiting if we can't build all robots
    # This can be optimized a lot
    broke = false
    options = []
    for robot in 1:3
        if canbuild(costs[robot, :], inv)
            new_robots = [0, 0, 0]
            new_robots[robot] = 1
            geo = dfs(time+1, robots + new_robots, inv - costs[robot, :], cache, costs)
            push!(options, geo)
        else
            broke = true
        end
    end
    robot = 4
    if canbuild(costs[robot, :], inv)
        geo = dfs(time+1, robots, inv - costs[robot, :], cache, costs)
        push!(options, geo + (time - 1)) 
    else
        broke = true
    end
    
    if broke
        push!(options, dfs(time+1, robots, inv, cache, costs))
    end

    geodes = maximum(options)
    cache[hash] = geodes
    geodes
end


function can_build_in(robots, inv, cost)
    robots = robots[1:3]
    if all(inv .>= cost)
        1
    else
        nonzero = findall(.!=(0), cost)
        time = (cost - inv)./robots
        # println(time)
        time = maximum(time[nonzero])
        if time == Inf
            false
        else
            # ERROR!
            # println(time)
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
    reached = Dict()

    max_costs = [maximum(costs[1:end, type]) for type in 1:3]

    best = 0
    for time in 1:(total_time - 1)
        # println("Time: $time, search space: $(length(reachable[time]))")
        for (robots, inv, geo) in reachable[time]
            builds = [4]
            for type in 1:3
                if robots[type] == max_costs[type]
                    # TODO: This is wrong
                    # inv[type] = max(max_costs[type], inv[type])
                else
                    push!(builds, type)
                end
            end
            # push!(builds, 4)
        
            # Here we should check if we have already found a better one
            # The problem is the caching!
            # hash = tuple(robots...)
            # if haskey(reached, hash)
            #     cached = reached[hash]
            #     if cached[2] > geo || all(cached[1] .> inv)  
            #         continue
            #     end
            # else
            #     reached[tuple(robots...)] = (inv, geo)
            # end
            
            # println("Reached robots: $robots, $inv")
            

            # First, which ones can we build?
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
                        # TODO: This does not seem to hold
                        if can_build == 1
                            break
                        end
                    else
                        push!(reachable[new_time], (new_robots, new_inv, geo))
                    end
                end
            end
            # for (robot, inv, geo) in state_reachable
            #     if 
            # end
            
            # Now actually check if the reachable 
        end
    end

    best
    
end

function eval_blueprint(blueprint)
    (_, costs) = blueprint

    # Again do a dfs with caching
    # Hash: (time, robots, inventory)
    # Value to maximize is number of geodes
    cache = Dict()
    dfs(24, [1, 0, 0, 0], [0, 0, 0], cache, costs)
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
        println(geo)
        push!(scores, geo*ind) 
        println("FINISHED $ind / $(length(blueprints))")
    end
    # geodes = map(eval_blueprint, blueprints)
    scores |> sum |> println

    # return

    scores = []
    for (ind, costs) in blueprints[1:3]
        geo = bfs2(32, costs, [1, 0, 0, 0])
        println(geo)
        push!(scores, geo) 
        println("FINISHED $ind / 3")
    end
    # geodes = map(eval_blueprint, blueprints)
    scores |> prod |> println
        
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end