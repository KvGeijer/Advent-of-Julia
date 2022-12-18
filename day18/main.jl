# Copy paste utils into file 
include("utils.jl")

function dfs(coord, cubes_set, outside, visited, lower, upper)
    if coord in cubes_set || coord in visited 
        return nothing
    end
    if haskey(outside, coord)
        return outside[coord]
    end

    # Should not make any difference here with = ot not. But if not it finds more trapped ones...
    # This means there is some bug...
    if any(coord .>= upper) || any(coord .<= lower)
        # Can this be wrong?
        # Should just be able to keep going in that direction then and reach steam...
        outside[coord] = true
        return true
    end

    push!(visited, coord)

    # No easy case, so continue search
    for neigh in adj(coord, 6)
        out = dfs(neigh, cubes_set, outside, visited, lower, upper)
        if out != nothing
            outside[coord] = out
            return out
        end
    end

    # Could not find a conclusive way out, bsae case
    # outside[coord] = 
    # New base case... Can get trapped and now know!
    nothing
end

function main(input="input.txt")
    cubes = parse_vecvec(input, colsep=',')

    cubes_set = Set(cubes)
    areas = Dict()

    # Part 1
    for cube in cubes
        area = 0
        for neigh in adj(cube, 6)
            # println("Cube: $cube, neigh: $neigh")
            if !(neigh in cubes_set)
                area += 1
            end
        end
        areas[cube] = area
    end    
    areas |> values |> sum |> println

    # Part 2
    # We need to know when we go outside the grid
    lower = map(c -> minimum(cube -> cube[c], cubes), 1:3)
    upper = map(c -> maximum(cube -> cube[c], cubes), 1:3)
    
    # Strategy is to find all such air pockets, and remove area from connecting cubes
    # Dict of air coord visited, true if connected to outside, can rain
    outside = Dict()
    free_area = Dict()
    
    for cube in cubes
        free_air = 0
        for neigh in adj(cube, 6)
            # Do dfs comp, but use caching
            if dfs(neigh, cubes_set, outside, Set(), lower, upper) == true
                free_air += 1
                # println(neigh)
            end
        end
        
        free_area[cube] = free_air
    end    
    free_area |> values |> sum |> println
    
    
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end