local m = {}

function m:def(source, callback)
    if source.tag ~= 'self' then
        callback(source, 'local')
    end
    if source.ref then
        for _, ref in ipairs(source.ref) do
            if ref.type == 'setlocal' then
                callback(ref, 'set')
            end
        end
    end
    if source.tag == 'self' then
        local method = source.method
        local node = method.node
        self:eachRef(node, 'def', callback)
    end
end

function m:ref(source, callback)
    if source.tag ~= 'self' then
        callback(source, 'local')
    end
    if source.ref then
        for _, ref in ipairs(source.ref) do
            if ref.type == 'setlocal' then
                callback(ref, 'set')
            elseif ref.type == 'getlocal' then
                callback(ref, 'get')
            end
        end
    end
    if source.tag == 'self' then
        local method = source.method
        local node = method.node
        self:eachRef(node, 'ref', callback)
    end
end

function m:field(source, callback)
    if source.ref then
        for _, ref in ipairs(source.ref) do
            if ref.type == 'getlocal' then
                local parent = ref.parent
                local tp     = parent.type
                if tp == 'setfield'
                or tp == 'getfield'
                or tp == 'setmethod'
                or tp == 'getmethod'
                or tp == 'setindex'
                or tp == 'getindex' then
                    callback(parent)
                end
            elseif ref.type == 'setlocal' then
                self:eachRef(ref.value, 'field', callback)
            end
        end
    end
    if source.tag == 'self' then
        local method = source.method
        local node = method.node
        self:eachRef(node, 'field', callback)
    end
    if source.value then
        self:eachField(source.value, nil, 'ref', callback)
    end
end

return m
