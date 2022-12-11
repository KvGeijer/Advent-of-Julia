# Copy paste utils into file 
include("utils.jl")

mutable struct Monkey
    items     :: Vector{Int}
    op        :: Vector{AbstractString}
    test      :: Int
    iftrue    :: Int
    iffalse   :: Int
    count     :: Int
end

function simulate!(monkeys, rounds, destress)
    for monkey in first.(Iterators.product(monkeys, 1:rounds))
        for item in monkey.items
            monkey.count += 1
            
            # Julia does not seem to have a working fully fledged eval instruction
            term = monkey.op[2] == "old" ? item : parse(Int, monkey.op[2])
            worry = (monkey.op[1] == "*" ? (*) : (+))(item, term) |> destress
            
            to = worry % monkey.test == 0 ? monkey.iftrue : monkey.iffalse
            push!(monkeys[to].items, worry)
        end
        monkey.items = []
    end
    sort(map(monkey -> monkey.count, monkeys))[end-1:end] |> prod
end

function main(input="input.txt")
    monkeys = map(splitit(split.(readlines(input)), [])) do monkeylines
        items = parse.(Int, replace.(monkeylines[2][3:end], ","=>""))
        op = monkeylines[3][end-1:end]
        test = parse(Int, monkeylines[4][end])
        iftrue = parse(Int, monkeylines[5][end]) + 1
        iffalse = parse(Int, monkeylines[6][end]) + 1
        Monkey(items, op, test, iftrue, iffalse, 0)
    end
    
    simulate!(deepcopy(monkeys), 20, worry -> div(worry, 3)) |> println
        
    bigmodulo = map(monkey -> monkey.test, monkeys) |> prod
    simulate!(monkeys, 10000, worry -> worry % bigmodulo) |> println
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end