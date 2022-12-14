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

    bottom = maxby(p -> p[2], debris)[2]

    part1 = sandunits = 0
    while !([500, 0] in debris)
        sandpos = [500, 0]
        
        while true
            dirs = [[dx, 1] for dx in [0,-1,1] if !(sandpos + [dx,1] in debris)]
            if isempty(dirs) || sandpos[2] == (bottom + 1)
                push!(debris, sandpos)
                break
            else
                sandpos += first(dirs)
            end                
        end
        part1 = sandpos[2] > bottom && part1 == 0 ? sandunits : part1
        sandunits += 1
    end
    println(part1)
    println(sandunits)
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end