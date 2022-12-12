# Copy paste utils into file 
include("utils.jl")

function main(input="input.txt")
    hmap = parse_mat(input, type=Char, colsep="")
    
    # Find start and stop, and make them into normal char heights
    start = findall(c -> c == 'S', hmap) |> first |> Tuple
    stop = findall(c -> c == 'E', hmap) |> first |> Tuple
    hmap[start[1], start[2]] = 'a'
    hmap[stop[1], stop[2]] = 'z'
    
    hmap = map(char -> char - 'a', hmap)
    reached = Dict()
    reachable = Set([stop])
    part2 = 0
        
    steps = 0
    while !(start in keys(reached)) && !isempty(reachable)
        next_reachable = Set()
        for (row, col) in filter(p -> !(p in keys(reached)), reachable)
            h = hmap[row, col]
            reached[(row,col)] = steps
            part2 = h == part2 == 0 ? steps : part2
            for neigh in filter(p -> hmap[p[1], p[2]] >= h-1, adj((row, col), 4, (1,1), size(hmap)))
                push!(next_reachable, neigh)
            end
        end
        steps += 1
        reachable = next_reachable
    end
    
    println(reached[start])
    println(part2)
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end