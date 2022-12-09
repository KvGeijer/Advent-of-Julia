include("./utils/linked_list.jl")

function parse_int_vec(file="input.txt")
    parse.(Int, readlines(file))
end

# parse a vec of vecs with given splits and type of elems
function parse_vecvec(;type=Int, colsep=' ', rowsep='\n', file="input.txt")
    vecvec = split.(split(strip(read(file, String)), rowsep), colsep)
    
    if type == Int
        map.(el -> parse(Int, el), vecvec)
    elseif type == Char
        map.(string -> string[1], vecvec)
    elseif type == String
        map.(string -> String(string), vecvec) #Don't want substring
    end
end 

parse_mat(;colsep=' ', type=Int, file="input.txt") =
    reduce(hcat, parse_vecvec(colsep=colsep, file=file, type=type))'

# Applies a regex to each line and collects the substrings
function parse_re_lines(regex, file="input.txt")
    map(readlines(file)) do line
        collect(match(regex, line))
    end
end

# Parses lines according to regex and parses to ints
parse_int_re_lines(regex, file="input.txt") =
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
