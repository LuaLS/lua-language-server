local createDots = require 'vm.dots'
local createMulti = require 'vm.multi'
local createValue = require 'vm.value'
local createLocal = require 'vm.local'

local mt = {}
mt.__index = mt
mt.type = 'function'
mt._runed = 0
mt._top = 0

function mt:getUri()
    return self.source.uri
end

function mt:push()
    self._top = self._top + 1
    self.locals[self._top] = {}
end

function mt:pop()
    self._top = self._top - 1
end

function mt:saveLocal(name, loc)
    if loc.type ~= 'local' then
        error('saveLocal必须是local')
    end
    self.locals[self._top][name] = loc
end

function mt:loadLocal(name)
    for i = self._top, 1, -1 do
        local locals = self.locals[i]
        local loc = locals[name]
        if loc then
            return loc
        end
    end
    return nil
end

function mt:eachLocal(callback)
    local mark = {}
    for i = self._top, 1, -1 do
        local locals = self.locals[i]
        for name, loc in pairs(locals) do
            if not mark[name] then
                mark[name] = true
                local res = callback(name, loc)
                if res ~= nil then
                    return res
                end
            end
        end
    end
    return nil
end

function mt:saveLabel(label)
    if not self._label then
        self._label = {}
    end
    self._label[#self._label+1] = label
end

function mt:loadLabel(name)
    if not self._label then
        return nil
    end
    for _, label in ipairs(self._label) do
        if label:getName() == name then
            return label
        end
    end
    return nil
end

function mt:setReturn(index, value)
    self.hasReturn = true
    if not self.returns then
        self.returns = createMulti()
    end
    if value then
        self.returns[index] = value
    else
        self.returns[index] = createValue('any', self.source)
    end
end

function mt:getReturn(index)
    if self.maxReturns and index and self.maxReturns < index then
        return createValue('nil')
    end
    if not self.returns then
        self.returns = createMulti()
    end
    if index then
        return self.returns:get(index)
    else
        return self.returns
    end
end

function mt:returnDots(index)
    if not self.returns then
        self.returns = {}
    end
    self.returns[index] = createDots()
end

function mt:loadDots(expect)
    if not self._dots then
        self._dots = createDots()
    end
    return self._dots:get(expect)
end

function mt:setObject(value, source)
    self._objectValue = value
    self._objectSource = source
end

function mt:hasRuned()
    return self._runed > 0
end

function mt:run()
    self._runed = self._runed + 1
    if not self.source then
        return
    end

    -- 第一次运行函数时，创建函数的参数
    if self._runed ~= 1 then
        return
    end

    -- 如果是面向对象形式的函数，创建隐藏的参数self
    if self._objectSource then
        local loc = createLocal('self', self._objectSource, self._objectValue)
        self:saveLocal('self', loc)
    end

    -- 显性声明的参数
    self:createArgs()
end

function mt:setArgs(values)
    if not self.argValues then
        self.argValues = {}
    end
    for i = 1, #values do
        self.argValues[i] = values[i]
    end
    if self.dots then
        local dotsIndex = #self.args
        for i = dotsIndex, #values do
            self.dots:set(i - dotsIndex + 1, values[i])
        end
    end
end

function mt:createArg(arg)
    if arg.type == 'name' then
        local loc = createLocal(arg[1], arg, createValue('any', arg))
        self:saveLocal(arg[1], loc)
    elseif arg.type == '...' then
    end
end

function mt:createArgs()
    if not self.source then
        return
    end
    local args = self.source.arg
    if not args then
        return
    end
    if args.type == 'list' then
        for _, arg in ipairs(args) do
            self:createArg(arg)
        end
    else
        self:createArg(args)
    end
end

return function (source)
    local self = setmetatable({
        source = source,
        locals = {},
    }, mt)
    self:push()
    return self
end
