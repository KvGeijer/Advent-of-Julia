using Match

include("utils.jl")

mutable struct CPU
    pc :: Int
    waited :: Int
    regs :: Dict{String, Any}
    CPU(iter) = new(
        1, 
        0, 
        Dict(iter)
    )
end

mutable struct CRT
    
end

# Crt dimensions
h = 6
w = 40
    
function main(input="input.txt")
    instructions = parse_vecvec(input, type=String) 
    crt = fill(" ", (h, w))
    cpu = CPU([("x", 1)])
    
    x = y = 0
    
    for cycle in 1:h*w
        if !(0 < cpu.pc <= length(instructions))
            break
        end
    
        # Day 10
        crt[y+1, x+1] = abs(cpu.regs["x"] - x) <= 1 ? "#" : " "
        
        # Update crt coords
        x = (x+1) % 40
        y += x == 0
        
        @match instructions[cpu.pc] begin
            "noop" => 1
            ["addx", val], if cpu.waited != 0 end => begin
                cpu.regs["x"] += parse(Int, val)
            end
            ["addx", _] => begin
                cpu.waited += 1
                continue
            end
        end
        
        cpu.waited = 0
        cpu.pc += 1
    end
    
    printmat(crt)
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end