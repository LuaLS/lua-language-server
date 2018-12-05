local mt = {}
setmetatable(_G, mt)

function mt:__index(k)
    error(('Read undefined global: [%s]'):format(k), 2)
end

function mt:__newindex(k, v)
    error(('Save global: [%s] = [%s]'):format(k, v), 2)
end
