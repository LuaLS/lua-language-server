local mt = require 'vm.manager'
local library = require 'vm.library'

---@param func emmyFunction
function mt:callIpairs(func, values, source)
    local tbl = values[1]
    func:setReturn(1, library.special['@ipairs'])
    func:setReturn(2, tbl)
end

---@param func emmyFunction
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

---@param func emmyFunction
function mt:callPairs(func, values, source)
    local tbl = values[1]
    func:setReturn(1, library.special['next'])
    func:setReturn(2, tbl)
end

---@param func emmyFunction
function mt:callNext(func, values, source)
    local tbl = values[1]
    if tbl then
        local emmy = tbl:getEmmy()
        if emmy then
            if emmy.type == 'emmy.arrayType' then
                local key = self:createValue('integer', source)
                local value = self:createValue(emmy:getName(), source)
                func:setReturn(1, key)
                func:setReturn(2, value)
            elseif emmy.type == 'emmy.tableType' then
                local key = self:createValue(emmy:getKeyType():getType(), source)
                local value = self:createValue(emmy:getValueType():getType(), source)
                func:setReturn(1, key)
                func:setReturn(2, value)
            end
        end
    end
end
