---@param actual Node
---@return boolean
local function hasAnyMember(actual)
    if actual.kind == 'type' then
        return actual.typeName == 'any'
    end
    if actual.kind == 'union' then
        ---@cast actual Node.Union
        for _, v in ipairs(actual.values) do
            if v.kind == 'type' and v.typeName == 'any' then
                return true
            end
        end
    end
    return false
end

--- 类标注（`---@class`）变量的字段集是「同一名字的多次声明 + 各自绑定的字面量」拼出来的：
--- 其中由绑定值推断出来的字段只算「读取可见性」，不是赋值要求。
--- 比对时只按 `---@field` 与继承来的字段（目标工程 `assign-type-mismatch` 里
--- `hasMarkClass` 的例外同理；否则 `---@class X` + 多次 `local x = setmetatable({...})`
--- 这种装配写法会互相要求对方缺的字段）。
---@param variable Node.Variable
---@return Node?
local function getDeclaredFields(variable)
    local classes = variable.classes
    if not classes or #classes == 0 then
        return nil
    end
    local rt = variable.scope.rt
    ---@type Node.Table[]
    local tables = {}
    for _, class in ipairs(classes) do
        ---@cast class Node.Class
        if class.fields then
            tables[#tables+1] = class.fields
        end
        for _, ext in ipairs(class.extends or {}) do
            if ext.kind == 'table' then
                ---@cast ext Node.Table
                tables[#tables+1] = ext
            elseif ext.kind == 'type' then
                ---@cast ext Node.Type
                tables[#tables+1] = ext.fieldTable
            end
        end
    end
    return rt.mergeTables(tables)
end

---@param vfile VM.Vfile
---@param var LuaParser.Node.Base
---@param callback fun(diag: Feature.Diagnostic)
local function checkAssign(vfile, var, callback)
    local variable = vfile:getVariable(var)
    if not variable then
        return
    end
    local expect = variable:getExpectValue()
    if not expect then
        return
    end
    if expect.kind == 'type' then
        local tn = expect.typeName
        if tn == 'any' or tn == 'unknown' then
            return
        end
    end
    local declared = getDeclaredFields(variable)
    local requireType = declared or expect
    for assign in variable:eachAssign() do
        local actual = assign.value
        if not actual then
            goto continue
        end
        if actual.kind == 'select' then
            ---@cast actual Node.Select
            actual = actual.value
        end
        if actual.kind == 'type' and actual.typeName == 'nil' then
            goto continue
        end
        -- 显式标注的类型上允许逆变：`X | any` 等价于 any，可赋给任何标注类型
        if hasAnyMember(actual) or hasAnyMember(actual:simplify()) then
            goto continue
        end
        if not (actual >> requireType) then
            callback {
                code    = 'assign-type-mismatch',
                level   = 0,
                start   = var.start,
                finish  = var.finish,
                message = ('Cannot assign `%s` to `%s`.'):format(actual:view(), expect:view()),
            }
        end
        ::continue::
    end
end

---@async
---@param param Feature.Diagnostic.Param
---@param callback fun(diag: Feature.Diagnostic)
local function assignTypeMismatchProvider(param, callback)
    local ast = param.ast
    local vfile = param.vfile
    if not vfile then
        return
    end
    local delayer = ls.task.newThrottledDelayer(500)
    for _, node in ipairs(ast.nodesMap['localdef']) do
        delayer:delay()
        ---@cast node LuaParser.Node.LocalDef
        for _, var in ipairs(node.vars) do
            if var.value then
                checkAssign(vfile, var, callback)
            end
        end
    end
    for _, node in ipairs(ast.nodesMap['assign']) do
        delayer:delay()
        ---@cast node LuaParser.Node.Assign
        for _, exp in ipairs(node.exps) do
            if exp.kind == 'var' and exp.value then
                checkAssign(vfile, exp, callback)
            end
        end
    end
end

ls.feature.provider.diagnostic(assignTypeMismatchProvider)
