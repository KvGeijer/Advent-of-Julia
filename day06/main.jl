# Copy paste utils into file 
include("utils.jl")


function main(input="input.txt")
    chars = parse_vecvec(file=input, type=Char, colsep="")[1]

    processed = []

    for c in chars
        if length(processed) < 14 || length(Set(processed[end-13:end])) != 14
            push!(processed, c)
        else
            break
        end
    end

    println(length(processed))        
    
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end