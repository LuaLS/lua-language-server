local function getDefaultSource()
    return {
        start = 0,
        finish = 0,
        uri = '',
    }
end

local mt = {}
mt.__index = mt
mt.type = 'value'

function mt:setValue(value)
    self._value = value
end

function mt:getValue()
    return self._value
end

function mt:setType(tp, rate)
    if type(tp) == 'table' then
        for _, ctp in ipairs(tp) do
            self:inference(ctp, rate)
        end
        return
    end
    if tp == '...' then
        error('Value type cant be ...')
    end
    if not tp then
        tp = 'nil'
    end
    if tp == 'any' or tp == 'nil' then
        rate = 0.0
    end
    if not self._type then
        self._type = {}
    end
    local current = self._type[tp] or 0.0
    self._type[tp] = current + (1 - current) * rate
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

function mt:rawSet(index, value)
    if not self._child then
        self._child = {}
    end
    if self._child[index] then
        self._child[index]:mergeValue(value)
    else
        self._child[index] = value
    end
end

function mt:rawGet(index)
    if not self._child then
        return nil
    end
    return self._child[index]
end

function mt:setChild(index, value)
    self:rawSet(index, value)
end

function mt:getChild(index, mark)
    local value = self:rawGet(index)
    if value then
        return value
    end
    local method = self:getMetaMethod('__index')
    if not method then
        return nil
    end
    if not mark then
        mark = {}
    end
    if mark[method] then
        return nil
    end
    mark[method] = true
    return method:getChild(index, mark)
end

function mt:setMetaTable(metatable)
    self._meta = metatable
end

function mt:getMetaTable()
    return self._meta
end

function mt:getMetaMethod(name)
    local meta = self:getMetaTable()
    if not meta then
        return nil
    end
    return meta:rawGet(name)
end

function mt:rawEach(callback, foundIndex)
    if not self._child then
        return nil
    end
    for index, value in pairs(self._child) do
        if foundIndex then
            if foundIndex[index] then
                goto CONTINUE
            end
            foundIndex[index] = true
        end
        local res = callback(index, value)
        if res ~= nil then
            return res
        end
        ::CONTINUE::
    end
    return nil
end

function mt:eachChild(callback, mark, foundIndex)
    if not foundIndex then
        foundIndex = {}
    end
    local res = self:rawEach(callback, foundIndex)
    if res ~= nil then
        return res
    end
    local method = self:getMetaMethod('__index')
    if not method then
        return nil
    end
    if not mark then
        mark = {}
    end
    if mark[method] then
        return nil
    end
    mark[method] = true
    return method:eachChild(callback, mark, foundIndex)
end

function mt:mergeValue(value)
    if value._type then
        for tp, rate in pairs(value._type) do
            self:setType(tp, rate)
        end
    end
    if value._child then
        if not self._child then
            self._child = {}
        end
        for k, v in pairs(value._child) do
            self._child[k] = v
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
    self._info[#self._info+1] = {
        type = tp,
        source = source or getDefaultSource(),
    }
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

return function (tp, source, v)
    if tp == '...' then
        error('Value type cant be ...')
    end
    -- TODO lib里的多类型
    local self = setmetatable({
        source = source or getDefaultSource(),
        _value = v,
    }, mt)
    if type(tp) == 'table' then
        for i = 1, #tp do
            self:setType(tp[i], 1.0 / #tp)
        end
    else
        self:setType(tp, 1.0)
    end
    return self
end
