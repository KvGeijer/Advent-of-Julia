# Copy paste utils into file 
include("utils.jl")

function dist(sx,sy,bx,by)
    abs(sx-bx) + abs(sy-by)
end

# dirs .* [x,y] <= bounds
# dirs[1]x <= bounds[1]
# struct constraint
#     dirs :: Vector{Int}
#     bounds :: Vector{Int}
# end

# struct region
#     outside_border :: Vector{Tuple{Int, Int}}, 
#     inside_hole :: Vector{Tuple{Int, Int}}
# end


# Inside :: [[Int, Int]]

# Can we connect two scanners to one region?
# function do_connect([sx1, sy1, bx1, by1], [sx2, sy2, bx2, by2])
#     d1 = dist(sx1, sy1, bx1, by1)
#     d2 = dist(sx2, sy2, bx2, by2)

#     sum(abs.([sx1, sy1] - [sx2, sy2])) <= (d1+d2)
# end

# function intersect(from, to, center, d)
#     if any(from .== to) # straight
#         maxdiff = 
#     else # Diagonal

#     end
    

    
# end

# Checks if we can anchor the scanner to the inside region
# function do_overlap(sx, sy, bx, by, inside)

#     d = dist(sx, sy, bx, by)
#     for ind in 1:length(inside)
#         from = inside[ind]
#         to = if ind == length(inside) inside[1] else inside[ind+1] end

#         if intersect(from, to, [sx, sy], d)
#             return true
#         end
#     end
#     false
# end

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

function main(input="input.txt")
    sensors = parse_re_lines(input, r"Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)")
    sensors = map(line ->parse.(Int, line), sensors)

    sorted = sort(sensors, by= s -> abs(s[1] -s[3]) + abs(s[2] - s[4]))


    upper = if input == "ex" 20 else 4000000 end
    
    # inside:: Vec{Vec{Int, Int}} = [[0,0], [0, upper], [upper, upper], [upper, 0]]
    
        
    for row in 0:upper
        allowed = [(0, upper)]
        for (sx,sy,bx,by) in sensors
            if isempty(allowed)
                break
            end
        
            d = dist(sx,sy,bx,by)

            # Find overlap on row

            torow = abs(sy-row)
            if torow > d
                continue
            end
            
            dx = d - torow
            range = (sx-dx, sx+dx)
            
            newallowed = []
            for oldrange in allowed
                # println(disallow(oldrange, range))
                append!(newallowed, disallow(oldrange, range))
            end

            # println("Beacon: $([sx, sy, d])")
            # println("Still allowed: $(reverse(newallowed))")
            allowed = reverse(newallowed)
            
        end
        if length(allowed) > 0
            println("Finished! $row")
            println(allowed)
            println(allowed[1][1]*4000000+row)
        end
    end


    
    # row1 = if input == "ex" 10 else 2000000 end
    # searched = Set()
    # beacons = Set()

    # for (sx, sy, bx, by) in sensors
    #     dx = abs(sx - bx)
    #     dy = abs(sy - by)
    #     dist = dx + dy

    #     if by == row1
    #         push!(beacons, bx)
    #     end

    #     fromrow1 = abs(sy - row1)
    #     for col in -(dist - fromrow1):(dist - fromrow1)
    #         push!(searched, sx+col)
    #     end
    # end

    # println(length(setdiff(searched, beacons)))
    # println(searched |> collect |> sort)

    # searched = Set()

    # for (sx, sy, bx, by) in sensors
    #     dx = abs(sx - bx)
    #     dy = abs(sy - by)
    #     dist = dx + dy

    #     for row in (-dist):dist
    #         for col in -(dist - abs(row)):(dist - abs(row))
    #             push!(searched, [sx+col, sy+row])
    #         end
    #     end        
    # end

    # println(length(searched))

    
        
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end