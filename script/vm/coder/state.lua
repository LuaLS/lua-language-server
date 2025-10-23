---@param coder VM.Coder
---@param var LuaParser.Node.Exp
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

---@param coder VM.Coder
---@param var LuaParser.Node.Exp
---@param index integer
---@param valueKey? string
local function assign(coder, var, index, valueKey)
    coder:addLine([[
{varKey}:addAssign {
    key      = {key},
    value    = {value},
    location = {location},
}
]] % {
        varKey   = coder:getKey(var),
        key      = coder:makeFieldCode(var),
        value    = valueKey or 'node.NIL',
        location = coder:makeLocationCode(var),
    })
    tryBindCat(coder, var, index)
end

ls.vm.registerCoderProvider('assign', function (coder, source)
    ---@cast source LuaParser.Node.Assign

    coder:withNewBlock(function ()
        local valueKeys = {}
        for i, value in ipairs(source.values) do
            valueKeys[i] = coder:getKey(value)
            coder:compile(value)
        end
        for i, exp in ipairs(source.exps) do
            coder:compile(exp)
            assign(coder, exp, i, valueKeys[i])
        end
    end, source.code)
end)
