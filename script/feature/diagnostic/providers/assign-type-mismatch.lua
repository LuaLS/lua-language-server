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
        if not (actual >> expect) then
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
