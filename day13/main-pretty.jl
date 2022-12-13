# Copy paste utils into file 
include("utils.jl")

accept_char(str) = (str[1], str[2:end])

function accept_int(str)
    ind = 1
    while isdigit(str[ind])
        ind += 1
    end
    (parse(Int, str[1:ind-1]), str[ind:end])
end

function accept_list(str)
    list = []
    (char, str) = accept_char(str)
    while char != ']'
        if isdigit(first(str))
            (int, str) = accept_int(str)
            push!(list, int)
        elseif first(str) == '['
            (nested_list, str) = accept_list(str)
            push!(list, nested_list)
        end

        (char, str) = accept_char(str)
    end
    return (list, str)
end

# Returns true, false or nothing
function cmp(left::Vector, right::Vector)
    for (leftel, rightel) in zip(left, right)
        res = cmp(leftel, rightel)
        if res != nothing
            return res
        end
    end
    cmp(length(left), length(right))
end

function cmp(left::Int, right::Int)
    if left < right
        true
    elseif right < left
        false
    else
        nothing
    end
end

function cmp(left:: Int, right::Vector)
    cmp([left], right)
end

function cmp(left:: Vector, right::Int)
    cmp(left, [right])
end

cmp_out(left, right) = cmp(left, right) == true

function main(input="input.txt")
    pairs = map.(str -> accept_list(str)[1], splitit(readlines(input), ""))

    # Part 1
    findall(pair -> cmp_out(pair[1],pair[2]), pairs) |> sum |> println
    
    # Part 2
    flags = [[[2]], [[6]]]
    allpairs = sort(vcat(push!(pairs, flags)...), lt=cmp_out)
    findall(in(flags), allpairs) |> prod |> println
    
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end