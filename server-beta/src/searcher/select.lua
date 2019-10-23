local guide = require 'parser.guide'

local m = {}

function m:eachValue(source, callback)
    local vararg = source.vararg
    if vararg.type == 'call' then
        local func = vararg.node
        if self:getSpecialName(func) == 'setmetatable' then
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
