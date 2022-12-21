using Match

mutable struct Monkey
    val :: Union{Nothing, Int}
    op :: Char
    left :: Monkey
    right :: Monkey
    Monkey() = new(nothing)
end

function balance!(monkey)
    # Ugly
    (unbalanced, balanced) = 
        if isnothing(monkey.left.val)
            (monkey.left, monkey.right.val)
        else
            (monkey.right, monkey.left.val)
        end
    while true
        if unbalanced.op == '?'
            unbalanced.val = balanced
            return
        end

        # Ugly
        (ubb, ubub) = 
            if isnothing(unbalanced.left.val) 
                (unbalanced.right.val, unbalanced.left) 
            else 
                (unbalanced.left.val, unbalanced.right) 
            end

        # Ugly dependency on orderings
        balanced = @match unbalanced.op begin
            '*' => div(balanced, ubb)
            '/' => begin
                    if ubub === unbalanced.left
                        # ubub / ubb = balanced
                        balanced * ubb
                    else
                        # ubb / ubub = balanced
                        div(ubb, balanced)
                    end                
                end
            '+' => balanced - ubb
            '-' => begin
                    if ubub === unbalanced.left
                        # ubub - ubb = balanced
                        balanced + ubb
                    else
                        # ubb - ubub = balanced
                        ubb - balanced
                    end                
                end
        end

        unbalanced = ubub
    end
end

function simulate!(monkey)
    if isnothing(monkey.val) && monkey.op != '?'
        left = simulate!(monkey.left)
        right = simulate!(monkey.right)
        if typeof(left) == typeof(right) == Int
            monkey.val = @match monkey.op begin
                '*' => left * right
                '/' => div(left, right)
                '+' => left + right
                '-' => left - right
            end
            monkey.val
        elseif monkey.op == '=' 
            balance!(monkey)
        else
            nothing
        end
    elseif !isnothing(monkey.val)
        # Already computed
        monkey.val
    else 
        # Must be humn, so just return nothing.
        nothing
    end    
end

function main(input="input.txt")
    orchestra = split.(readlines(input), ": ")
    monkeys = Dict([(monkey, Monkey()) for monkey in first.(orchestra)])
    for (name, rest) in orchestra
        monkey = monkeys[name]
        @match split(rest, " ") begin
            [left, op, right] => begin
                    if !haskey(monkeys, left) monkeys[left] = Monkey() end
                    if !haskey(monkeys, right) monkeys[right] = Monkey() end
                    
                    monkey.left = monkeys[left] 
                    monkey.right = monkeys[right] 
                    monkey.op = op[1]
                end
            [nbr] => begin
                monkey.val = parse(Int, nbr)
            end
        end
    end

    simulate!(deepcopy(monkeys)["root"]) |> println
    
    monkeys["humn"].val = nothing
    monkeys["humn"].op = '?'
    monkeys["root"].op = '='
    simulate!(monkeys["root"])
    println(monkeys["humn"].val)
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end