# Copy paste utils into file 
include("utils.jl")

function dfs(at, time, stop, blizzards, upper, cache, blizz_cache)
    cycle_len = prod(upper)


    if at == stop
        return time + 1
    end

    hash = (at..., time % cycle_len)
    if get(cache, hash, time + 1) < time
        return cache[hash]
    end

    occupied = Set()
    # Update all blizzards (can be cached as well really)
    if haskey(blizz_cache, time % cycle_len)
        (occipied, blizzards) = blizz_cache[time]
    else
        next_blizzards = []
        for (dir, coord) in blizzards
            next = dir + coord
            if next[1] > upper[1]
                next[1] = 1
            elseif next[2] > upper[2]
                next[2] = 1
            elseif next[1] < 1
                next[1] = upper[1]
            elseif next[2] < 1
                next[2] = upper[2]
            end
            push!(blizzards, (dir, next))
            push!(occupied, next)
        end
        blizzards = next_blizzards
    end

    # Check which directions we can go

    
    if !haskey(blizz_cache, time % cycle_len)
         blizz_cache[time % cycle_len] = (deepcopy(occipied), deepcopy(blizzards))
    end

    cache[hash] = best
    best
end

function print_blizz(blizzards)
    mat = zeros(Int, (4,6))
    for (dir, (row, col)) in blizzards
        mat[row, col] += 1
    end
    for row in 1:4
        println(mat[row, :])
    end
end

function bfs(start,stop, blizzards, upper)
    time = 0
    reachable = Set()
    push!(reachable, start)
    while true
        time += 1
        if time % 1000 == 0
            println("TIME: $time")
        end
        #     println("TIME: $time")
        # for x in reachable
        #     println(x)
        # end
        # println("BLIZZARDS")

        # if time > 20
        #     return
        # end
        
        # Update blizzards
        occupied = Set()
        for (dir, coord) in blizzards
            next = dir + coord
            if next[1] > upper[1]
                next[1] = 1
            elseif next[2] > upper[2]
                next[2] = 1
            elseif next[1] < 1
                next[1] = upper[1]
            elseif next[2] < 1
                next[2] = upper[2]
            end
            coord[1] = next[1]
            coord[2] = next[2]
            # println(coord)
            push!(occupied, next)
        end

    # print_blizz(blizzards)

        # Find all possible steps with the current blizzards
        next_reachable = Set()
        for at in reachable
            for neigh in adj(at, 4, [1, 1], upper)
                if !(neigh in occupied)
                    push!(next_reachable, neigh)
                end
            end
            if at == [1, 1] || at == [0, 1]
                neigh = [0, 1]
                push!(next_reachable, neigh)
            end
            if at == upper || at == upper + [1, 0]
                neigh = upper + [1, 0]
                push!(next_reachable, neigh)
            end
        end
        reachable = next_reachable
        if stop in reachable
            println("Reachable in : $(time)")
            return time
        end
        
    end

end

function main(input="input.txt")
    blizzards = []
    occupied = Set()

    lines = readlines(input)
    upper = [length(lines) - 2, length(lines[end-1]) - 2]

    println(upper)
    for (row, line) in enumerate(lines[2:end-1])
        for (col, el) in enumerate(line[2:end-1])
            if el == '>'
                push!(blizzards, ([0,1], [row, col]))    
                push!(occupied, [row, col])
            
            elseif el == '<'
                push!(blizzards, ([0,-1], [row, col]))    
                push!(occupied, [row, col])

            elseif el == 'v'
                push!(blizzards, ([1,0], [row, col]))    
                push!(occupied, [row, col])

            elseif el == '^'
                push!(blizzards, ([-1,0], [row, col]))    
                push!(occupied, [row, col])

            end
        end
    end

    # print_blizz(blizzards)

    start = [0, 1]
    start_upper = copy(upper)
    start_upper[1] += 1
    to = bfs(start, start_upper, blizzards, upper)
    back = bfs(start_upper, start, blizzards, upper)
    and_to = bfs(start, start_upper, blizzards, upper)

    println(to + back + and_to)

        
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end