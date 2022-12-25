# Copy paste utils into file 
include("utils.jl")

to_decimal(str) = 
    foldl((acc, val) -> acc*5 + val, parse.(Int, replace(split(str, ""), "-" => "-1", "=" => "-2")))

function to_snafu(dec)
    exp = 0
    while dec >= 5^exp
        exp += 1
    end

    arr = []
    for exp in reverse(0:exp)        
        c = maxby(c -> -abs(dec - c*5^exp), -2:2)
        dec -= c*5^exp
        push!(arr, c)
    end
    
    join(replace(arr, 1=>"1", 2=>"2", 0=>"0", -1=>"-", -2=>"="))
end

function main(input="input.txt")
    sum(to_decimal, readlines(input)) |> to_snafu |> println
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end