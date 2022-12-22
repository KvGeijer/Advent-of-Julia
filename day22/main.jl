# Copy paste utils into file 
include("utils.jl")

function get_region(pos, karta)
    rwidth = div(length(karta[1]), 3)
    rheight = div(length(karta), 4)

    

    
    col = div(pos[2]-1, rwidth)
    row = div(pos[1]-1, rheight)

    # println("$col, $row, $pos")
    col + row*3 + 1
end

function do_move!(pos, dir, dist, karta)
    ind = findfirst(!=(0), dir)
    rwidth = 50
    rheight = 50

    for _ in 1:dist
        next_pos = pos + dir
        next_dir = copy(dir)
        # println(next_pos)

# Still keep the same direction meaning for 2d, but just do extra when wrapping over edges
# Part 2 map
#
#    2 3
#    5
#  7 8
#  10
#
        # Just make sure we are on a valid tile!
        # println(next_pos)
        region = get_region(pos, karta)
        rep = false
        while   next_pos[1] < 1 || 
                next_pos[1] > length(karta) || 
                next_pos[2] < 1 || 
                next_pos[2] > length(karta[next_pos[1]]) || 
                karta[next_pos[1]][next_pos[2]] == ' '
            println("$next_pos, $dir")

            if rep
                println("REPEATING: $region, $next_pos, $dir, $pos")
                error(1)
            end 
            # Just do it manually!
            if region == 2 && next_pos[1] < 1
                # Reappear from the left side of 10
                next_dir[1] = 0
                next_dir[2] = 1
                next_pos[1] = next_pos[2] - rwidth + 3*rheight
                next_pos[2] = 1
            elseif region == 2 && next_pos[2] <= rwidth
                # Reappear at left side of 7, but upside down
                next_dir[1] = 0
                next_dir[2] = 1
                next_pos[1] = 3*rheight - next_pos[1] + 1
                next_pos[2] = 1
            elseif region == 3 && next_pos[1] < 1
                # Reappear at bottom of 10
                next_dir[1] = -1
                next_dir[2] = 0
                next_pos[1] = 4*rheight
                next_pos[2] -= 2*rwidth
            elseif region == 3 && next_pos[2] > length(karta[1])
                # Reappear at right side of 8
                next_dir[1] = 0
                next_dir[2] = -1
                next_pos[1] = 3*rheight + 1 - next_pos[1]
                next_pos[2] = 2*rwidth
            elseif region == 3 && next_pos[1] > rheight
                # Get to right of 5
                next_dir[1] = 0
                next_dir[2] = -1
                next_pos[1] = rheight + (next_pos[2] - 2*rwidth)
                next_pos[2] = 2*rwidth
            elseif region == 5 && next_pos[2] > 2*rwidth
                # To bottom of 3
                next_dir[1] = -1
                next_dir[2] = 0
                next_pos[2] = (next_pos[1] - rheight) + 2*rwidth
                next_pos[1] = rheight
            elseif region == 5 && next_pos[2] <= rwidth
                # top of 7
                next_dir[1] = 1
                next_dir[2] = 0
                next_pos[2] = next_pos[1] - rheight
                next_pos[1] = 1 + 2*rheight
            elseif region == 8 && next_pos[2] > 2*rwidth
                # Right of 3
                next_dir[1] = 0
                next_dir[2] = -1
                next_pos[1] = rheight + 1 - (next_pos[1] - 2*rheight)
                next_pos[2] = 3*rwidth
            elseif region == 8 && next_pos[1] > 3*rheight
                # To right of 10
                next_dir[1] = 0
                next_dir[2] = -1
                next_pos[1] = next_pos[2] - rwidth + 3*rheight
                next_pos[2] = rwidth
            elseif region == 7 && next_pos[1] <= 2*rheight
                # Left of 5
                next_dir[1] = 0
                next_dir[2] = 1
                next_pos[1] = rheight + next_pos[2]
                next_pos[2] = rwidth + 1
            elseif region == 7 && next_pos[2] < 1
                # Left of 2
                next_dir[1] = 0
                next_dir[2] = 1
                next_pos[1] = rheight + 1 - (next_pos[1] - 2*rheight)
                next_pos[2] = rwidth + 1
            elseif region == 10 && next_pos[2] < 1
                # Top of 2
                next_dir[1] = 1
                next_dir[2] = 0
                next_pos[2] = next_pos[1] - 3*rheight + rwidth
                next_pos[1] = 1
            elseif region == 10 && next_pos[1] > length(karta)
                # Top of 3
                next_dir[1] = 1
                next_dir[2] = 0
                next_pos[1] = 1
                next_pos[2] = next_pos[2] + 2rwidth
            elseif region == 10 && next_pos[2] > rwidth
                # Bottom of 8
                next_dir[1] = -1
                next_dir[2] = 0
                next_pos[2] = (next_pos[1] - 3*rheight) + rwidth
                next_pos[1] = 3*rheight
            else
                println("IM LOST: $next_pos, $dir, $region, $pos")
                error(1)
            end

            rep = true
                           
        end

        if karta[next_pos[1]][next_pos[2]] == '#'
            return
        else
            dir[1] = next_dir[1]
            dir[2] = next_dir[2]
            pos[1] = next_pos[1]
            pos[2] = next_pos[2]
        end
    end
end

function main(input="input.txt")
    (karta, moves) = splitit(readlines(input), "")
    moves = moves[1]

    
    pos = [1, findfirst(!=(' '), karta[1])]
    dir = [0, 1]

    move_ind = 1

    
    while move_ind <= length(moves)
        # Move forwards
        if isdigit(moves[move_ind])
            dist = parse(Int, moves[move_ind])
            while move_ind < length(moves) && isdigit(moves[move_ind+1])
                move_ind += 1
                dist = dist*10 + parse(Int, moves[move_ind])
            end
            do_move!(pos, dir, dist, karta)            
        else
            change = moves[move_ind]
            if change == 'R'
                if dir == [0, 1]
                    # Facing right
                    dir = [1, 0]
                elseif dir == [1, 0]
                    dir = [0, -1]
                elseif dir == [0, -1]
                    dir = [-1, 0]
                else
                    dir = [0, 1]
                end
            elseif change == 'L'
                if dir == [0, 1]
                    # Facing right
                    dir = [-1, 0]
                elseif dir == [-1, 0]
                    dir = [0, -1]
                elseif dir == [0, -1]
                    dir = [1, 0]
                else
                    dir = [0, 1]
                end
            end
        end
        move_ind += 1
    end

    
    facing = 
        if dir == [0, 1]
            # Facing right
            0
        elseif dir == [1, 0]
            1
        elseif dir == [0, -1]
            2
        else
            3
        end

    pswd = 1000*pos[1] + 4*pos[2] + facing
    println(pswd)

        
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end