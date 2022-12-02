# Copy paste utils into file 
include("utils.jl")


function main(input="input.txt")
    elves = splitit(readlines(input), "")
    calories = map(elf -> sum(parse.(Int, elf)), 
                   elves)
    
    println(maximum(calories))
    println(sum(sort(calories)[end-2:end]))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end