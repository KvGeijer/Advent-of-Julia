include("./utils/linked_list.jl")

function parse_int_vec(file="input.txt")
    parse.(Int, readlines(file))
end

# parse a vec of vecs with given splits and type of elems
function parse_vecvec(file="input.txt"; type=Int, colsep=' ', rowsep='\n')
    vecvec = split.(split(strip(read(file, String)), rowsep), colsep)
    
    if type == Int
        map.(el -> parse(Int, el), vecvec)
    elseif type == Char
        map.(string -> string[1], vecvec)
    elseif type == String
        map.(string -> String(string), vecvec) #Don't want substring
    end
end 

parse_mat(file, ;colsep=' ', type=Int) =
    reduce(hcat, parse_vecvec(file, colsep=colsep, type=type)) |> permutedims

# Applies a regex to each line and collects the substrings
function parse_re_lines(file, regex)
    map(readlines(file)) do line
        collect(match(regex, line))
    end
end

# Parses lines according to regex and parses to ints
parse_int_re_lines(file, regex) =
    map.(el -> parse(Int, el), parse_re_lines(regex, file))

# This should be in stdlib, but can't find it.
# findmax does not seem to work well on dicts
# Find the element which is maximized by f
function maxby(f, it)
    largest = nothing    # Assumes at least one element
    for el in it
        if isnothing(largest) || f(el) > largest[1]
            largest = (f(el), el)
        end
    end
    largest[2]
end

# Input an iterator, and get a vec of vecs splitted on delim
function splitit(it, delim=nothing)
    res, chunk = [], []
    for el in it
        if el == delim
            push!(res, chunk)
            chunk = []
        else
            push!(chunk, el)
        end
    end
    push!(res, chunk)
    filter(chunk -> chunk != [], res) 
end

# Print a matrix with 1 char long elements
function printmat(mat)
    for row in 1:size(mat)[1]
        join(mat[row, :]) |> println
    end
end

# Find all neighbors to a point in 2D or 3D
function adj(coord, nbrneighs=8, lower=nothing, upper=nothing)
    # println(upper)
    neighs = 
        if length(coord) == 2
            # 2D
            neighs = map(p -> p .+ coord, collect(Iterators.product(-1:1, -1:1)))
            if nbrneighs == 4
                filter(p -> sum(abs.(coord .- p)) == 1, neighs)
            elseif nbrneighs == 8
                neighs
            else
                println("invalid neigbors for adj!")
                exit(0)
            end
        else
             # 3D       
            neighs = map(p -> p .+ coord, collect(Iterators.product(-1:1, -1:1, -1:1)))
            if nbrneighs == 6
                filter(p -> sum(abs.(coord .- p)) == 1, neighs)
            elseif nbrneighs == 26
                neighs
            else
                println("invalid neigbors for adj!")
                exit(0)
            end
        end
    neighs = filter(p -> p != coord, neighs)
    if lower != nothing
        neighs = filter(p -> all(p .>= lower), neighs)
    end
    if upper != nothing
        neighs = filter(p -> all(p .<= upper), neighs)
    end
    neighs
end
