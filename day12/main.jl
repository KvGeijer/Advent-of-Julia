# Copy paste utils into file 
include("utils.jl")



function main(input="input.txt")
    hmap = parse_vecvec(input, type=Char, colsep="")
    
    start = stop = (0, 0)
    
    reached = Dict()
    reachable = []
    
    for row in 1:length(hmap)
        for col in 1:length(hmap[1])
            char = hmap[row][col]
            if char == 'E'
                start = (row, col)
                reached[start] = 0
                hmap[row][col] = 'z'
                for (r, c) in Iterators.product([row-1, row, row+1], [col, col+1])
                    if r >= 1 && (r == row || c == col)
                        println("Adj E: $((r, c))")
                        adjs = hmap[r][c]
                        if adjs in ['z', 'y']
                            push!(reachable, (r,c))
                        end
                    end
                end
            elseif char == 'S'
                # stop = (row, col)
                hmap[row][col] = 'a'
            end
        end
    end
    
    hmap = map.(char -> char - 'a', hmap)

    println(stop)

    steps = 1
    while true
        next_reachable = []
        for (row, col) in reachable
            if !((row, col) in keys(reached))
                h = hmap[row][col]
                reached[(row,col)] = steps
                if h == 0
                    println(steps)
                    return
                end
                for (r, c) in Iterators.product([row-1, row, row+1], [col-1,col, col+1])
                    if (r == row || c == col) && (r, c) != (row, col) && 1 <= r <= length(hmap) && 1 <= c <= length(hmap[1]) && hmap[r][c] >= h-1
                        # Ok point, if not added before
                        push!(next_reachable, (r,c))
                    end
                end
            end
        end
        steps += 1
        reachable = next_reachable
    end
    
    println(reached[stop])
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end