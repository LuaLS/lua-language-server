local env = require 'vm.env'
local createDots = require 'vm.dots'

local mt = {}
mt.__index = mt
mt.type = 'function'
mt._runed = 0

function mt:getUri()
    return self.source.uri
end

function mt:saveLocal(name, loc)
    self.locals[name] = loc
end

function mt:loadLocal(name)
    local loc = self.locals[name]
    if loc then
        return loc
    end
    loc = self.upvalues(name)
    if loc then
        return loc
    end
    return nil
end

function mt:eachLocal(callback)
    for name, loc in pairs(self.locals) do
        local res = callback(name, loc)
        if res ~= nil then
            return res
        end
    end
    return nil
end

function mt:setReturn(index, value)
    if not self.returns then
        self.returns = {}
    end
    self.returns[index] = value
end

function mt:returnDots(index)
    if not self.returns then
        self.returns = {}
    end
    self.returns[index] = createDots()
end

function mt:hasRuned()
    return self._runed > 0
end

function mt:run()
    self._runed = self._runed + 1
    if not self.source then
        return
    end

    --local index = 0
    --if func.object then
    --    local var = self:createArg('self', func.colon, self:getValue--(func.object, func.colon))
    --    var.hide = true
    --    var.link = func.object
    --    if func.argValues[1] then
    --        self:setValue(var, func.argValues[1])
    --    end
    --    index = 1
    --    func.args[index] = var
    --end

    local stop
    self:forList(func.built.arg, function (arg)
        if stop then
            return
        end
        index = index + 1
        if arg.type == 'name' then
            local var = self:createArg(arg[1], arg)
            self:setValue(var, func.argValues[index] or self:createValue('nil'))
            func.args[index] = var
        elseif arg.type == '...' then
            local dots = self:createDots(index, arg)
            for i = index, #func.argValues do
                dots[#dots+1] = func.argValues[i]
            end
            func.hasDots = true
            stop = true
        end
    end)
end

function mt:saveUpvalues(name, loc)
    self.upvalues[name] = loc
end

return function (source)
    local self = setmetatable({
        source = source,
        locals = {},
        upvalues = {},
    }, mt)
    return self
end
