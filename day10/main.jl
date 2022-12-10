# Copy paste utils into file 
include("utils.jl")

wide = 40
high = 5

function main(input="input.txt")

    crt = Int.(zeros(high+1, wide))
    y = x = 0

    instructions = parse_vecvec(input, type=String)
    
    regs = Dict("X" => 1)
    wait = 0
    cycle = 1
    ind = 1
    
    part1 = 0
    
    
    
    while ind <= length(instructions)
        instr = instructions[ind]
        if cycle in [20, 60, 100, 140, 180, 220]
            part1 += regs["X"] * cycle
        end
        
        if abs(regs["X"] - x) <= 1
            # draw 
            crt[y+1, x+1] = 1
        end
        if x == 39
            y += 1
            x = 0
        else
            x += 1
        end
        
        if y > high
            break
        end
        
        if instr[1] == "noop"
            ind += 1
        elseif wait == 1
            regs["X"] += parse(Int, instr[2])
            ind += 1
            wait = 0
        else
            wait = 1
        end
        
        
        cycle += 1
    end
    
    println(part1)
    
    
    for row in 1:high+1
        str = ""
        for col in 1:wide
            if crt[row, col] == 0
                str = str*"."
            else
                str = str*"#"
            end
        end
        println(str)
    end

        
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end