# Copy paste utils into file 
include("utils.jl")

sandstart = (500, 0)

function parse_rocks(input)
    rocks = Dict()
    for line in readlines(input)
        coords = split(line, " -> ")
        coords = split.(coords, ',')
        prev = parse.(Int, coords[1])
        for next in coords[2:end]
            next = parse.(Int, next)
            diff = if next[1] > prev[1]
                [1, 0]
            elseif next[1] < prev[1]
                [-1, 0]
            elseif next[2] > prev[2]
                [0, 1]
            else
                [0, -1]
            end
            while (prev != next)
                rocks[prev] = "rock"
                prev = prev + diff
            end
            rocks[prev] = "rock"
            
            prev = next
        end
    end
    rocks
end

function main(input="input.txt")
    debris = parse_rocks(input)

    bottom = maxby(p -> p[2], keys(debris))[2]
    floor = bottom + 2

    sandunits = 0
    cycles = 0
    while true
        sandpos = [500, 0]
        if sandpos in keys(debris)
            println(sandunits)
            return
        end
        
        while true
            # Fall

            # Part 1
            # if sandpos[2] > bottom
            #     println("Wring")
            #     println(sandunits)
            #     return
            # end
            
            cycles += 1
            if sandpos[2] == (floor - 1)
                debris[sandpos] = "sand"
                break
            end
            
            
            if !((sandpos + [0, 1]) in keys(debris))
                sandpos += [0, 1]
            elseif !((sandpos + [-1, 1]) in keys(debris))
                sandpos += [-1, 1]
            elseif !((sandpos + [1, 1]) in keys(debris))
                sandpos += [1, 1]
            else
                debris[sandpos] = "sand"
                break
            end
        end
        sandunits += 1
    end
        
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end