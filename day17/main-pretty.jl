# Copy paste utils into file 
include("utils.jl")

function occupy(rock, offset, occupied)
    highest = offset[1]
    rock_size = (size(rock, 1), size(rock, 2))
    for rock_row in 1:rock_size[1]
        for rock_col in 1:rock_size[2]
            if rock[rock_row, rock_col] == 1
                row = offset[1] + rock_size[1] - rock_row + 1
                col = offset[2] + rock_col
                highest = max(highest, row)
                occupied[row, col] = 1
            end
        end
    end
    highest
end

function canmove(rock, offset, occupied)
    rock_size = (size(rock, 1), size(rock, 2))
    if offset[2] < 0 || offset[2] + rock_size[2] > size(occupied)[2] ||
       offset[1] < 0
        # move into a wall
        return false
    end
    
    for rock_row in 1:rock_size[1]
        for rock_col in 1:rock_size[2]
            if rock[rock_row, rock_col] == 1
                row = offset[1] + rock_size[1] - rock_row + 1
                col = offset[2] + rock_col
                if occupied[row, col] == 1
                    return false
                end
            end
        end
    end
    true
end

function simulate(moves, stop)
    types = [
        [1 1 1 1],
        [0 1 0; 1 1 1; 0 1 0],
        [0 0 1; 0 0 1; 1 1 1],
        [1; 1; 1; 1],
        [1 1; 1 1],
    ]

    # Cache the state at 2022, and then find a cycle that begins there
    cache = ()
    rep_round = 2022
    heights = []
    
    wide = 7
    occupied = zeros((rep_round*100, wide))
    round = moveind = rockind = highest = 0

    while (moveind, rockind) != cache
        if round == rep_round
            # Cache the combination
            cache = (moveind, rockind)
            println("Height after 2022 rounds: $highest")
        end
        
        round += 1
        rockind = ((round-1)%length(types)) + 1
        rock = types[rockind]                
        
        offset = (highest + 3, 2)
        while true
            moveind = (moveind % length(moves)) + 1
            goright = moves[moveind] == ">"

            # First move
            new_offset = (offset[1], offset[2] + (if goright 1 else -1 end))
            if canmove(rock, new_offset, occupied)
                offset = new_offset
            end 
        
            # Then fall
            new_offset = (offset[1] - 1, offset[2])
            if canmove(rock, new_offset, occupied)
                offset = new_offset
            else
                highest = max(occupy(rock, offset, occupied), highest)
                push!(heights, highest)
                break
            end
        end

    end
    
    # The first cycle starts at rep_round, then goes until the last one
    cycle_length = round - rep_round
    nbr_cycles = div(stop-rep_round, cycle_length)

    last_height = heights[rep_round]
    cycle_height = highest - last_height

    full_cycles_height = nbr_cycles * cycle_height
    
    # Now how much is left after the last full cycle?
    rounds_left = stop - nbr_cycles*cycle_length

    # Both for getting to rep_round, and then the extra rounds to reach stop
    extra_height = heights[rounds_left]
    println("Height after $stop rounds: $(full_cycles_height + extra_height)")
    
end

function main(input="input.txt")
    moves = split(readlines(input)[1], "") 

    simulate(moves, 1000000000000)     
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end