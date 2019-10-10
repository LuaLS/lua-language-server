local m = {}

function m:def(source, callback)
    local parent = source.parent
    if parent.type == 'setfield'
    or parent.type == 'setindex'
    or parent.type == 'setmethod' then
        callback(parent, 'set')
    elseif parent.type == 'getfield'
    or     parent.type == 'getindex' then
        self:search(parent, 'special', 'def', callback)
    elseif parent.type == 'callargs' then
        self:search(parent.parent, 'special', 'def', callback)
    end
end

function m:ref(source, callback)
    local parent = source.parent
    if parent.type == 'setfield'
    or parent.type == 'setindex'
    or parent.type == 'setmethod' then
        callback(parent, 'set')
    elseif parent.type == 'getfield'
    or     parent.type == 'getindex'
    or     parent.type == 'getmethod' then
        callback(parent, 'get')
    elseif parent.type == 'getfield' then
        self:search(parent, 'special', 'ref', callback)
    elseif parent.type == 'callargs' then
        self:search(parent.parent, 'special', 'ref', callback)
    end
end

return m
