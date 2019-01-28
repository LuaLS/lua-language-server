local DefaultSource = { start = 0, finish = 0 }

local mt = {}
mt.__index = mt
mt.type = 'value'

function mt:setValue(value)
    self._value = value
end

function mt:getValue()
    return self._value
end

function mt:inference(tp, rate)
    if tp == '...' then
        error('Value type cant be ...')
    end
    if not tp or tp == 'any' then
        return
    end
    if not self._type then
        self._type = {}
    end
    if not self._type[tp] or rate > self._type[tp] then
        self._type[tp] = rate
    end
end

function mt:getType()
    if not self._type then
        return 'nil'
    end
    local mRate = 0.0
    local mType
    for tp, rate in pairs(self._type) do
        if rate > mRate then
            mRate = rate
            mType = tp
        end
    end
    return mType or 'any'
end

function mt:setMetaTable(metatable, source)
    if not self._meta then
        self._meta = {}
    end
    local uri = source and source.uri or ''
    self._meta[uri] = metatable
end

function mt:createField(name, source)
    local field = {
        type   = 'field',
        key    = name,
        source = source or DefaultSource,
    }

    if not self._child then
        self._child = {}
    end
    local uri = source and source.uri or ''
    if not self._child[uri] then
        self._child[uri] = {}
    end
    self._child[uri][name] = field

    self:inference('table', 0.5)

    return field
end

function mt:rawGetField(name, source)
    local uri = source and source.uri or ''
    if not self._child then
        return nil
    end
    if self._child[uri] then
        local field = self._child[uri][name]
        if field then
            return field
        end
    end
    for _, childs in pairs(self._child) do
        local field = childs[name]
        if field then
            return field
        end
    end
    return nil
end

function mt:_getMeta(name, source)
    if not self._meta then
        return nil
    end
    local uri = source and source.uri or ''
    if self._meta[uri] then
        local meta = self._meta[uri]:rawGetField(name, source)
        if meta then
            return meta
        end
    end
    for _, indexValue in pairs(self._meta) do
        local meta = indexValue:rawGetField(name, source)
        if meta then
            return meta
        end
    end
    return nil
end

function mt:getChild()
    if not self._child then
        self._child = {}
    end
    return self._child
end

function mt:setChild(child)
    self._child = child
end

function mt:getField(name, source, stack)
    local field = self:rawGetField(name, source)
    if not field then
        local indexMeta = self:_getMeta('__index', source)
        if not indexMeta then
            return nil
        end
        if not stack then
            stack = 0
        end
        stack = stack + 1
        if stack > 10 then
            return nil
        end
        return indexMeta.value:getField(name, source, stack)
    end
    return field
end

function mt:eachField(callback)
    if not self._child then
        return
    end
    local mark = {}
    for _, childs in pairs(self._child) do
        for name, field in pairs(childs) do
            if not mark[name] then
                mark[name] = true
                callback(name, field)
            end
        end
    end
end

function mt:getDeclarat()
    return self:eachInfo(function (info)
        if info.type == 'local'
        or info.type == 'set'
        or info.type == 'return'
        then
            return info.source
        end
    end)
end

function mt:addInfo(tp, source, var)
    if source and not source.start then
        error('Miss start: ' .. table.dump(source))
    end
    if not self._info then
        self._info = {}
    end
    local uri = source and source.uri or ''
    if not self._info[uri] then
        self._info[uri] = {}
    end
    self._info[uri][#self._info[uri]+1] = {
        type = tp,
        source = source or DefaultSource,
        var = var,
    }
    return self
end

function mt:eachInfo(callback)
    if not self._info then
        return nil
    end
    for _, infos in pairs(self._info) do
        for i = 1, #infos do
            local res = callback(infos[i])
            if res ~= nil then
                return res
            end
        end
    end
    return nil
end

return function (tp, source, value)
    if tp == '...' then
        error('Value type cant be ...')
    end
    -- TODO lib里的多类型
    local self = setmetatable({
        source = source or DefaultSource,
    }, mt)
    if value ~= nil then
        self:setValue(value)
    end
    if type(tp) == 'table' then
        for i = 1, #tp do
            self:inference(tp[i], 0.9)
        end
    else
        self:inference(tp, 1.0)
    end
    return self
end
