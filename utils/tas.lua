function string:split(sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    self:gsub(pattern, function(c)
        fields[#fields+1] = c
    end)
    return fields
end

function array_find(v, fn)
    for i=1,#v,1 do
        if fn(v[i], i, v) == true then
            return i, v[i]
        end
    end
end

function array_map(v, fn)
    local result = {}
    for i=1,#v,1 do
        result[i] = fn(v[i], i, v)
    end
    return result
end

function array_slice(v, start_index, end_index)
    if end_index == nil then
        end_index = #v
    end
    
    local result = {}
    for i=start_index,end_index,1 do
        result[i - start_index] = v[i]
    end
    return result
end

function load_tas_inputs(filename, base)
    if base == nil then
        base = 0
    end
    local f = io.open(filename,'r')
    if f == nil then
        print(string.format("could not open file %s.", filename))
    end
    f:read()
    result = {}
    for i=base,1000000,1 do
        line = f:read()
        if line == nil then
            break
        end
        local inp = {}
        for c in line:gmatch(".") do
            if c == "A" then
                inp["A"] = true
            end
            if c == "B" then
                inp["B"] = true
            end
            if c == "S" then
                inp["select"] = true
            end
            if c == "T" then
                inp["start"] = true
            end
            if c == "U" then
                inp["up"] = true
            end
            if c == "D" then
                inp["down"] = true
            end
            if c == "L" then
                inp["left"] = true
            end
            if c == "R" then
                inp["right"] = true
            end
        end
        result[i] = inp
    end
    result["filename"] = filename
    return result
end

-- for whatever reason we need a numeric value for the tas editor
function tasline_to_value(line)
    local inp = 0
    if line["A"] then
        inp = OR(inp, 1)
    end
    if line["B"] then
        inp = OR(inp, 2)
    end
    if line["select"] then
        inp = OR(inp, 4)
    end
    if line["start"] then
        inp = OR(inp, 8)
    end
    if line["up"] then
        inp = OR(inp, 16)
    end
    if line["down"] then
        inp = OR(inp, 32)
    end
    if line["left"] then
        inp = OR(inp, 64)
    end
    if line["right"] then
        inp = OR(inp, 128)
    end
    return inp
end