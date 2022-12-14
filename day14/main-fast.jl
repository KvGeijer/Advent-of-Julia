include("utils.jl")

function parse_rocks(input)
    rocks = Set()
    for line in readlines(input)
        coords = map(pair -> parse.(Int, pair), split.(split(line, " -> "), ','))
        for (prev, next) in zip(coords[1:end-1], coords[2:end])
            diff = sign.(next - prev)
            while (prev != next)
                push!(rocks, prev)
                prev = prev + diff
            end
            push!(rocks, prev)
        end
    end
    rocks
end

function main(input="input.txt")
    debris = parse_rocks(input)
    sand = Set()
    reachable = Set([[500, 0]])

    bottom = maxby(p -> p[2], debris)[2] + 2

    while !isempty(reachable)
        coord = pop!(reachable)
        if coord in sand
            continue
        end
        push!(sand, coord)
        for dir in -1:1
            next = coord + [dir, 1]
            if !(next in debris) && next[2] != bottom
                push!(reachable, next)
                # println("Pushing")
                # println(reachable)
            end
        end
        # println(length(reachable))
    end
    println(length(sand))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end