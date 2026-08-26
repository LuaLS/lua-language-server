local pd = require 'feature.diagnostic.parser-diagnostics'

---@async
---@param param Feature.Diagnostic.Param
---@return Feature.Diagnostic[]
local function emptyBlockProvider(param)
    local ast = param.ast
    local results = {}
    local delayer = ls.task.newThrottledDelayer(500)
    local kinds = { 'while', 'for', 'repeat' }
    for _, kind in ipairs(kinds) do
        for _, node in ipairs(ast.nodesMap[kind]) do
            delayer:delay()
            ---@cast node LuaParser.Node.Block
            if not pd.hasStatements(node) then
                pd.push(results, 'empty-block', node.start, node.finish, 'Empty block.')
            end
        end
    end
    for _, node in ipairs(ast.nodesMap['if']) do
        delayer:delay()
        ---@cast node LuaParser.Node.If
        local allEmpty = true
        for _, child in ipairs(node.childs) do
            if pd.hasStatements(child) then
                allEmpty = false
                break
            end
        end
        if allEmpty then
            pd.push(results, 'empty-block', node.start, node.finish, 'Empty block.')
        end
    end
    return results
end

ls.feature.provider.diagnostic(emptyBlockProvider)
