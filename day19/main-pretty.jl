# Copy paste utils into file 
include("utils.jl")


function can_build_in(robots, inv, cost)
    if all(inv .>= cost)
        1
    else
        nonzero = findall(.!=(0), cost)
        time = (cost - inv)./robots
        time = maximum(time[nonzero])
        if time == Inf
            Inf
        else
            1 + ceil(Int, time)
        end
    end    
end

function dfs(inventory, robots, cache, time_left, costs, max_costs)
    hash = (inventory..., robots..., time_left)
    cached = get(cache, hash, nothing)
    if cached != nothing
        return cached
    end

    best = 0
    for robot_type in (i for i in 1:4 if i == 4 || robots[i] < max_costs[i])
        build_time = can_build_in(robots, inventory, costs[robot_type, :])
        if build_time != Inf && build_time < time_left
            new_time = time_left - build_time
            new_inv = inventory + build_time.*robots - costs[robot_type, :]
            new_robots = copy(robots)

            if robot_type != 4
                new_robots[robot_type] += 1
            end
            
            geodes = dfs(new_inv, new_robots, cache, new_time, costs, max_costs)
            if robot_type == 4 && build_time == 1
                best = new_time + geodes
                break
            elseif robot_type == 4
                geodes += new_time
            end
            best = max(best, geodes)
        end
    end
    cache[hash] = best
    best
end

function parse_blueprints(input)
    rstr = r".*ore robot costs (?:(\d+) ore)?(?:(?: and)? (\d+) clay)?(?:(?: and)? (\d+) obsidian)?.*clay robot costs (?:(\d+) ore)?(?:(?: and)? (\d+) clay)?(?:(?: and)? (\d+) obsidian)?.*obsidian robot costs (?:(\d+) ore)?(?:(?: and)? (\d+) clay)?(?:(?: and)? (\d+) obsidian)?.*geode robot costs (?:(\d+) ore)?(?:(?: and)? (\d+) clay)?(?:(?: and)? (\d+) obsidian)?\..*"
    map(parse_re_lines(input, rstr)) do caps
        reshape(parse.(Int, replace(caps, nothing => "0")), (3, 4))'
    end
end

function eval_blueprint(costs, time) 
    max_costs = [maximum(Int, costs[1:end, type]) for type in 1:3]
    dfs([0, 0, 0], [1, 0, 0], Dict(), time, costs, max_costs)
end

function main(input="input.txt")
    blueprints = parse_blueprints(input)

    # Part 1
    map(enumerate(blueprints)) do (ind, costs)
        eval_blueprint(costs, 24) * ind
    end |> sum |> println

    # Part 2
    map(blueprints[1:3]) do costs
        eval_blueprint(costs, 32)
    end |> prod |> println
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end