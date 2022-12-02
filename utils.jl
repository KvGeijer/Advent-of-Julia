function parse_int_vec(file)
    parse.(Int, readlines(file))
end

# Applies a regex to each line and collects the substrings
function parse_re_lines(file, regex)
    map(readlines(file)) do line
        collect(match(regex, line))
    end
end

# Parses lines according to regex and parses to ints
function parse_int_re_lines(file, regex)
    map(parse_re_lines(file, regex)) do line
        map(line) do cap
            parse(Int, cap)
        end
    end
end

