# Copy paste utils into file 
include("utils.jl")


function main(input="input.txt")
    instructions = parse_vecvec(type=String, file=input)
    
    vis = Set()
    pos = [[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]]
    push!(vis, pos[10])

    for instr in instructions
        mdir = instr[1]
        len = parse(Int, instr[2])

        for iii in 1:len
            if mdir == "R"
                pos[1][2] += 1
            elseif mdir == "L"
                pos[1][2] -= 1
            elseif mdir == "U"
                pos[1][1] -= 1
            else
                pos[1][1] += 1
            end

            # Catch up
            for ind in 2:10
                # println("loop $ind, pos $(pos[ind])")
                if maximum(abs.(pos[ind-1] - pos[ind])) > 1
                    diff = pos[ind-1] - pos[ind]
                    dir = div.(diff, max.([1,1], abs.(diff)))
                    pos[ind] += dir
                    if ind == 10
                        # println("move $ind, pos $(pos[ind])")
                        push!(vis, pos[10])
                    end
                end
            end
        end
        # println("Head: $(pos[1])")
    end

    for row in (-20:20)
            r = ""
        for col in (-15: 15)
            if [row, col] in vis
                r = r*"#"
            else
                r = r*"."
            end
        end
            println(r)
    end

    println(length(vis))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end