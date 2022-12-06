function main(input="input.txt")
    for size in [4, 14]
        processed = []
        for c in split(read(input, String), "")
            if length(Set(processed[max(1, end - size + 1):end])) != size
                push!(processed, c)
            else
                println(length(processed))
                break
            end
        end
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end