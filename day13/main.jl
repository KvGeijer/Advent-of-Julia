# Copy paste utils into file 
include("utils.jl")

function accept_int(str, ind)
    res = 0
    while isdigit(str[ind])
        res = res*10 + parse(Int, str[ind])
        ind += 1
    end
    (res, ind)
end

# Returns (true/false/nothing, leftres, rightres)
function cmp(left, right)
    while true
        # println(left)
        # println(right)
        # println("")
        # Double if empty
        if isempty(left) || first(left) == ']' && !(isempty(right) || first(right) == ']')
            return (true, left, right)
        elseif isempty(left) || first(left) == ']'
            # Both empty
            return (nothing, left, right)
        elseif isempty(right) || first(right) == ']'
            return (false, left, right)
        end
        
        if first(right) == ','
            right = right[2:end]
        end
        if first(left) == ','
            left = left[2:end]
        end

        if isempty(left) || first(left) == ']' && !(isempty(right) || first(right) == ']')
            return (true, left, right)
        elseif isempty(left) || first(left) == ']' && !(isempty(right) || first(right) == ']')
            # Both empty
            return (nothing, left, right)
        elseif isempty(right) || first(right) == ']'
            return (false, left, right)
        end
    
        if '[' == first(left) == first(right)
            # Compare two new arrays
            (cont, left, right) = cmp(left[2:end], right[2:end])
            if cont == false
                return (false, left, right)
            elseif cont == true
                return (true, left, right)
            end
            # Left must have run out, TODO, clean up right?
            while first(right) != ']'
                right = right[2:end]
            end
            # Remove ]
            right = right[2:end]
            left = left[2:end]
            
        elseif isdigit(first(left)) && isdigit(first(right))
            # Compare two digits easily
            (lint, lind) = accept_int(left, 1)
            left = left[lind:end]
            (rint, rind) = accept_int(right, 1)
            right = right[rind:end]

            if (rint < lint)
                return (false, left, right)
            elseif (lint < rint)
                return (true, left, right)
            end
        else
            # An array and a digit, so conv string to match expected and continue
            if (isdigit(first(left)))
                (lint, lind) = accept_int(left, 1)
                left = left[lind:end]
                left = "[$lint]" * left
            else
                (rint, rind) = accept_int(right, 1)
                right = right[rind:end]
                right = "[$rint]" * right
            end
        end
    end
end

function ppairs(pairs)
    for pair in pairs
        println(pair)
    end
end

function main(input="input.txt")
    pairs = splitit(readlines(input), "")

    right_order = []
    pi = 1
    for (p1, p2) in pairs
        # Compare packets
        if cmp(p1, p2)[1] == true
            push!(right_order, pi)
        end
        pi += 1
    end 

           
    println(sum(right_order))

    # Part 2
    push!(pairs, ["[[2]]", "[[6]]"])
    # ppairs(pairs)
    allpairs = []
    for (p1, p2) in pairs
        push!(allpairs, p1)
        push!(allpairs, p2)
    end
    allpairs

    cmp1(x, y) = cmp(x,y)[1]
    sorted = sort(allpairs, lt=cmp1)

    inds = []
    for i = 1:length(sorted)
        if sorted[i] == "[[2]]" || sorted[i] == "[[6]]"
            push!(inds, i)
        end
    end
    prod(inds) |> println
    
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end