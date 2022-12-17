# Copy paste utils into file 
include("utils.jl")

function occupy(rock, offset, occupied)
    highest = offset[1]
    rock_size = (size(rock, 1), size(rock, 2))
    for rock_row in 1:rock_size[1]
        for rock_col in 1:rock_size[2]
            if rock[rock_row, rock_col] == 1
                # x and y are the positions in the grid, where y is down
                row = offset[1] + rock_size[1] - rock_row + 1
                col = offset[2] + rock_col
                highest = max(highest, row)
                # println("Col: $col, Row: $row, offset: $offset, rock: $rock")
                if occupied[row, col] == 1
                    println("ALREADY OCCUPIED")
                end
                occupied[row, col] = 1
            end
        end
    end
    highest
end

function canmove(rock, offset, occupied)
    rock_size = (size(rock, 1), size(rock, 2))
    # println(offset, rock_size, size(occupied))
    if offset[2] < 0 || offset[2] + rock_size[2] > size(occupied)[2] ||
       offset[1] < 0
        # move into a wall
        return false
    end
    
    for rock_row in 1:rock_size[1]
        for rock_col in 1:rock_size[2]
            if rock[rock_row, rock_col] == 1
                # x and y are the positions in the grid, where y is down
                row = offset[1] + rock_size[1] - rock_row + 1
                col = offset[2] + rock_col
                # println("Col: $col, Row: $row, offset: $offset, rock: $rock")
                if occupied[row, col] == 1
                    return false
                end
            end
        end
    end
    true
end

function printrocks(occupied)
    cont = true
    row = 1
    rows = []
    while cont && row <= size(occupied)[1]
        rowchars = []
        cont = false
        for col in 1:size(occupied)[2]
            if occupied[row, col] == 1
                push!(rowchars, "#")
                cont = true
            else
                push!(rowchars, ".")
            end
        end
        push!(rowchars, "\n")
        push!(rows, join(rowchars))
        row +=  1
    end
    for row in reverse(rows)
        print(row)
    end
end

function simulate(moves, stop)
    wide = 7

    types = [
        [1 1 1 1],
        [0 1 0; 1 1 1; 0 1 0],
        [0 0 1; 0 0 1; 1 1 1],
        [1; 1; 1; 1],
        [1 1; 1 1],
    ]


    occupied = zeros((min(stop*4, 2022*1000), wide))
    # Count from bottom up. My coordinates are fucked
    highest = 0
    moveind = 0

    

    # Try to remember past states we have been in, 
    # if we are in the same state we can interpolate the answer
    # The hard part is how we find that repeating pattern.
    # The top of the tower, the netx piece and the move pos should be identical...
    cached = Set()

    heights = []
    rep_rounds = []

    for round in 1:stop
        rockind = ((round-1)%length(types)) + 1
        rock = types[rockind]                
        
        # Pos is the lower left position (lowest in y and x)
        offset = (highest + 3, 2)
        while true
       
            moveind = if moveind < length(moves)
                    moveind + 1
                else
                    1
                end 
            goright = moves[moveind] == ">"


             # println(goright)

            # First move
            new_offset = (offset[1], offset[2] + (if goright 1 else -1 end))

            if canmove(rock, new_offset, occupied)
                offset = new_offset
                # println("Canmove rock to $offset")
            end 
        
            # Then fall
            new_offset = (offset[1] - 1, offset[2])
            if canmove(rock, new_offset, occupied)
                offset = new_offset
            else
                # write it into the occupied and proceed to next
                # println("Placing rock at $offset")
                highest = max(occupy(rock, offset, occupied), highest)
                push!(heights, highest)
                # printrocks(occupied)
                break
            end
        end
        if round == 2022
            push!(cached, (moveind, rockind))
            println("Height after 2022: $highest")
        elseif (moveind, rockind) in cached
            println("Repeating round - 2022: $(round - 2022), with height: $highest")
            push!(rep_rounds, (round, highest))

            if length(rep_rounds) == 10   
                # We should have found a cycle now, and went it at least once
                # The first cycle starts at rep_round, then goes until this one
                (rep_round, rep_height) = rep_rounds[end-1]


                cycle_length = round - rep_round
                nbr_cycles = div(stop-rep_round, cycle_length)

                last_height = heights[rep_round]
                cycle_height = highest - last_height

                full_cycles_height = nbr_cycles * cycle_height
                println(full_cycles_height)
                println(nbr_cycles)
                println(cycle_height)

                # Now ho wmuch is left after the last full cycle?
                rounds_left = stop - nbr_cycles*cycle_length
                println("Rep_round: $rep_round, Round: $round, rounds_left: $rounds_left")

                # Bot for getting to rep_round, and then the extra rounds to reach stop
                extra_height = heights[rounds_left]
                println(full_cycles_height + extra_height)
                
                return 
            end
        end
    end        
    println(highest)

   end

function main(input="input.txt")
    moves = split(readlines(input)[1], "") 


    # simulate(moves, 2022)
    # simulate(moves, 100000)     
    simulate(moves, 1000000000000)     
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end