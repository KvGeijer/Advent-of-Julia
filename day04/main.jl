# Copy paste utils into file 
include("utils.jl")
    

function main(input="input.txt")
    pairs = map(split.(readlines(input), ",")) do pair
        f = map(x -> parse(Int, x), split(pair[1], "-"))
        s = map(x -> parse(Int, x), split(pair[2], "-"))
        (f, s)
    end
    
    
    fulloverlaps = filter(pairs) do pair
        overlap = intersect(Set(pair[1][1]:pair[1][2]), Set(pair[2][1]:pair[2][2]))
        length(overlap) != 0
        # Part 1
        #length(overlap) == (pair[1][2] - pair[1][1] +1) || length(overlap) ==  (pair[2][2] - pair[2][1] +1) 
    end

    println(length(fulloverlaps))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end