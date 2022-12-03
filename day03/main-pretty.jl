# Copy paste utils into file 
include("utils.jl")

function priority(char)
    if isuppercase(char)
        char - 'A' + 27
    else
        char - 'a' + 1
    end
end

function main(input="input.txt")
    rugsacks = parse_vecvec(type=Char, colsep=""; file=input)
    
    # Part 1
    priorities = map(rugsacks) do sack
        infirst = Set(sack[1:div(end, 2)])
        filter(in(infirst), sack) |> last |> priority
    end
    println(sum(priorities))
    
    # Part2
    badgeprios = map(Iterators.partition(rugsacks, 3)) do (s1, s2, s3)
        intersect(s1, s2, s3) |> first |> priority
    end
    println(sum(badgeprios))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end