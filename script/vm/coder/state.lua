---@param coder VM.Coder
---@param var LuaParser.Node.Exp
---@param varKey string
---@param index integer
local function tryBindCat(coder, var, varKey, index)
    local catGroup = coder:getCatGroup(var)
    if not catGroup then
        return
    end
    for _, cat in ipairs(catGroup) do
        if cat.kind == 'catstateclass' then
            -- class 只能绑定第一个变量
            if index == 1 then
                coder:addLine('')
            end
        end
    end
end

---@param coder VM.Coder
---@param var LuaParser.Node.Var
---@param index integer
---@param valueKey? string
local function assignGlobalVariable(coder, var, index, valueKey)
    local varKey = coder:getKey(var)
    coder:addLine([[
{varKey} = node:globalAdd {
    key = {key},
    value = {value},
    location = {location}
}
]] % {
        varKey = varKey,
        key = ('node.value %q'):format(var.id),
        value = valueKey or 'node.NIL',
        location = coder:makeLocationCode(var),
    })
    tryBindCat(coder, var, varKey, index)
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
            if exp.kind == 'var' then
                ---@cast exp LuaParser.Node.Var
                if exp.loc then
                else
                    assignGlobalVariable(coder, exp, i, valueKeys[i])
                end
            end
        end
    end, source.code)
end)
