function main(input="input.txt")
    moves = split.(readlines(input))
    total1 = 0

    # Part 1
    for (opp, you) in moves
        opp = opp[1] - 'A' + 1
        you = you[1] - 'X' + 1

        total1 += you
        total1 += ((you - opp + 4) % 3) * 3
    end
    println(total1)

    # Part 2
    total2 = 0 
    for (opp, res) in moves
        opp = opp[1] - 'A'
        res = res[1] - 'X'
        you = (opp + res + 5) % 3 + 1
        
        total2 += you
        total2 += res*3
    end
    println(total2)
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end