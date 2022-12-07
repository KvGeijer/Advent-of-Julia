# Copy paste utils into file 
include("utils.jl")


function findsize(dirsizes, upper, currentname, current)
    size = 0
    for (name, val) in current
        if name == ".."
            continue
        elseif isa(val, Dict)
            size += findsize(dirsizes, upper*currentname, name, val)
        else
            size += val
        end
    end

    dirsizes[upper*"/"*currentname] = size
    size
end

function main(input="input.txt")
    lines = readlines(input)
    
    directories = Dict()
    current = directories

    i = 1
    while i <= length(lines)
        instr = split(lines[i], " ")
        if instr[1] != "\$"
            println("ERROR! NOT \$!")
            println(instr)
            println(i)
        elseif instr[2] == "cd" # cd
            if instr[3] == "/"
                current = directories
            elseif instr[3] == ".."
                current = current[".."]
            else
                #Assume we have already done ls...
                current = current[instr[3]]
            end
            i += 1
        elseif instr[2] == "ls" # ls
            i += 1
            while i <= length(lines) && lines[i][1] != '$'
                (info, name) = split(lines[i], " ")
                if !(name in keys(current))
                    if info == "dir"
                        current[name] = Dict(".." => current, "bullshit_typing" => 0)
                    else
                        size = parse(Int, info)
                        current[name] = size
                    end
                end
                i += 1
            end
        else
            println("STRANGE INSTR: ", instr)
        end
    end

    dirsizes = Dict()
    totsize = findsize(dirsizes, "", "/", directories)

    smallsize = 0
    for (name, size) in dirsizes
        if size <= 100000
            smallsize += size
        end
    end
    println(smallsize)

    unused = 70000000 - totsize
    freeup = 30000000 - unused

    best = totsize
    for (dir, size) in dirsizes
        if size >= freeup && size < best
            best = size
        end 
    end 

    println(best)

    
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end