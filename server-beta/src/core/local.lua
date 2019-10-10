local guide = require 'parser.guide'

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

function m:field(source, key, callback)
    if source.ref then
        for _, ref in ipairs(source.ref) do
            if ref.type == 'getlocal' then
                local parent = ref.parent
                if key == guide.getKeyName(parent) then
                    local tp     = parent.type
                    if     tp == 'setfield'
                    or     tp == 'setmethod'
                    or     tp == 'setindex' then
                        callback(parent, 'set')
                    elseif tp == 'getfield'
                    or     tp == 'getmethod'
                    or     tp == 'getindex' then
                        callback(parent, 'get')
                    end
                end
            elseif ref.type == 'setlocal' then
                self:eachRef(ref.value, 'field', callback)
            elseif ref.type == 'getglobal' then
                -- _ENV.XXX
                if key == guide.getKeyName(ref) then
                    callback(ref, 'get')
                end
            elseif ref.type == 'setglobal' then
                -- _ENV.XXX = XXX
                if key == guide.getKeyName(ref) then
                    callback(ref, 'set')
                end
            end
        end
    end
    --if source.tag == 'self' then
    --    local method = source.method
    --    local node = method.node
    --    self:eachRef(node, 'field', callback)
    --end
    --if source.value then
    --    self:eachField(source.value, nil, 'ref', callback)
    --end
end

return m
