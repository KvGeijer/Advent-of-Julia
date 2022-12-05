include("utils.jl")

printstacks(stacks) =
    println((stack[end] for stack in stacks) |> join)

function main(input="input.txt")
    (pos0, instructions) = splitit(readlines(input), "")    

    nbrstacks = parse(Int, pos0[end][end-1])
    stacks1 = [[row[col] for row in reverse(pos0[1:end-1]) if row[col] != ' ']
                         for col in 2:4:(nbrstacks*4 - 2)]
    stacks2 = copy.(stacks1)
    
    for instr in split.(instructions)
        (nbr, from, to) = parse.(Int, (instr[2], instr[4], instr[6]))
        
        append!(stacks1[to],         [pop!(stacks1[from]) for _ in 1:nbr])
        append!(stacks2[to], reverse([pop!(stacks2[from]) for _ in 1:nbr]))
    end

    printstacks(stacks1)
    printstacks(stacks2)
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end