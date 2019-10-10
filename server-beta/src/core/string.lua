local m = {}

function m:def(source, callback)
    self:asindex(source, 'def', callback)
end

function m:ref(source, callback)
    self:asindex(source, 'ref', callback)
end

return m
