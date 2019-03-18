local libraryBuilder = require 'vm.library'
local library = require 'core.library'
local sourceMgr = require 'vm.source'

local Sort = 0

local mt = {}
mt.__index = mt
mt.type = 'value'
mt.uri = ''
mt._infoCount = 0
mt._infoLimit = 10

local function create (tp, source, literal)
    if tp == '...' then
        error('Value type cant be ...')
    end
    if not source then
        error('No source')
    end
    local id = source.id
    if not id then
        error('Not instanted source')
    end
    local self = setmetatable({
        source = id,
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

local function isDeadChild(value, index)
    local child = value._child[index]
    if not child:getSource() then
        return true
    end
    for srcId, info in pairs(value._info) do
        local src = sourceMgr.list[srcId]
        if  src
            and (info.type == 'set child' or info.type == 'get child')
            and info[1] == index
        then
            return false
        end
    end
    return true
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
    local child = self._child[index]
    if not child then
        return nil
    end
    if isDeadChild(self, index) then
        self._child[index] = nil
        return nil
    end
    return child
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

local function finishGetChild(self, index, source, mark)
    self:setType('table', 0.5)
    local value = self:rawGet(index)
    if value then
        return value
    end
    local method = self:getMetaMethod('__index')
    if not method then
        local v = self:getLibChild(index)
        return v
    end
    if not mark then
        mark = {}
    end
    if mark[method] then
        return nil
    end
    mark[method] = true

    return finishGetChild(method, index, source, mark)
end

function mt:getChild(index, source)
    local value = finishGetChild(self, index)
    if not value then
        value = create('any', source)
        self:setChild(index, value)
        value.uri = self.uri
    end
    return value
end

function mt:bindChild(other)
    self._child = other._child
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
        if isDeadChild(self, index) then
            self._child[index] = nil
            goto CONTINUE
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

    for srcId, info in pairs(value._info) do
        local src = sourceMgr.list[srcId]
        if src then
            self._infoCount = self._infoCount + 1
            self._info[srcId] = info
        else
            value._info[srcId] = nil
            value._infoCount = value._infoCount - 1
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
    if not source then
        return
    end
    if not source.start then
        error('Miss start: ' .. table.dump(source))
    end
    local id = source.id
    if not id then
        error('Not instanted source')
    end
    if self._info[id] then
        return
    end
    Sort = Sort + 1
    local info = {
        type = tp,
        source = id,
        _sort = Sort,
        ...
    }
    self._info[id] = info
    self._infoCount = self._infoCount + 1

    if self._infoCount > self._infoLimit then
        for srcId in pairs(self._info) do
            local src = sourceMgr.list[srcId]
            if not src then
                self._info[srcId] = nil
                self._infoCount = self._infoCount - 1
            end
        end
        self._infoLimit = self._infoCount * 2
        if self._infoLimit < 10 then
            self._infoLimit = 10
        end
    end
end

function mt:eachInfo(callback)
    local list = {}
    for srcId, info in pairs(self._info) do
        local src = sourceMgr.list[srcId]
        if src then
            list[#list+1] = info
        else
            self._info[srcId] = nil
            self._infoCount = self._infoCount - 1
        end
    end
    table.sort(list, function (a, b)
        return a._sort < b._sort
    end)
    for i = 1, #list do
        local info = list[i]
        local res = callback(info, sourceMgr.list[info.source])
        if res ~= nil then
            return res
        end
    end
    return nil
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

function mt:getSource()
    return sourceMgr.list[self.source]
end

return create
