local mt = require 'vm.manager'
local multi = require 'vm.multi'

function mt:callPcall(func, values, source)
    local funcValue = values:first()
    if not funcValue then
        return
    end
    local realFunc = funcValue:getFunction()
    if not realFunc then
        return
    end
    local argList = multi()
    values:eachValue(function (i, v)
        if i >= 2 then
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

function mt:callXpcall(func, values, source)
    local funcValue = values:first()
    if not funcValue then
        return
    end
    local realFunc = funcValue:getFunction()
    if not realFunc then
        return
    end
    local argList = multi()
    values:eachValue(function (i, v)
        if i >= 3 then
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
