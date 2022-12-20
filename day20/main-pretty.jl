# Copy paste utils into file 
include("utils.jl")

mutable struct Node
    next :: Node
    prev :: Node
    nbr :: Int
    Node() = new()
end

function simulate(permutations, times)
    # Create the nodes without linking them
    node_arr = []
    for nbr in permutations
        node = Node()
        node.nbr = nbr
        push!(node_arr, node)
    end

    # Create all node links
    modl = length(node_arr)
    for ind in 1:length(node_arr)
        next = ind == modl ? 1 : ind + 1
        prev = ind == 1 ? modl : ind - 1

        node_arr[ind].next = node_arr[next] 
        node_arr[ind].prev = node_arr[prev] 
    end

    for _ in 1:times
        for (id, nbr) in enumerate(permutations)
            node = node_arr[id]

            # modl - 1, beacause the list is now 1 shorter while the node is gone
            to_move = nbr % (modl-1)
            to_move = (to_move + (modl-1)) % (modl-1)

            # Remove it from the linkage
            node.prev.next = node.next
            node.next.prev = node.prev
            
            # Find the next position
            current = node.prev
            for _ in 1:to_move
                current = current.next
            end

            # Re link the stuff
            node.prev = current
            node.next = current.next
            current.next = node
            node.next.prev = node
        end
    end

    zero_ind = findfirst(==(0), permutations)
    current = node_arr[zero_ind]
    res = 0
    for _ in 1:3
        for _ in 1:1000
            current = current.next
        end
        res += current.nbr
    end  
    res
end

function main(input="input.txt")   
    permutations = first.(parse_vecvec(input))

    simulate(permutations, 1) |> println

    key = 811589153
    simulate(permutations.*key, 10) |> println
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end