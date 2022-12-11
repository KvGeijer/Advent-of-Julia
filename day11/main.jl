# Copy paste utils into file 
include("utils.jl")


function main(input="input.txt")
    monkeys = map(splitit(readlines(input), "")) do monkeylines
        monkey = Dict()
        monkey["items"] = parse.(Int128, replace.(split(monkeylines[2])[3:end], ","=>""))
        
        
        monkey["op"] = split(monkeylines[3])[end-1:end]
        monkey["test"] = parse(Int128, split(monkeylines[4])[end])
        monkey["true"] = parse(Int, split(monkeylines[5])[end]) + 1 # To fic julias 1 indexing
        monkey["false"] = parse(Int, split(monkeylines[6])[end]) + 1
        monkey["insp"] = 0
        monkey
    end
    
    multfactor = map(monkeys) do monkey
        monkey["test"]
    end |> prod
    
    for round in 1:10000 # rounds
        for ind in 1:length(monkeys)
            monkey = monkeys[ind]
            for item in monkey["items"]
                monkey["insp"] += 1
                
                # Update worry for item
                worry = if monkey["op"][1] == "+"
                    item + parse(Int128, monkey["op"][2])
                else
                    # println(ind)
                    # println(monkey["op"][2])
                    term = monkey["op"][2]
                    if term == "old"
                        item*item
                    else
                        item * parse(Int128, monkey["op"][2])
                    end
                end
                
                if worry < item
                    println("Overflow!")
                end

                # Decrease worry by factor 3
                # worry = div(worry, 3)
                worry = worry % multfactor
                 
                
                # Test the worry level
                divisible = (worry % monkey["test"]) == 0
                
                # Pass to true or false depending on divisible
                if divisible
                    push!(monkeys[monkey["true"]]["items"], worry)
                else
                    push!(monkeys[monkey["false"]]["items"], worry)
                end                   
            end
            monkey["items"] = []
        end
        if round in [100, 1000, 5000]
            println("Omw!")
            end
    end
    
    insp = map(monkeys) do monkey
        monkey["insp"]
    end
    sort(insp) |> println
    sort(insp)[end-1:end] |> println
    sort(insp)[end-1:end] |> prod |> println
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end