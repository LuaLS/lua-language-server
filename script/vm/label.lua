local listMgr = require 'vm.list'

local Sort = 0

local mt = {}
mt.__index = mt
mt.type = 'label'

function mt:getName()
    return self.name
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

function mt:getSource()
    return listMgr.get(self.source)
end

return function (name, source)
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
        _info = {},
    }, mt)
    return self
end
