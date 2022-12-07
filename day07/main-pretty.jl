function findsizes!(dirsizes, current)
    size = 0
    for (name, val) in current
        if name == ".."
            continue
        elseif isa(val, Dict)
            size += findsizes!(dirsizes, val)
        else
            size += val
        end
    end

    push!(dirsizes, size)
    size
end

function buildsystem(instructions)
    current = fs = Dict()

    i = 1
    while i <= length(instructions)
        instr = instructions[i]
        if instr[2] == "cd"
            if instr[3] == "/"
                current = fs
            else
                current = current[instr[3]]
            end
            i += 1
        else
            i += 1
            while i <= length(instructions) && instructions[i][1] != "\$"
                info, name = instructions[i]
                if !(name in keys(current))
                    if info == "dir"
                        current[name] = Dict()
                        current[name][".."] = current
                    else
                        current[name] = parse(Int, info)
                    end
                end
                i += 1
            end
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