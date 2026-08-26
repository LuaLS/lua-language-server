---@class Feature.Diagnostic.ParserDiagnostics
local M = {}

local TAG_UNNECESSARY = ls.spec.DiagnosticTag.Unnecessary

---@param results Feature.Diagnostic[]
---@param code string
---@param start integer
---@param finish integer
---@param message string
function M.push(results, code, start, finish, message)
    results[#results+1] = {
        code    = code,
        level   = 0,
        start   = start,
        finish  = finish,
        message = message,
        tags    = { TAG_UNNECESSARY },
    }
end

---@param block LuaParser.Node.Block
---@return boolean
function M.hasStatements(block)
    for _, child in ipairs(block.childs) do
        if child.kind ~= 'cat' and child.kind ~= 'catblock' then
            return true
        end
    end
    return false
end

---@param loc LuaParser.Node.Local
---@param envMode string
---@return boolean
function M.isExcludedLocal(loc, envMode)
    local name = loc.id
    if name == '_' or name == envMode then
        return true
    end
    if loc.isGlobal then
        return true
    end
    if loc.attr and loc.attr.name and loc.attr.name.id == 'close' then
        return true
    end
    local parent = loc.parent
    if parent and (parent.kind == 'function' or parent.kind == 'for') then
        return true
    end
    return false
end

---@param ast LuaParser.Ast
---@param start integer
---@param finish integer
---@return boolean
function M.isInStringOrComment(ast, start, finish)
    for _, kind in ipairs({ 'string', 'comment' }) do
        for _, node in ipairs(ast.nodesMap[kind]) do
            if node.start <= start and node.finish >= finish then
                return true
            end
        end
    end
    return false
end

return M
