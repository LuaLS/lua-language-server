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
