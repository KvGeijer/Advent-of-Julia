# Copy paste utils into file 
include("utils.jl")

function to_decimal(str)
    total = 0
    for i in str
        total *= 5
        if i == '2'
            total += 2
        elseif i == '1'
            total += 1
        elseif i == '0'
            total += 0
        elseif i == '-'
            total -= 1
        elseif i == '='
            total -= 2
        else
            println("WRONG!")
            error(1)
        end
    end
    total
end

function to_snafu(dec)

    arr = []
    for exp in reverse(0:21)        
        cs = [c for c in [0, 1, 2].* sign(dec)]
        c = maxby(c -> -abs(dec - c*5^exp), cs)

        diff = c*5^exp
        dec = dec - diff
        push!(arr, c)

        println("$dec = ($(dec+diff) - $c*5^$exp), diff = $diff, $c")
    end
    
    if dec != 0
        println("NONEXACT! $dec")
    end
    join(replace(arr, 1=>"1", 2=>"2", 0=>"0", -1=>"-", -2=>"="))
end

function main(input="input.txt")
    sum(to_decimal, readlines(input)) |> to_snafu |> println
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end