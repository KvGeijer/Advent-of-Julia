include("utils.jl")

function part1(instructions, stacks)
    for instr in split.(instructions)
        (nbr, from, to) = parse.(Int, (instr[2], instr[4], instr[6]))

        append!(stacks[to], [pop!(stacks[from]) for _ in 1:nbr])
    end
    stacks
end

function part2(instructions, stacks)
    for instr in split.(instructions)
        (nbr, from, to) = parse.(Int, (instr[2], instr[4], instr[6]))
        
        append!(stacks[to], reverse([pop!(stacks[from]) for _ in 1:nbr]))
    end
    stacks
end

function main(input="input.txt")
    (pos0, instructions) = splitit(readlines(input), "")    

    nbrstacks = parse(Int, pos0[end][end-1])
    stacks = [[row[col] for row in reverse(pos0[1:end-1]) if row[col] != ' ']
                        for col in 2:4:(nbrstacks*4 - 2)]

    for part in (part1, part2)
        finalstacks = part(instructions, copy.(stacks))
        println((stack[end] for stack in finalstacks) |> join)
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end