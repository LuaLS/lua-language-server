local mt             = require 'vm.manager'
local multi          = require 'vm.multi'
local library        = require 'core.library'
local libraryBuilder = require 'vm.library'
local plugin         = require 'plugin'

---@param func emmyFunction
---@param values table
function mt:callEmmySpecial(func, values, source)
    local emmyParams = func:getEmmyParams()
    for index, param in ipairs(emmyParams) do
        local option = param:getOption()
        if option and type(option.special) == 'string' then
            self:checkEmmyParam(func, values, index, option.special, source)
        end
    end
end

---@param func emmyFunction
---@param values table
---@param index integer
---@param special string
function mt:checkEmmyParam(func, values, index, special, source)
    if special == 'dofile:1' then
        self:callEmmyDoFile(func, values, index)
    elseif special == 'loadfile:1' then
        self:callEmmyLoadFile(func, values, index)
    elseif special == 'pcall:1' then
        self:callEmmyPCall(func, values, index, source)
    elseif special == 'require:1' then
        self:callEmmyRequire(func, values, index)
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
    local requireValue = self:tryRequireOne(str, values[index], 'dofile')
    if not requireValue then
        requireValue = self:createValue('any', self:getDefaultSource())
        requireValue.isRequire = true
    end
    func:setReturn(1, requireValue)
end

---@param func emmyFunction
---@param values table
---@param index integer
function mt:callEmmyLoadFile(func, values, index)
    if not values[index] then
        values[index] = self:createValue('any', self:getDefaultSource())
    end
    local str = values[index]:getLiteral()
    if type(str) ~= 'string' then
        return
    end
    local requireValue = self:tryRequireOne(str, values[index], 'loadfile')
    if not requireValue then
        requireValue = self:createValue('any', self:getDefaultSource())
        requireValue:set('cross file', true)
    end
    func:setReturn(1, requireValue)
end

---@param func emmyFunction
---@param values table
---@param index integer
---@param source source
function mt:callEmmyPCall(func, values, index, source)
    local funcValue = values[index]
    if not funcValue then
        return
    end
    local realFunc = funcValue:getFunction()
    if not realFunc then
        return
    end
    local argList = multi()
    values:eachValue(function (i, v)
        if i > index then
            argList:push(v)
        end
    end)
    self:call(funcValue, argList, source)
    if realFunc ~= func then
        func:setReturn(1, self:createValue('boolean', source))
        realFunc:getReturn():eachValue(function (i, v)
            func:setReturn(i + 1, v)
        end)
    end
end

---@param func emmyFunction
---@param values table
---@param index integer
function mt:callEmmyRequire(func, values, index)
    if not values[index] then
        values[index] = self:createValue('any', self:getDefaultSource())
    end
    local strValue = values[index]
    local strSource = strValue:getSource()
    if not strSource then
        return nil
    end
    local str = strValue:getLiteral()
    local raw = self.text:sub(strSource.start, strSource.finish)
    str = plugin.call('OnRequirePath', str, raw) or str
    local lib = library.library[str]
    if lib then
        local value = libraryBuilder.value(lib)
        value:markGlobal()
        func:setReturn(1, value)
        return
    else
        local requireValue = self:tryRequireOne(str, strValue, 'require')
        if not requireValue then
            requireValue = self:createValue('any', self:getDefaultSource())
            requireValue:set('cross file', true)
        end
        func:setReturn(1, requireValue)
    end
end
