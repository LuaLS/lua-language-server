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
    for _, catState in ipairs(catGroup) do
        local cat = catState.value
        if not cat then
            goto continue
        end
        if cat.kind == 'catstateclass' then
            ---@cast cat LuaParser.Node.CatStateClass
            -- class 只能绑定第一个变量
            if index == 1 then
                coder:addLine('{var}:addClass({class})\n{class}:addVariable({var})' % {
                    var   = coder:getKey(var),
                    class = coder:getKey(cat),
                })
                coder:addDisposer('{class}:removeVariable({var})\n{var}:removeClass({class})' % {
                    var   = coder:getKey(var),
                    class = coder:getKey(cat),
                })
            end
        elseif cat.kind == 'catstatetype' then
            ---@cast cat LuaParser.Node.CatStateType
            -- type 目前只支持绑定第一个变量
            if index == 1 then
                coder:addLine('{var}:addType({type})' % {
                    var  = coder:getKey(var),
                    type = coder:getKey(cat.exp),
                })
            end
        end
        ::continue::
    end
end

---@param var LuaParser.Node.AssignAble
---@param index integer
---@param valueKey? string
function M:compileAssign(var, index, valueKey)
    local key = 'node.UNKNOWN'
    if var.kind == 'var' then
        ---@cast var LuaParser.Node.Var
        key = ('node.value %q'):format(var.id)
    elseif var.kind == 'local' then
        ---@cast var LuaParser.Node.Local
        key = ('node.value %q'):format(var.id)
    elseif var.kind == 'field' then
        ---@cast var LuaParser.Node.Field
        key = self:getKey(var.key)
    end
    local fieldKey = self:getCustomKey('field|' .. var.uniqueKey)
    self:addLine([[
{fieldKey} = {
    key      = {key},
    value    = {value},
    location = {location},
}
]] % {
        fieldKey = fieldKey,
        key      = key,
        value    = valueKey or 'node.NIL',
        location = self:makeLocationCode(var),
    })
    self:addLine('{varKey}:addAssign({fieldKey})' % {
        varKey   = self:getKey(var),
        fieldKey = fieldKey,
    })
    self:addDisposer('{varKey}:removeAssign({fieldKey})' % {
        varKey   = self:getKey(var),
        fieldKey = fieldKey,
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
        if source.values then
            for i, value in ipairs(source.values) do
                valueKeys[i] = coder:getKey(value)
                coder:compile(value)
            end
        end
        for i, var in ipairs(source.vars) do
            coder:compile(var)
            if valueKeys[i] then
                coder:compileAssign(var, i, valueKeys[i])
            else
                coder:compileAssign(var, i, 'node.NIL')
            end
        end
    end, source.code)
end)
