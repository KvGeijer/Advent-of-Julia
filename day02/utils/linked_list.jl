# A linear linked list
abstract type ListNode{T} end

mutable struct Nil{T} <: ListNode{T} end

mutable struct Node{T} <: ListNode{T}
    value:: T
    next:: ListNode{T}
end


mutable struct LinkedList{T}
    head:: ListNode{T}
    tail:: ListNode{T}
end

listnil(T) = Nil{T}() 
linkedlist(T) = LinkedList{T}(listnil(T), listnil(T))
listnode(el, next) = Node{typeof(el)}(el, next)

function add_first!(list:: LinkedList, el)
    prev = list.head
    new = listnode(el, prev)
    list.head = new
    if typeof(prev) <: Nil
        list.tail = new
    end
end

function add_last!(el)
    new = listnode(el, listnil(typeof(el)))
    if typeof(list.head) <: Nil
        list.tail = new
        list.head = new
    else
        list.tail.next = new
        list.tail = new
    end
end

# Make it an iterator
function Base.iterate(list::LinkedList)
    if typeof(list.head) <: Nil
        nothing
    else
        (list.head, list.head.next)
    end
end
Base.iterate(::LinkedList, node::Nil) = nothing
Base.iterate(::LinkedList, node::Node) = (node, node.next)

# Slow length function
function Base.length(list::LinkedList)
    l = 0
    for el in list
        l += 1
    end
    l
end