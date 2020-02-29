local libraryBuilder = require 'vm.library'
local library = require 'core.library'
local listMgr = require 'vm.list'
local config = require 'config'

local Sort = 0
local Watch = setmetatable({}, {__mode = 'kv'})
local TypeLevel = {
    ['table']    = 1.0,
    ['function'] = 0.9,
    ['string']   = 0.8,
    ['integer']  = 0.7,
    ['number']   = 0.6,
}

---@class value
local mt = {}
mt.__index = mt
mt.type = 'value'
mt.uri = ''
mt._global = false

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
    Watch[self] = true
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
    if tp == 'integer' then
        local version = config.config.runtime.version
        if version ~= 'Lua 5.3' and version ~= 'Lua 5.4' then
            tp = 'number'
        end
    end
    local current = self._type[tp] or 0.0
    if rate > current then
        self._type[tp] = rate
    end
end

function mt:getType()
    if self:getEmmy() then
        return self:getEmmy():getType(), 1.0
    end
    if not self._type then
        return 'nil', 0.0
    end
    local mRate = 0.0
    local mType
    for tp, rate in pairs(self._type) do
        if rate > mRate then
            mRate = rate
            mType = tp
        elseif rate == mRate then
            local level1 = TypeLevel[tp] or 0.0
            local level2 = TypeLevel[mType] or 0.0
            if level1 > level2 then
                mRate = rate
                mType = tp
            end
        end
    end
    return mType or 'any', mRate
end

function mt:rawSet(index, value, source)
    if index == nil then
        return
    end
    if not self._child then
        self._child = {}
    end
    if self._child[index] then
        if self._global then
            self._child[index]:mergeValue(value)
        else
            self._child[index]:mergeType(value)
            self._child[index]:mergeInfo(value)
        end
        self._child[index] = value
    else
        self._child[index] = value
    end
    self:addInfo('set child', source, index, self._child[index])
    if self._global then
        self._child[index]:markGlobal()
    end
end

function mt:rawGet(index)
    if not self._child then
        return nil
    end
    self:flushChild()
    local child = self._child[index]
    if not child then
        return nil
    end
    return child
end

function mt:setChild(index, value, source)
    if index == nil then
        return
    end
    self:setType('table', 0.5)
    self:rawSet(index, value, source)
    return value
end

function mt:getLibChild(index)
    local tp = self:getType()
    local lib = library.object[tp]
    if lib then
        local childs = libraryBuilder.child(lib)
        return childs[index]
    end
    return nil
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

function mt:getChild(index, source)
    self:setType('table', 0.5)
    local parent = self
    local value
    -- 最多检查3层 __index
    for _ = 1, 3 do
        value = parent:rawGet(index)
        if value then
            break
        end
        local method = parent:getMetaMethod('__index')
        if not method then
            value = parent:getLibChild(index)
            break
        end
        parent = method
    end
    if not value and source then
        local emmy = self:getEmmy()
        if emmy then
            if emmy.type == 'emmy.arrayType' then
                if type(index) == 'number' then
                    value = create(emmy:getName(), source)
                end
            elseif emmy.type == 'emmy.tableType' then
                value = create(emmy:getValueType():getType(), source)
            end
        end
        if not value then
            value = create('any', source)
        end
        self:setChild(index, value)
        value.uri = self.uri
    end
    return value
end

function mt:setMetaTable(metatable)
    local source = metatable:getSource()
    if not source then
        return
    end
    source:bindMetatable(metatable)
    self._meta = metatable.source
end

function mt:getMetaTable()
    if not self._meta then
        return nil
    end
    local metaSource = listMgr.get(self._meta)
    if not metaSource then
        self._meta = nil
        return nil
    end
    return metaSource:bindMetatable()
end

function mt:getMetaMethod(name)
    local meta = self:getMetaTable()
    if not meta then
        return nil
    end
    return meta:rawGet(name)
end

function mt:flushChild()
    if not self._child then
        return nil
    end
    -- 非全局值不会出现dead child
    if not self._global then
        return
    end
    local listVersion = listMgr.getVersion()
    if self._flushVersion == listVersion then
        return
    end
    self._flushVersion = listVersion
    local alived = {}
    local infos = self._info
    local count = 0
    for srcId, info in pairs(infos) do
        local src = listMgr.get(srcId)
        if  src then
            if info.type == 'set child' or info.type == 'get child' then
                if info[1] then
                    alived[info[1]] = true
                end
            end
            count = count + 1
        else
            infos[srcId] = nil
        end
    end
    infos._count = count
    infos._limit = count * 1.1 + 10
    infos._version = listMgr.getVersion()
    for index in pairs(self._child) do
        if not alived[index] then
            self._child[index] = nil
        end
    end
end

function mt:rawEach(callback, mark)
    if not self._child then
        return nil
    end
    self:flushChild()
    for index, value in pairs(self._child) do
        if mark then
            if mark[index] then
                goto CONTINUE
            end
            mark[index] = true
        end
        local res = callback(index, value)
        if res ~= nil then
            return res
        end
        ::CONTINUE::
    end
    return nil
end

function mt:eachChild(callback)
    local mark = {}
    local parent = self
    -- 最多检查3层 __index
    for _ = 1, 3 do
        local res = parent:rawEach(callback, mark)
        if res ~= nil then
            return res
        end
        local method = parent:getMetaMethod('__index')
        if not method then
            return parent:eachLibChild(callback)
        end
        parent = method
    end
end

function mt:mergeType(value)
    if self == value then
        return
    end
    if not value then
        return
    end
    if self._emmy and not value._emmy then
        value._emmy = self._emmy
        return
    elseif not self._emmy and value._emmy then
        self._emmy = value._emmy
        return
    end
    if value._type then
        for tp, rate in pairs(value._type) do
            self:setType(tp, rate)
        end
    end
    value._type = self._type
end

function mt:mergeInfo(value)
    if self == value then
        return
    end
    if not value then
        return
    end
    local infos = self._info
    for srcId, info in pairs(value._info) do
        local src = listMgr.get(srcId)
        if src and not infos[srcId] then
            infos[srcId] = info
            infos._count = (infos._count or 0) + 1
        end
    end
    value._info = infos
end

function mt:mergeValue(value)
    if self == value then
        return
    end
    if not value then
        return
    end
    local list = {self, value}
    local pos = 1
    while true do
        local a, b = list[pos], list[pos+1]
        if not a then
            break
        end
        pos = pos + 2
        list[a] = true
        list[b] = true
        a:mergeType(b)
        a:mergeInfo(b)

        a:flushChild()
        b:flushChild()
        local global = a._global or b._global
        if b._child then
            if not a._child then
                a._child = {}
            end
            for k, bc in pairs(b._child) do
                local ac = a._child[k]
                if ac and ac ~= bc and global then
                    if list[ac] and list[bc] then
                    else
                        list[#list+1] = ac
                        list[#list+1] = bc
                    end
                end
                a._child[k] = bc
            end
        end
        b._child = a._child
        if global then
            a:markGlobal()
            b:markGlobal()
        end

        if b._meta then
            a._meta = b._meta
        end
        if b._func then
            a._func = b._func
        end
        if b._lib then
            a._lib = b._lib
        end
        if b.uri then
            a.uri = b.uri
        end
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
    if not tp then
        error('Miss info type')
    end

    local infos = self._info
    if infos[id] then
        return
    end
    Sort = Sort + 1
    local info = {
        type = tp,
        source = id,
        _sort = Sort,
        ...
    }
    infos[id] = info
    infos._count = (infos._count or 0) + 1
    local version = listMgr.getVersion()
    -- 只有全局值需要压缩info
    if self._global and infos._count > (infos._limit or 10) and infos._version ~= version then
        local count = 0
        for srcId in pairs(infos) do
            local src = listMgr.get(srcId)
            if src then
                count = count + 1
            else
                infos[srcId] = nil
            end
        end
        infos._count = count
        infos._limit = count * 1.1 + 10
        infos._version = version
    end
end

function mt:eachInfo(callback)
    local clock = os.clock()
    local infos = self._info
    local list = {}
    for srcId, info in pairs(infos) do
        local src = listMgr.get(srcId)
        if src then
            list[#list+1] = info
        else
            infos[srcId] = nil
        end
    end
    infos._count = #list
    infos._limit = infos._count * 1.1 + 10
    infos._version = listMgr.getVersion()
    --local clock2 = os.clock()
    --table.sort(list, function (a, b)
    --    return a._sort < b._sort
    --end)
    local passed = os.clock() - clock
    if passed > 0.1 then
        log.warn(('eachInfo takes: [%.3f]sec, #list: %d'):format(passed, #list))
    end
    for i = 1, #list do
        local info = list[i]
        local res = callback(info, listMgr.get(info.source))
        if res ~= nil then
            return res
        end
    end
    return nil
end

function mt:setFunction(func)
    self._func = func.id
    if self._global then
        func:markGlobal()
    end
end

function mt:getFunction()
    local id = self._func
    local func = listMgr.get(id)
    if not func then
        return nil
    end
    if func._removed then
        return nil
    end
    if not func:getSource() then
        func = nil
        listMgr.clear(id)
    end
    return func
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
    return listMgr.get(self.source)
end

function mt:markGlobal()
    if self._global then
        return
    end
    self._global = true
    self:rawEach(function (index, value)
        value:markGlobal()
    end)
    local func = self:getFunction()
    if func then
        func:markGlobal()
    end
end

function mt:isGlobal()
    return self._global
end

function mt:setEmmy(emmy)
    if not emmy then
        return
    end
    if emmy.type == 'emmy.class' then
        ---@type EmmyClass
        local emmyClass = emmy
        emmyClass:setValue(self)
        emmyClass:eachChild(function (obj)
            local value = obj:getValue()
            if value then
                value:mergeValue(self)
            end
        end)
        emmyClass:eachField(function (field)
            local name = field:getName()
            local value = field:bindValue()
            self:setChild(name, value, field:getSource())
        end)
    elseif emmy.type == 'emmy.type' then
        ---@type EmmyType
        local emmyType = emmy
        emmyType:setValue(self)
        emmyType:eachClass(function (class)
            if class then
                self:mergeValue(class:getValue())
            end
        end)
    elseif emmy.type == 'emmy.arrayType' then
        ---@type EmmyArrayType
        local emmyArrayType = emmy
        emmyArrayType:setValue(self)
    elseif emmy.type == 'emmy.tableType' then
        ---@type EmmyTableType
        local emmyTableType = emmy
        emmyTableType:setValue(self)
    elseif emmy.type == 'emmy.functionType' then
        ---@type EmmyFunctionType
        local emmyFuncType = emmy
        emmyFuncType:setValue(self)
        self:setFunction(emmyFuncType:bindFunction())
    else
        return
    end
    self._emmy = emmy
    self:markGlobal()
end

function mt:getEmmy()
    if not self._emmy then
        return nil
    end
    local source = self._emmy.source
    if not listMgr.get(source) then
        self._emmy = nil
        return nil
    end
    return self._emmy
end

function mt:setComment(comment)
    self._comment = comment
end

function mt:getComment(comment)
    return self._comment
end

return {
    create = create,
    watch = Watch,
}
