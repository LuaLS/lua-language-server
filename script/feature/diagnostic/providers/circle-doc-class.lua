---@async
---@param param Feature.Diagnostic.Param
---@return Feature.Diagnostic[]
local function circleDocClassProvider(param)
    local ast = param.ast
    local results = {}
    local delayer = ls.task.newThrottledDelayer(500)

    ---@type table<string, string[]>
    local extendsMap = {}
    ---@type table<string, LuaParser.Node.CatStateClass>
    local classNode = {}
    for _, cls in ipairs(ast.nodesMap['catstateclass']) do
        delayer:delay()
        ---@cast cls LuaParser.Node.CatStateClass
        local name = cls.classID.id
        classNode[name] = cls
        if cls.extends then
            local list = {}
            for _, extend in ipairs(cls.extends) do
                local id = extend
                if id.kind == 'catparen' then
                    id = id:trim()
                end
                if id.kind == 'catid' then
                    ---@cast id LuaParser.Node.CatID
                    if not id.var and not id.generic and not id.genericTemplate then
                        list[#list+1] = id.id
                    end
                end
            end
            if #list > 0 then
                extendsMap[name] = list
            end
        end
    end

    for name, cls in pairs(classNode) do
        delayer:delay()
        ---@type table<string, boolean>
        local visited = { [name] = true }
        ---@param n string
        ---@return boolean
        local function walk(n)
            local nexts = extendsMap[n]
            if not nexts then
                return false
            end
            for _, next in ipairs(nexts) do
                if next == name then
                    return true
                end
                if not visited[next] and classNode[next] then
                    visited[next] = true
                    if walk(next) then
                        return true
                    end
                end
            end
            return false
        end
        if walk(name) then
            results[#results+1] = {
                code    = 'circle-doc-class',
                level   = 0,
                start   = cls.start,
                finish  = cls.finish,
                message = ('Circle of doc class `%s`.'):format(name),
            }
        end
    end
    return results
end

ls.feature.provider.diagnostic(circleDocClassProvider)
