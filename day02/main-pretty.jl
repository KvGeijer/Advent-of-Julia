function main(input="input.txt")
    moves = map(line -> (line[1] - 'A', line[3] - 'X'), readlines(input))

    # Part 1
    rounds1 = map(moves) do (opp, you)
        you + 1 + ((you - opp + 4) % 3) * 3
    end
    println(sum(rounds1))

    # Part 2
    rounds2 = map(moves) do (opp, res)
        (opp + res + 5) % 3 + 1 + res*3
    end
    println(sum(rounds2))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end