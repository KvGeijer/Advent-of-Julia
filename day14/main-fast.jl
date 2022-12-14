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
    @time begin
        debris = parse_rocks(input)
        sand = [[500]]

        bottom = maxby(p -> p[2], debris)[2] + 1

        for y in 1:bottom
            lastlayer = sand[end]
            layer = []
        
            minx = lastlayer[1] - 1
            for lastx in lastlayer
                for x in max(minx, lastx-1):(lastx+1)
                    if !([x,y] in debris) 
                        push!(layer, x)
                    end
                end
                minx = lastx+2
            end
            push!(sand, layer)
        end
    end
    println(sum(length.(sand)))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end