local m = {}

function m:def(source, callback)
    self:asIndex(source, 'def', callback)
end

function m:ref(source, callback)
    self:asIndex(source, 'ref', callback)
end

return m
