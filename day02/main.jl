# Copy paste utils into file 
include("utils.jl")

function score(move)
    if move == 'X'
        1
    elseif move == 'Y'
        2
    elseif move == 'Z'
        3
    else
        println("invalid move: ", move)
    end
end

function result(opp, you)
    if you == 'X' && opp == 'C'
        'Y'
    elseif you == 'X' && opp == 'A'
        'Z'
    elseif you == 'X' && opp == 'B'
        'X'
    elseif you == 'Y' && opp == 'A'
        'X'
    elseif you == 'Y' && opp == 'B'
        'Y'
    elseif you == 'Y' && opp == 'C'
        'Z'
    elseif you == 'Z' && opp =='B'
        'Z'
    elseif you == 'Z' && opp == 'C'
        'X'
    elseif you == 'Z' && opp == 'A'
        'Y'
    else
        println("Panic!")
        0
    end
end

function main(input="input.txt")
    moves = readlines("input.txt")
    total = 0
    # println(moves[1])
    for line in moves
        #println("line: ", moves)
        opp, res = line[1], line[3]
        you = result(opp, res)
        #if score == 6
        total += score(you)
        if res == 'X'
        total += 0
        elseif res == 'Y'
        total += 3
        elseif res == 'Z'
        total += 6
        end
        #end
        
    end

    println(total)
        
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end