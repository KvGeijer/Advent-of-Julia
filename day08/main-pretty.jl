# Copy paste utils into file 
include("utils.jl")

function main(input="input.txt")
    trees = parse_mat(file=input, colsep="")
    w, h = size(trees)

    # Part 1
    map(Iterators.product(1:h, 1:w)) do (row, col)
        lowerf = height -> height < trees[row, col] 
        all(lowerf, trees[row, 1:col-1])   || 
        all(lowerf, trees[row, col+1:end]) ||
        all(lowerf, trees[1:row-1, col])   ||
        all(lowerf, trees[row+1:end, col])
    end |> count |> println

    # Part 2
    map(Iterators.product(1:h, 1:w)) do (row, col)
        lowerf = height -> height < trees[row, col] 
        foldlf = ((done, count), stop) -> (done || !stop, !done + count)
        mapfoldlf = range -> mapfoldl(lowerf, foldlf, range, init=(false, 0))
        last.([
            mapfoldlf(trees[row+1:end, col]),
            mapfoldlf(trees[row, col+1:end]),
            mapfoldlf(reverse(trees[row, 1:col-1])),
            mapfoldlf(reverse(trees[1:row-1, col])),
        ]) |> prod
    end |> maximum |> println
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end