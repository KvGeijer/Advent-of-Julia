# Copy paste utils into file 
include("utils.jl")

function simulate(nbrknots, instructions)    
    knots = [[0, 0] for _ in 1:nbrknots]

    vis = Set([[0, 0]])

    for (move, len) in instructions
        for _ in 1:parse(Int, len)
            # Move head
            if move == "R"
                knots[1][2] += 1
            elseif move == "L"
                knots[1][2] -= 1
            elseif move == "U"
                knots[1][1] -= 1
            else
                knots[1][1] += 1
            end

            # Catch up
            for ind in 2:nbrknots
                if maximum(abs.(knots[ind-1] - knots[ind])) > 1
                    diff = knots[ind-1] - knots[ind]
                    dir = div.(diff, max.([1,1], abs.(diff)))
                    knots[ind] += dir
                end
            end
            push!(vis, knots[nbrknots])
        end
    end

    length(vis)
end

function main(input="input.txt")
    instructions = parse_vecvec(type=String, file=input)

    simulate(2, instructions) |> println
    simulate(10, instructions) |> println
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end