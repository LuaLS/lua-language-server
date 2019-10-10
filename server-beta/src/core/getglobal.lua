local m = {}

function m:def(source, callback)
    local env = source.node
    if env.ref then
        for _, ref in ipairs(env.ref) do
            if ref.type == 'setglobal' then
                callback(ref, 'set')
            elseif ref.type == 'getglobal' then
                self:search(ref, 'special', 'def', callback)
            elseif ref.type == 'getlocal' then
                self:search(ref, '_G', 'def', callback)
            end
        end
    end
end

function m:ref(source, callback)
    local env = source.node
    if env.ref then
        for _, ref in ipairs(env.ref) do
            if ref.type == 'setglobal' then
                callback(ref, 'set')
            elseif ref.type == 'getglobal' then
                callback(ref, 'get')
                self:search(ref, 'special', 'ref', callback)
            elseif ref.type == 'getlocal' then
                self:search(ref, '_G', 'ref', callback)
            end
        end
    end
end

function m:field(source, callback)
    self:search(source, 'getglobal', 'ref', function (src)
        local parent = src.parent
        local tp     = parent.type
        if tp == 'setfield'
        or tp == 'getfield'
        or tp == 'setmethod'
        or tp == 'getmethod'
        or tp == 'setindex'
        or tp == 'getindex' then
            callback(parent)
        end
    end)
end

return m
