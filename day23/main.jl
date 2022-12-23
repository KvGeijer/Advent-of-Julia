# Copy paste utils into file 
include("utils.jl")

function printpos(pos, srows, rows, scols, cols, round)
    println("== END OF ROUND $round==")
    for row in srows:rows
        for col in scols:cols
            if [row, col] in pos
                print("#")
            else
                print(".")
            end
        end
        println("")
    end
end


function main(input="input.txt")
    pos = Set()
    for (y, line) in enumerate(readlines(input))
        for (x, occ) in enumerate(line)
            if occ == '#'
                push!(pos, [y, x])
            end
        end
    end

    props = [
        ([-1, 0], ([-1, -1], [-1, 0], [-1, 1])),    # N
        ([1, 0], ([1, -1], [1, 0], [1, 1])),        # S
        ([0, -1], ([-1, -1], [0, -1], [1, -1])),    # W
        ([0, 1], ([-1, 1], [0, 1], [1, 1]))         # E
    ]

        printpos(pos, -3, 11, -3, 10, 0)
    for round in 1:100000000
        proposed = Dict()
        moves = Dict()
        moved = false
        for elf in pos
            # Find out their prefferred position
            next = elf
            if any(in(pos), adj(elf))
                for (move, considers) in props
                    if any(cons -> (elf+cons) in pos, considers)
                        continue
                    end
                    next = elf + move
                    break
                end
            end
            moves[elf] = next
            proposed[next] = get(proposed, next, 0) + 1
        end

        # Rotate prefferred moves
        (head, props) = (props[1], props[2:end])
        push!(props, head)

        # Nw do the movement
        next_pos = Set()
        for (elf, next) in moves
            if proposed[next] == 1
                # Move
                if next != elf
                    moved = true
                end
                push!(next_pos, next)
            else
                # Stay where you are
                push!(next_pos, elf)
            end
        end

        if !moved
            println(round)
            return
        end
        pos = next_pos

        # printpos(pos, -3, 11, -3, 10, round)
    end

    # Part 1
    maxy = maximum(elf->elf[1], pos)
    miny = minimum(elf->elf[1], pos)
    maxx = maximum(elf->elf[2], pos)
    minx = minimum(elf->elf[2], pos)

    ground = (maxy - miny + 1)*(maxx - minx + 1) - length(pos)
    # println(ground)
    
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end