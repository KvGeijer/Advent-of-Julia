include("utils.jl")

function main(input="input.txt")
    # Might as well practice using my library functions
    rangepairs = map(parse_int_re_lines(r"(\d+)-(\d+),(\d+)-(\d+)")) do line
        (Set(line[1]:line[2]), Set(line[3]: line[4]))
    end
    
    # Part 1
    fulloverlaps = filter(rangepairs) do pair
        intersect(pair[1], pair[2]) in pair
    end
    println(length(fulloverlaps))

    # Part 2
    partialoverlaps = filter(rangepairs) do pair
        !isempty(intersect(pair[1], pair[2]))
    end
    println(length(partialoverlaps))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end