# Copy paste utils into file 
include("utils.jl")

function dist(sensor)
    sum(abs.(sensor[1:2] - sensor[3:4]))
end

function disallow(allowed, disallowed)
    result = []
    if disallowed[1] > allowed[1]
        # Exists some part at bottom which is safe
        if disallowed[1] > allowed[2]
            # Everything safe
            return [allowed]
        else
            push!(result, (allowed[1], disallowed[1]-1))
        end
    end
    if disallowed[2] < allowed[2]
        # Exists some part at top which is safe
        if disallowed[2] < allowed[1]
            # Everything safe
            return [allowed]
        else
            push!(result, (disallowed[2]+1, allowed[2]))
        end
    end
    result
end

function allowed_row(sensors, row, allowed)
    foldfunc = (acc, sensor) -> begin
        dx = dist(sensor) - abs(sensor[2]-row)
        if dx < 0
            acc
        else
            range = (sensor[1]-dx, sensor[1]+dx)
            vcat(map(ok -> disallow(ok, range), acc)...)
        end
    end
    foldl(foldfunc, sensors, init=allowed)
end

function main(input="input.txt")
    sensors = parse_re_lines(input, r"Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)")
    sensors = map(line ->parse.(Int, line), sensors)

    # Part 1
    range = [(typemin(Int), typemax(Int))]
    allowed = allowed_row(sensors, 2000000, range)
    
return
    # Part 2
    upper = 4000000
    for row in 0:upper
        allowed = allowed_row(sensors, row, [(0, upper)])
        if !isempty(allowed)
            println(allowed[1][1]*4000000+row)
            # break
        end
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end