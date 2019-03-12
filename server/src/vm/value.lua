local libraryBuilder = require 'vm.library'
local library = require 'core.library'

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
mt.uri = ''

local function create (tp, source, literal)
    if tp == '...' then
        error('Value type cant be ...')
    end
    local self = setmetatable({
        source = source or getDefaultSource(),
        _type = {},
        _literal = literal,
        _info = {},
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

function mt:setType(tp, rate)
    if type(tp) == 'table' then
        for _, ctp in ipairs(tp) do
            self:setType(ctp, rate)
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
    self:setType('table', 0.5)
    self:rawSet(index, value)
    return value
end

function mt:getLibChild(index)
    local tp = self:getType()
    local lib = library.object[tp]
    if lib then
        local childs = libraryBuilder.child(lib)
        return childs[index]
    end
end

function mt:eachLibChild(callback)
    local tp = self:getType()
    local lib = library.object[tp]
    if lib then
        local childs = libraryBuilder.child(lib)
        for k, v in pairs(childs) do
            callback(k, v)
        end
    end
end

function mt:getChild(index, source, mark)
    self:setType('table', 0.5)
    local value = self:rawGet(index)
    if value then
        return value
    end
    local method = self:getMetaMethod('__index')
    if not method then
        local v = self:getLibChild(index)
        if v then
            return v
        end
        v = create('any', source)
        self:setChild(index, v)
        v.uri = self.uri
        return v
    end
    if not mark then
        mark = {}
    end
    if mark[method] then
        local v = create('any', source)
        self:setChild(index, v)
        v.uri = self.uri
        return v
    end
    mark[method] = true
    return method:getChild(index, source, mark)
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
        return self:eachLibChild(callback)
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
    if self == value then
        return
    end
    if value._type then
        for tp, rate in pairs(value._type) do
            self:setType(tp, rate)
        end
    end
    value._type = self._type
    if value._child then
        if not self._child then
            self._child = {}
        end
        for k, v in pairs(value._child) do
            self._child[k] = v
        end
    end
    for _, info in ipairs(value._info) do
        if not self._info[info.source] then
            self._info[#self._info+1] = info
            self._info[info.source] = true

            info.source:subscribe(self)
        end
    end
    if value._meta then
        self._meta = value._meta
    end
    if value._func then
        self._func = value._func
    end
    if value._lib then
        self._lib = value._lib
    end
    if value.uri then
        self.uri = value.uri
    end
end

function mt:addInfo(tp, source, ...)
    if source and not source.start then
        error('Miss start: ' .. table.dump(source))
    end
    if self._info[source] then
        return
    end
    if not source or not source.subscribe then
        return
    end
    local info = {
        type = tp,
        source = source,
        ...
    }
    self._info[#self._info+1] = info
    self._info[info.source] = true

    source:subscribe(self)
end

function mt:eachInfo(callback)
    for _, info in ipairs(self._info) do
        local res = callback(info)
        if res ~= nil then
            return res
        end
    end
    return nil
end

function mt:cleanInfo()
    for i = #self._info, 1, -1 do
        local info = self._info[i]
        local source = info.source
        if source:isRemoved() then
            self._info[source] = nil
            table.remove(self._info, i)
        end
    end
end

function mt:setFunction(func)
    self._func = func
end

function mt:getFunction()
    return self._func
end

function mt:setLib(lib)
    self._lib = lib
end

function mt:getLib()
    return self._lib
end

function mt:getLiteral()
    return self._literal
end

function mt:set(name, v)
    if not self._flag then
        self._flag = {}
    end
    self._flag[name] = v
end

function mt:get(name)
    if not self._flag then
        return nil
    end
    return self._flag[name]
end

return create
