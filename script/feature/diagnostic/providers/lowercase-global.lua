---@async
---@param param Feature.Diagnostic.Param
---@param callback fun(diag: Feature.Diagnostic)
local function lowercaseGlobalProvider(param, callback)
    local ast = param.ast
    local scope = param.scope
    local uri = param.uri
    local delayer = ls.task.newThrottledDelayer(500)

    local globals = scope.config:get(uri, 'Lua.diagnostics.globals') or {}
    local globalsSet = {}
    for _, g in ipairs(globals) do
        globalsSet[g] = true
    end
    local globalsRegex = scope.config:get(uri, 'Lua.diagnostics.globalsRegex') or {}

    local metaUris = {}
    for _, root in ipairs(scope.roots) do
        if root.kind == 'meta' then
            metaUris[root.uri] = true
        end
    end
    local function isMetaUri(u)
        for metaUri in pairs(metaUris) do
            if u:sub(1, #metaUri) == metaUri then
                return true
            end
        end
        return false
    end

    local rt = scope.rt

    local function isDefinedInMeta(name)
        local globalVar = rt.VAR_G
            and rt.VAR_G.childs
            and rt.VAR_G.childs[rt.luaKey(name)]
        if not globalVar then
            return false
        end
        local sv = globalVar.staticValue
        if sv then
            local func = sv --[[@as Node.Function]]
            local loc = func.location
            if loc and loc.uri and isMetaUri(loc.uri) then
                return true
            end
        end
        for assign in globalVar:eachAssign() do
            ---@type Node.Field
            local field = assign
            local loc = field.location
            if loc and loc.uri and isMetaUri(loc.uri) then
                return true
            end
        end
        return false
    end

    for _, node in ipairs(ast.nodesMap['assign']) do
        delayer:delay()
        ---@cast node LuaParser.Node.Assign
        for _, exp in ipairs(node.exps) do
            if exp.kind ~= 'var' then
                goto continueExp
            end
            ---@cast exp LuaParser.Node.Var
            if exp.loc or exp.global then
                goto continueExp
            end
            local name = exp.id
            if globalsSet[name] then
                goto continueExp
            end
            if isDefinedInMeta(name) then
                goto continueExp
            end
            local first = name:match '%w'
            if not first or not first:match '%l' then
                goto continueExp
            end
            local matched = false
            for _, pattern in ipairs(globalsRegex) do
                if name:match(pattern) then
                    matched = true
                    break
                end
            end
            if matched then
                goto continueExp
            end
            callback {
                code    = 'lowercase-global',
                level   = 0,
                start   = exp.start,
                finish  = exp.finish,
                message = 'Global variable in lowercase initial, Did you miss `local` or misspell it?',
            }
            ::continueExp::
        end
    end
end

ls.feature.provider.diagnostic(lowercaseGlobalProvider)
