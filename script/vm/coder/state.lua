---@class VM.Coder
local M = Class 'VM.Coder'

---@param coder VM.Coder
---@param var LuaParser.Node.AssignAble
---@param index integer
local function tryBindCat(coder, var, index)
    local catGroup = coder:getCatGroup(var)
    if not catGroup then
        return
    end
    for _, cat in ipairs(catGroup) do
        if cat.value.kind == 'catstateclass' then
            -- class 只能绑定第一个变量
            if index == 1 then
                coder:addLine('{var}:addClass({class})\n{class}:addVariable({var})' % {
                    var   = coder:getKey(var),
                    class = coder:getKey(cat),
                })
            end
        end
    end
end

---@param var LuaParser.Node.AssignAble
---@param index integer
---@param valueKey? string
function M:compileAssign(var, index, valueKey)
    self:addLine([[
{varKey}:addAssign {
    key      = {key},
    value    = {value},
    location = {location},
}
]] % {
        varKey   = self:getKey(var),
        key      = self:makeFieldCode(var),
        value    = valueKey or 'node.NIL',
        location = self:makeLocationCode(var),
    })
    tryBindCat(self, var, index)
end

ls.vm.registerCoderProvider('assign', function (coder, source)
    ---@cast source LuaParser.Node.Assign

    coder:withIndentation(function ()
        local valueKeys = {}
        for i, value in ipairs(source.values) do
            valueKeys[i] = coder:getKey(value)
            coder:compile(value)
        end
        for i, exp in ipairs(source.exps) do
            coder:compile(exp)
            coder:compileAssign(exp, i, valueKeys[i])
        end
    end, source.code)
end)

ls.vm.registerCoderProvider('localdef', function (coder, source)
    ---@cast source LuaParser.Node.LocalDef

    coder:withIndentation(function ()
        local valueKeys = {}
        for i, value in ipairs(source.values) do
            valueKeys[i] = coder:getKey(value)
            coder:compile(value)
        end
        for i, var in ipairs(source.vars) do
            coder:compile(var)
            coder:compileAssign(var, i, valueKeys[i])
        end
    end, source.code)
end)
