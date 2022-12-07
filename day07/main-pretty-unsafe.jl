function findsizes!(dirsizes, dir)
    size = map(collect(dir)) do (name, val)
        if name == ".."
            0
        elseif isa(val, Dict)
            findsizes!(dirsizes, val)
        else
            val
        end
    end |> sum
   
    push!(dirsizes, size)
    size
end

function buildsystem(instructions)
    current = fs = Dict()

    for instr in instructions
        if instr[2] == "ls"
            continue
        elseif instr[1] == "dir"
            current[instr[2]] = Dict{String, Any}(".." => current)
        elseif length(instr) == 2
            current[instr[2]] = parse(Int, instr[1])
        elseif instr[3] == "/"
            current = fs
        else
            current = current[instr[3]]
        end
    end
    fs
end


function main(input="input.txt")
    fs = buildsystem(split.(readlines(input), " "))
    
    dirsizes = []
    totsize = findsizes!(dirsizes, fs)

    smallsizes = filter(size -> size < 100000, dirsizes) |> sum
    println(smallsizes)

    freesize = filter(size -> totsize - size <= 40000000, dirsizes) |> minimum
    println(freesize)
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end