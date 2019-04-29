local mt = require 'vm.manager'

---@param func function
function mt:callIpairs(func, values, source)
    local tbl = values[1]
    func:setReturn(2, tbl)
end

---@param func function
function mt:callAtIpairs(func, values, source)
    local tbl = values[1]
    if tbl then
        local emmy = tbl:getEmmy()
        if emmy then
            if emmy.type == 'emmy.arrayType' then
                local value = self:createValue(emmy:getName(), source)
                func:setReturn(2, value)
            end
        end
    end
end

---@param func function
function mt:callPairs(func, values, source)
    local tbl = values[1]
    func:setReturn(2, tbl)
end

---@param func function
function mt:callNext(func, values, source)
    local tbl = values[1]
    if tbl then
        local emmy = tbl:getEmmy()
        if emmy then
            if emmy.type == 'emmy.arrayType' then
                local key = self:createValue('integer', self:getDefaultSource())
                local value = self:createValue(emmy:getName(), source)
                func:setReturn(1, key)
                func:setReturn(2, value)
            end
        end
    end
end
