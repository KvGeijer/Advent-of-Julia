# Copy paste utils into file 
include("utils.jl")

function priority(char)
    if isuppercase(char)
        char - 'A' + 27
    else
        char - 'a' + 1
    end
end

function main(input="input.txt")
    rugsacks = parse_vecvec(type=Char, colsep="")
    
    priorities = map(rugsacks) do sack
        len = length(sack)
        first = sack[1:div(len,2)]
        second = sack[(div(len,2) + 1):end]
        
        infirst = Set()
        insecond = Set()
        
        res = 0
        
        for item in first
            push!(infirst, item)
        end
        for item in second
            if item in infirst
                res = priority(item)
                break
            end
        end
        res
        
    end
    
    println(sum(priorities))
    
    p2 = 0
    uniques = map(sack -> Set(sack), rugsacks)
    for i in 1:div(length(rugsacks), 3)
        first = rugsacks[i*3-2]
        sec = rugsacks[i*3-1]
        third = rugsacks[i*3]
        common = intersect(first,sec,third)
        for el in common
            p2 += priority(el)
            break
        end 
    end
    
    println(p2)
    #println(rugsacks[1])   
        
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end