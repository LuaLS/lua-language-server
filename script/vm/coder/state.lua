---@class Coder
local M = Class 'Coder'

-- 检测表字面量是否为 "{ ... }" 单 varargs 模式
---@param value LuaParser.Node.Base
---@return boolean
local function isVarargTable(value)
    if value.kind ~= 'table' then
        return false
    end
    ---@cast value LuaParser.Node.Table
    return  #value.fields == 1
        and value.fields[1].subtype == 'exp'
        and value.fields[1].value ~= nil
        and value.fields[1].value.kind == 'varargs'
end

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
            coder:addLine('{var}:addAnnotation({subtype%q})' % {
                var     = coder:getKey(var),
                subtype = catState.subtype,
            })
            coder:addDisposer('{var}:removeAnnotation({subtype%q})' % {
                var     = coder:getKey(var),
                subtype = catState.subtype,
            })
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
                catState.binded = true
                return 'rt.type {%q}' % { cat.classID.id }
            end
        elseif cat.kind == 'catstatetype' then
            ---@cast cat LuaParser.Node.CatStateType
            -- type 按变量顺序绑定：`---@type A, B` 分别绑定 local 的第 1/2 个变量
            local typeExp = cat.exps and cat.exps[index] or (index == 1 and cat.exp or nil)
            if typeExp then
                coder:addLine('{var}:addType({type})' % {
                    var  = coder:getKey(var),
                    type = coder:getKey(typeExp),
                })
                if cat.exps and index >= #cat.exps then
                    catState.binded = true
                end
                return coder:getKey(typeExp)
            end
        elseif cat.kind == 'catstateparam' then
            ---@cast cat LuaParser.Node.CatStateParam
            -- 在 for 变量场景下，将 @param 视为 type 绑定，按变量名匹配
            if cat.value then
                local varId
                if var.kind == 'var' then
                    ---@cast var LuaParser.Node.Var
                    varId = var.id
                elseif var.kind == 'local' then
                    ---@cast var LuaParser.Node.Local
                    varId = var.id
                end
                if varId and cat.key and cat.key.id == varId then
                    coder:addLine('{var}:addType({type})' % {
                        var  = coder:getKey(var),
                        type = coder:getKey(cat.value),
                    })
                    catState.binded = true
                    return coder:getKey(cat.value)
                end
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
    -- 对未注解表的索引写 nil 视为删除：不作为类型性 assign 登记，
    -- 避免 nil 写把读值压成 nil（未注解表读取默认不含 nil）。
    self:addLine('{varKey}:addAssign({fieldKey})' % {
        varKey   = self:getKey(var),
        fieldKey = fieldKey,
    })
    self:addDisposer('{varKey}:removeAssign({fieldKey})' % {
        varKey   = self:getKey(var),
        fieldKey = fieldKey,
    })
    -- 值节点关联到所属变量，供 getExpectValue 反推
    if catKey then
        self:addLine('{valueKey}:setExpectParent({varKey})' % {
            valueKey = valueKey,
            varKey   = self:getKey(var),
        })
    end

    local isEnv = var.kind == 'var' and var.id == '_ENV'
    if not isTable or isEnv then
        self:addLine('{varKey}:setStaticValue({valueKey})' % {
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
        isTable[i] = value.kind == 'table' and not isVarargTable(value)
        coder:compile(value)
    end

    -- 第三步：将之前推迟的 appendVar 指令 flush 到 flow（顺序：ref 在前，var 在后）
    if tracer then
        tracer:flushDeferVar()
    end

    -- 第四步：做实际赋值（exps 已编译，只需建立 field/assign 关系）
    for i, exp in ipairs(source.exps) do
        local vk = valueKeys[i]
        if vk then
            coder:compileAssign(exp, i, vk, isTable[i])
        else
            coder:compileAssign(exp, i, 'rt.NIL', false)
        end
    end
end)

ls.vm.registerCoderProvider('localdef', function (coder, source)
    ---@cast source LuaParser.Node.LocalDef

    local valueKeys = {}
    local isTable = {}
    if source.values then
        for i, value in ipairs(source.values) do
            valueKeys[i] = coder:getKey(value)
            isTable[i] = value.kind == 'table' and not isVarargTable(value)
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
            ---@cast callNode LuaParser.Node.Call
            local tracer = coder:getTracer()
            if tracer then
                tracer:appendLink(var, callNode, returnIndex)
            end
        end
    end
    -- 消费未用完的 ---@type 注解（如 `---@type A, B, C` 只声明两个变量），避免泄漏给后续相邻语句
    do
        local catGroup = coder:getCatGroup(source)
        if catGroup then
            for _, catState in ipairs(catGroup) do
                local cat = catState.value
                if cat and cat.kind == 'catstatetype' and not catState.binded then
                    catState.binded = true
                end
            end
        end
    end
end)

ls.vm.registerCoderProvider('globaldef', function (coder, source)
    ---@cast source LuaParser.Node.GlobalDef

    local valueKeys = {}
    if source.values then
        for i, value in ipairs(source.values) do
            valueKeys[i] = coder:getKey(value)
            coder:compile(value)
        end
    end
    for i, var in ipairs(source.vars) do
        if valueKeys[i] then
            coder:addLine('{env}:getChild({name%q}):addAssign(rt.field(rt.value({name%q}), {value}))' % {
                env   = coder:getKey(source.env),
                name  = var.id,
                value = valueKeys[i],
            })
        end
    end
end)

ls.vm.registerCoderProvider('return', function (coder, source)
    ---@cast source LuaParser.Node.Return

    for _, exp in ipairs(source.exps) do
        coder:compile(exp)
    end
    local funcKey = coder:findBlockKV('function')
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
