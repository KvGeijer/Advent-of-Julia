# Copy paste utils into file 
include("utils.jl")

function parse_positions(pos0)
    pos = [[] for _ in 1:9]

    for r in reverse(1: (length(pos0) - 1))
        row = pos0[r]

        ci = 1
        for c in 2:4:(2 + 4*8)
        
            char = row[c]
            if char != ' '
                push!(pos[ci], char)
            end
            ci += 1
        end
    end
    pos
end


function main(input="input.txt")
    input = splitit(readlines(input), "")
    
    pos0 = input[1]
    steps = input[2]

    positions = parse_positions(pos0)
    #println(positions)

    for instr in split.(steps, ' ')
        nbr = parse(Int, instr[2])
        from = parse(Int, instr[4])
        to = parse(Int, instr[6])

        #println(nbr, from, to)

        temp = []
        for _ in 1:nbr
            el = pop!(positions[from])
            push!(temp, el)
        end

        temp = temp
        for _ in 1:nbr
            el = pop!(temp)
            push!(positions[to], el)
        end
    end

    for stack in positions
        print(stack[end])
    end
        
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end