# Copy paste utils into file 
include("utils.jl")

function is_outside(coord, cubes, outside, visited, lower, upper)
    if coord in cubes || coord in visited 
        return false
    elseif coord in outside
        return true
    elseif any(coord .>= upper) || any(coord .<= lower)
        # Should just be able to keep going in that direction then and reach steam.
        push!(outside, coord)
        return true
    end
    
    # No easy case, so continue search
    push!(visited, coord)
    for neigh in adj(coord, 6)
        if is_outside(neigh, cubes, outside, visited, lower, upper)
            push!(outside, coord)
            return true
        end
    end

    # Trapped inside a bunch of visited ones
    false
end

function main(input="input.txt")
    cubes = Set(parse_vecvec(input, colsep=','))

    # Part 1
    sum(cubes) do cube
        count(adj(cube, 6)) do neigh
            !(neigh in cubes)
        end
    end |> println

    # Part 2
    # We need to know when we go outside the grid
    lower = map(c -> minimum(cube -> cube[c], cubes), 1:3)
    upper = map(c -> maximum(cube -> cube[c], cubes), 1:3)
    
    outside = Set()
    sum(cubes) do cube
        count(adj(cube, 6)) do neigh
            is_outside(neigh, cubes, outside, Set(), lower, upper)
        end
    end |> println
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end