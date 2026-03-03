---@class Coder
local M = Class 'Coder'

---@param coder Coder
---@param var LuaParser.Node.AssignAble
---@param index integer
---@return string?
local function tryBindCat(coder, var, index)
    local catGroup = coder:getCatGroup(var)
    if not catGroup then
        return nil
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
                return 'rt.type {%q}' % { cat.classID.id }
            end
        elseif cat.kind == 'catstatetype' then
            ---@cast cat LuaParser.Node.CatStateType
            -- type 目前只支持绑定第一个变量
            if index == 1 then
                coder:addLine('{var}:addType({type})' % {
                    var  = coder:getKey(var),
                    type = coder:getKey(cat.exp),
                })
                return coder:getKey(cat.exp)
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
    local catKey = tryBindCat(self, var, index)

    if not valueKey then
        return
    end

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

    if not isTable then
        self:addLine('{varKey}:setCurrentValue({valueKey})' % {
            varKey   = self:getKey(var),
            valueKey = catKey or valueKey,
        })
    end
end

ls.vm.registerCoderProvider('assign', function (coder, source)
    ---@cast source LuaParser.Node.Assign

    -- 第一步：预编译所有 exps，只建立 shadow/注册 key，
    -- 但暂不生成 tracer 的 appendVar 指令（推迟到右侧编译完之后）。
    -- 这样函数体引用 M.method 等名字时能找到对应 key（时序问题的原修复保留），
    -- 同时保证 flow 里 ref（右侧读取）先于 var（左侧赋值），避免 Walker 逻辑错误。
    local tracer = coder:getTracer()
    if tracer then
        tracer:beginDeferVar()
    end
    for i, exp in ipairs(source.exps) do
        coder:compile(exp)
    end

    -- 第二步：编译右侧（values），此时 appendRef 正常追加到 flow
    local valueKeys = {}
    local isTable = {}
    for i, value in ipairs(source.values) do
        valueKeys[i] = coder:getKey(value)
        isTable[i] = value.kind == 'table'
        coder:compile(value)
    end

    -- 第三步：将之前推迟的 appendVar 指令 flush 到 flow（顺序：ref 在前，var 在后）
    if tracer then
        tracer:flushDeferVar()
    end

    -- 第四步：做实际赋值（exps 已编译，只需建立 field/assign 关系）
    for i, exp in ipairs(source.exps) do
        coder:compileAssign(exp, i, valueKeys[i], isTable[i])
    end
end)

ls.vm.registerCoderProvider('localdef', function (coder, source)
    ---@cast source LuaParser.Node.LocalDef
    local vcount = source.values and #source.values or 0
    print('[DEBUG localdef] called, vars=' .. tostring(#source.vars) .. ' values=' .. tostring(vcount))
    if vcount == 2 and #source.vars == 2 then
        for i, v in ipairs(source.values) do
            print('[DEBUG localdef] value[' .. i .. '].kind=' .. tostring(v.kind))
        end
    end

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
        -- 记录 var 与 call 的关联，用于间接窄化（如 tp = type(x), local ok, err = f()）
        local value = source.values and source.values[i]
        local callNode = nil
        local returnIndex = i
        if value then
            if value.kind == 'call' then
                callNode = value
            elseif value.kind == 'select' then
                -- local a, b = f() 中，value 是 select 节点，value.value 是 call 节点
                if value.value and value.value.kind == 'call' then
                    callNode = value.value
                    returnIndex = value.index or i
                end
            end
        end
        if callNode then
            local tracer = coder:getTracer()
            if tracer then
                tracer:appendLink(var, callNode, returnIndex)
            end
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

ls.vm.registerCoderProvider('label', function (coder, source)
    ---@cast source LuaParser.Node.Label

    coder:addUnneeded(source)
end)

ls.vm.registerCoderProvider('goto', function (coder, source)
    ---@cast source LuaParser.Node.Goto

    coder:addUnneeded(source)
end)

ls.vm.registerCoderProvider('break', function (coder, source)
    ---@cast source LuaParser.Node.Break

    coder:addUnneeded(source)
end)
