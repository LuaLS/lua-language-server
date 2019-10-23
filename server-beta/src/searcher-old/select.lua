local guide = require 'parser.guide'

local m = {}

function m:eachDef(source, callback)
    local vararg = source.vararg
    if vararg.type == 'call' then
        local func = vararg.node
        self:eachValue(func, function (info)
            self:functionReturnOf(info.source, function ()

            end)
        end)
    end
end

function m:eachValue(source, callback)
    local vararg = source.vararg
    if vararg.type == 'call' then
        local func = vararg.node
        if  self:getSpecialName(func) == 'setmetatable'
        and source.index == 1 then
            local t, mt = self:callArgOf(vararg)
            self:eachValue(t, callback)
            self:eachField(mt, 's|__index', function (info)
                if info.mode == 'set' then
                    info.searcher:eachValue(info.source, callback)
                end
            end)
        end
    end
end

return m
