local listMgr = require 'vm.list'

local Sort = 0
local Watch = setmetatable({}, {__mode = 'kv'})

---@class Local
local mt = {}
mt.__index = mt
mt.type = 'local'
mt._close = math.maxinteger

function mt:setValue(value)
    if not value then
        return
    end
    if self.value then
        --self.value:mergeValue(value)
        self.value:mergeType(value)
        self.value = value
    else
        self.value = value
    end
    if self._emmy then
        self.value:setEmmy(self._emmy)
    end
    return value
end

function mt:getValue()
    return self.value
end

function mt:addInfo(tp, source)
    if not source then
        error('No source')
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
    }

    self._info[id] = info
end

function mt:eachInfo(callback)
    local list = {}
    for srcId, info in pairs(self._info) do
        local src = listMgr.get(srcId)
        if src then
            list[#list+1] = info
        else
            self._info[srcId] = nil
        end
    end
    table.sort(list, function (a, b)
        return a._sort < b._sort
    end)
    for i = 1, #list do
        local info = list[i]
        local res = callback(info, listMgr.get(info.source))
        if res ~= nil then
            return res
        end
    end
    return nil
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

function mt:getName()
    return self.name
end

function mt:shadow(old)
    if not old then
        if not self._shadow then
            return nil
        end
        for i = #self._shadow, 1, -1 do
            local loc = self._shadow[i]
            if not loc:getSource() then
                table.remove(self._shadow, i)
            end
        end
        return self._shadow
    end
    local group = old._shadow
    if not group then
        group = {}
        group[#group+1] = old
    end
    group[#group+1] = self
    self._shadow = group

    if not self:getSource() then
        log.error('local no source')
        return
    end

    old:close(self:getSource().start - 1)
end

function mt:close(pos)
    if pos then
        if pos <= 0 then
            pos = math.maxinteger
        end
        self._close = pos
    else
        return self._close
    end
end

function mt:getSource()
    return listMgr.get(self.source)
end

local EMMY_TYPE = {
    ['emmy.class']        = true,
    ['emmy.type']         = true,
    ['emmy.arrayType']    = true,
    ['emmy.tableType']    = true,
    ['emmy.functionType'] = true,
}

function mt:setEmmy(emmy)
    if not emmy then
        return
    end
    if self.value and EMMY_TYPE[emmy.type] then
        self.value:setEmmy(emmy)
    end
end

---@param comment string
function mt:setComment(comment)
    self._comment = comment
end

---@return string
function mt:getComment()
    return self._comment
end

local function create(name, source, value, tags)
    if not value then
        error('Local must has a value')
    end
    if not source then
        error('No source')
    end
    local id = source.id
    if not id then
        error('Not instanted source')
    end
    local self = setmetatable({
        name = name,
        source = id,
        value = value,
        tags = tags,
        _info = {},
    }, mt)
    Watch[self] = true
    return self
end

return {
    create = create,
    watch = Watch,
}
