local mt = require 'vm.manager'

---@param func emmyFunction
---@param values table
function mt:callEmmySpecial(func, values)
    local emmyParams = func:getEmmyParams()
    for index, param in ipairs(emmyParams) do
        local option = param:getOption()
        if option and type(option.special) == 'string' then
            self:checkEmmyParam(func, values, index, option.special)
        end
    end
end

---@param func emmyFunction
---@param values table
---@param index integer
---@param special string
function mt:checkEmmyParam(func, values, index, special)
    if special == 'dofile:1' then
        self:callEmmyDoFile(func, values, index)
    end
end

---@param func emmyFunction
---@param values table
---@param index integer
function mt:callEmmyDoFile(func, values, index)
    if not values[index] then
        values[index] = self:createValue('any', self:getDefaultSource())
    end
    local str = values[index]:getLiteral()
    if type(str) ~= 'string' then
        return
    end
    local requireValue = self:tryRequireOne(values[index], 'dofile')
    if not requireValue then
        requireValue = self:createValue('any', self:getDefaultSource())
        requireValue.isRequire = true
    end
    func:setReturn(1, requireValue)
end
