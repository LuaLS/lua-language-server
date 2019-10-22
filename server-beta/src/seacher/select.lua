local guide = require 'parser.guide'

local m = {}

function m:eachValue(source, callback)
    local vararg = source.vararg
    if vararg.type == 'call' then
        local func = vararg.node
        if self:getSpecialName(func) == 'setmetatable' then
            local t, mt = self:callArgOf(vararg)
            self:eachValue(t, callback)
            self:eachField(mt, 's|__index', function (src, mode)
                if mode == 'set' then
                    self:eachValue(src, callback)
                end
            end)
        end
    end
end

return m
