# Copy paste utils into file 
include("utils.jl")

function do_move!(pos, dir, dist, karta)
    ind = findfirst(!=(0), dir)
    println(ind)
    
    for _ in 1:dist
        next_pos = pos + dir
       
        # Just make sure we are on a valid tile!
        # println(next_pos)
        while   next_pos[1] < 1 || 
                next_pos[1] > length(karta) || 
                next_pos[2] < 1 || 
                next_pos[2] > length(karta[next_pos[1]]) || 
                karta[next_pos[1]][next_pos[2]] == ' '
                
            if next_pos[ind] < 1 && ind == 1
                next_pos[1] = length(karta)
            elseif next_pos[ind] < 1
                next_pos[2] = length(karta[next_pos[1]])
            elseif (ind == 1 && next_pos[1] > length(karta)) || (ind == 2 && next_pos[2] > length(karta[next_pos[1]]))
                next_pos[ind] = 1
            else
                # On an empty space
                next_pos += dir
            end
        end

        if karta[next_pos[1]][next_pos[2]] == '#'
            return
        else
            pos[ind] = next_pos[ind]
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