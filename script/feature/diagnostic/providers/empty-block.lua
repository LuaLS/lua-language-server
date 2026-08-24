---@param block LuaParser.Node.Block
---@return boolean
local function hasStatements(block)
    for _, child in ipairs(block.childs) do
        if child.kind ~= 'cat' and child.kind ~= 'catblock' then
            return true
        end
    end
    return false
end

---@param source LuaParser.Node.Base
---@return Feature.Diagnostic
local function makeDiagnostic(source)
    return {
        code    = 'empty-block',
        start   = source.start,
        finish  = source.finish,
        message = 'Empty block.',
        tags    = { ls.spec.DiagnosticTag.Unnecessary },
    }
end

local LOOP_KINDS = { 'while', 'for', 'repeat' }

---@param param Feature.Diagnostic.Param
---@return Feature.Diagnostic[]
local function emptyBlockProvider(param)
    local ast = param.ast
    local results = {}

    for _, kind in ipairs(LOOP_KINDS) do
        for _, node in ipairs(ast.nodesMap[kind]) do
            ---@cast node LuaParser.Node.Block
            if not hasStatements(node) then
                results[#results+1] = makeDiagnostic(node)
            end
        end
    end

    for _, node in ipairs(ast.nodesMap['if']) do
        ---@cast node LuaParser.Node.If
        local allEmpty = true
        for _, child in ipairs(node.childs) do
            if hasStatements(child) then
                allEmpty = false
                break
            end
        end
        if allEmpty then
            results[#results+1] = makeDiagnostic(node)
        end
    end

    return results
end

ls.feature.provider.diagnostic(emptyBlockProvider)
