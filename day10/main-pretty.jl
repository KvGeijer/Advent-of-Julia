include("utils.jl")

function main(input="input.txt")
    instructions = parse_vecvec(input, type=String) 
    crt = fill(" ", (6, 40))
    
    part1 = x = y = 0
    reg = ind = 1
    waited = false
    
    for cycle in 1:6*40
        instr = instructions[ind]
        
        part1 += reg * cycle * (cycle  % 40 == 20)
        crt[y+1, x+1] = abs(reg - x) <= 1 ? "#" : " "
        
        x = (x+1) % 40
        y += x == 0
        
        if waited
            reg += parse(Int, instr[2])
            waited = false
        elseif instr[1] != "noop"
            waited = true
            continue
        end
        ind += 1
    end
    
    println(part1)
    printmat(crt)
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end