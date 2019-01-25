local DefaultSource = { start = 0, finish = 0 }

local mt = {}
mt.__index = mt
mt.type = 'value'
mt._type = 'any'

function mt:setValue(source, value)
    self._value = value
end

function mt:getValue()
    return self._value
end

function mt:inference(tp)
    if tp == '...' then
        error('Value type cant be ...')
    end
    if self._type == 'any' and tp ~= 'nil' then
        self._type = tp
    end
end

function mt:getType()
    return self._type
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

    self:inference('table')

    return field
end

function mt:rawGetField(name, source)
    local uri = source and source.uri or ''
    local field
    if self._child then
        if self._child[uri] then
            field = self._child[uri][name]
        end
        if not field then
            for _, childs in pairs(self._child) do
                field = childs[name]
                if field then
                    break
                end
            end
        end
    end
    return field
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

function mt:getField(name, source)
    local field = self:rawGetField(name, source)
    if not field then
        field = self:createField(name, source)
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

function mt:addInfo(tp, source)
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
    }
    return self
end

function mt:eachInfo(callback)
    if not self._info then
        return
    end
    for _, infos in pairs(self._info) do
        for i = 1, #infos do
            callback(infos[i])
        end
    end
end

return function (tp, source, value)
    if tp == '...' then
        error('Value type cant be ...')
    end
    -- TODO lib里的多类型
    if type(tp) == 'table' then
        tp = tp[1]
    end
    local self = setmetatable({
        source = source or DefaultSource,
        _type = tp,
    }, mt)
    if value ~= nil then
        self:setValue(source, value)
    end
    return self
end
