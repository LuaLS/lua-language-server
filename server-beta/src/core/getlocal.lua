local m = {}

function m:def(source, callback)
    self:search(source.loc, 'local', 'def', callback)
end

function m:ref(source, callback)
    self:search(source.loc, 'local', 'ref', callback)
end

function m:field(source, callback)
    self:search(source.loc, 'local', 'field', callback)
end

return m
