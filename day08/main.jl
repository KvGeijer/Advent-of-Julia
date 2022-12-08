# Copy paste utils into file 
include("utils.jl")


function main(input="input.txt")
    trees = parse_vecvec(file=input, colsep="")
    trees = reduce(hcat, trees)'

    w, h = size(trees)

    vis = Set()

    for row in 1:h
        tallest = -1
        for col in 1:w
            tree = trees[row, col]
            if tree > tallest
                push!(vis, (row, col))
                tallest = tree
            end
        end
        tallest = -1
        for col in reverse(1:w)
            tree = trees[row, col]
            if tree > tallest
                push!(vis, (row, col))
                tallest = tree
            end
        end
    end
    for col in 1:w
        tallest = -1
        for row in 1:h
            tree = trees[row, col]
            if tree > tallest
                push!(vis, (row, col))
                tallest = tree
            end
        end
        tallest = -1
        for row in reverse(1:h)
            tree = trees[row, col]
            if tree > tallest
                tallest = tree
                push!(vis, (row, col))
            end
        end
    end
    println(length(vis))
    

    best = 0
    for col in 1:w
        for row in 1:h
            s1 = 0
            s2 = 0
            s3 = 0
            s4 = 0
            house = trees[row, col]
            rr = row+1
            cc = col
            while 1 <= rr <= h && trees[rr, col] < house
                rr += 1
                s1 += 1
            end
            if !(rr in [0, h+1])
                s1 += 1
            end
            rr = row-1
            cc = col
            while 1 <= rr <= h && trees[rr, col] < house
                rr -= 1
                s2 += 1
            end
            if !(rr in [0, h+1])
                s2 += 1
            end
            rr = row
            cc = col+1
            while 1 <= cc <= w && trees[row, cc] < house
                cc += 1
                s3 += 1
            end
            if !(cc in [0, w+1])
                s3 += 1
            end
            rr = row
            cc = col-1
            while 1 <= cc <= w && trees[row, cc] < house
                cc -= 1
                s4 += 1
            end
            if !(cc in [0, w+1])
                s4 += 1
            end
            s = s1 *s2*s3*s4
            best = max(best, s)
        end
    end
    println(best)

end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end