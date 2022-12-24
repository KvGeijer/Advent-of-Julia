# Copy paste utils into file 
include("utils.jl")

using Match

function bfs(start, stop, blizzards, upper)
    time = 0
    reachable = Set([start])
    while true
        time += 1
        
        # Update blizzards
        occupied = Set()
        for (dir, coord) in blizzards
            coord .= (dir + coord + upper .+ 1) .% (upper .+ 1)
            push!(occupied, coord)
        end


        # Find all possible steps with the current blizzards
        next_reachable = Set()
        for at in reachable
            for neigh in adj(at, 4, [0, 0], upper)
                if !(neigh in occupied)
                    push!(next_reachable, neigh)
                end
            end
            if at == [0, 0] || at == [-1, 0]
                push!(next_reachable, [-1, 0])
            end
            if at == upper || at == upper + [1, 0]
                push!(next_reachable, upper + [1, 0])
            end
        end

        # Not fast, but makes everything else simpler
        reachable = next_reachable
        if stop in reachable
            return time
        end
    end
end

function main(input="input.txt")
    lines = readlines(input)
    upper = [length(lines) - 3, length(lines[end-1]) - 3]

    # Parsing could be way better
    blizzards = []
    for (row, line) in enumerate(lines[2:end-1])
        for (col, el) in enumerate(line[2:end-1])
            coord = [row-1, col-1]
            dir = @match el begin
                    '>' => push!(blizzards, ([0, 1], coord))
                    '<' => push!(blizzards, ([0, -1], coord))
                    'v' => push!(blizzards, ([1, 0], coord))
                    '^' => push!(blizzards, ([-1, 0], coord))
                end
        end
    end

    # Part 1
    ends = [[-1, 0], upper + [1, 0]]
    bfs(ends[1], ends[2], deepcopy(blizzards), upper) |> println

    # Part 2
    perms = [[1,2], [2,1], [1,2]]
    sum(perm -> bfs(ends[perm][1], ends[perm][2], blizzards, upper), perms) |> println
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end