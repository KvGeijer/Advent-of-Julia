# Copy paste utils into file 
include("utils.jl")

function main(input="input.txt")
    pos = Set()
    for (y, line) in enumerate(readlines(input))
        for (x, occ) in enumerate(line)
            if occ == '#'
                push!(pos, [y, x])
            end
        end
    end

    props = []
    props = [
        ([-1, 0], ([-1, -1], [-1, 0], [-1, 1])),    # N
        ([1, 0], ([1, -1], [1, 0], [1, 1])),        # S
        ([0, -1], ([-1, -1], [0, -1], [1, -1])),    # W
        ([0, 1], ([-1, 1], [0, 1], [1, 1]))         # E
    ]

    for round in 1:100000000
        proposed = Dict()
        moves = Dict()
        for elf in pos
            # Find out their preferred position
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

        # Now do the movement
        moved = false
        pos = Set()
        for (elf, next) in moves
            if proposed[next] == 1
                # Move
                moved |=  next != elf
                push!(pos, next)
            else
                # Stay where you are
                push!(pos, elf)
            end
        end

        if !moved
            # Part 2
            println("First stationary round: $round")
            return
        elseif round == 10
            # Part 1
            maxy = maximum(elf->elf[1], pos)
            miny = minimum(elf->elf[1], pos)
            maxx = maximum(elf->elf[2], pos)
            minx = minimum(elf->elf[2], pos)

            ground = (maxy - miny + 1)*(maxx - minx + 1) - length(pos)
            println("Square after $round rounds: $ground")            
        end
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end