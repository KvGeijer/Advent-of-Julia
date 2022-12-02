# Copy paste utils into file 
include("utils.jl")


function main(input="input.txt")
    calories = []
    cal = 0
    for line in readlines(input) 
        if length(line) == 0
            push!(calories, cal)
            cal = 0 
        else
            cal += parse(Int, line)
        end
    end
    
    println(maximum(calories))
    println(sum(sort(calories)[end-3:end]))
    
    
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end