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
---@param isTable? boolean
function M:compileAssign(var, index, valueKey, isTable)
    local key = 'rt.UNKNOWN'
    if var.kind == 'var' then
        ---@cast var LuaParser.Node.Var
        key = ('rt.value %q'):format(var.id)
    elseif var.kind == 'local' then
        ---@cast var LuaParser.Node.Local
        key = ('rt.value %q'):format(var.id)
    elseif var.kind == 'field' then
        ---@cast var LuaParser.Node.Field
        key = self:makeFieldCode(var.key) or 'rt.UNKNOWN'
    end
    tryBindCat(self, var, index)

    if not valueKey then
        return
    end
    local fieldKey = self:getCustomKey('field|' .. var.uniqueKey)
    self:addLine([[
{fieldKey} = rt.field({key}, {value}):setLocation {location}
]] % {
        fieldKey = fieldKey,
        key      = key,
        value    = valueKey,
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
    if isTable then
        self:addLine('{valueKey}:setExpectParent({varKey})' % {
            valueKey = valueKey,
            varKey   = self:getKey(var),
        })
    end
end

ls.vm.registerCoderProvider('assign', function (coder, source)
    ---@cast source LuaParser.Node.Assign

    local valueKeys = {}
    local isTable = {}
    for i, exp in ipairs(source.exps) do
        coder:compile(exp)
    end
    for i, value in ipairs(source.values) do
        valueKeys[i] = coder:getKey(value)
        isTable[i] = value.kind == 'table'
        coder:compile(value)
    end
    for i, exp in ipairs(source.exps) do
        coder:compileAssign(exp, i, valueKeys[i], isTable[i])
    end
end)

ls.vm.registerCoderProvider('localdef', function (coder, source)
    ---@cast source LuaParser.Node.LocalDef

    local valueKeys = {}
    local isTable = {}
    if source.values then
        for i, value in ipairs(source.values) do
            valueKeys[i] = coder:getKey(value)
            isTable[i] = value.kind == 'table'
            coder:compile(value)
        end
    end
    for i, var in ipairs(source.vars) do
        coder:compile(var)
        if valueKeys[i] then
            coder:compileAssign(var, i, valueKeys[i], isTable[i])
        else
            coder:compileAssign(var, i)
        end
    end
end)

ls.vm.registerCoderProvider('return', function (coder, source)
    ---@cast source LuaParser.Node.Return

    for _, exp in ipairs(source.exps) do
        coder:compile(exp)
    end
    local funcKey = coder:getBlockKV('function')
    if not funcKey then
        return
    end
    coder:addLine('{funcKey}:addReturnList(rt.list {{values}})' % {
        funcKey = funcKey,
        values  = table.concat(ls.util.map(source.exps, function (v)
            return coder:getKey(v)
        end), ', '),
    })
end)

ls.vm.registerCoderProvider('singleexp', function (coder, source)
    ---@cast source LuaParser.Node.SingleExp

    coder:compile(source.exp)
end)
