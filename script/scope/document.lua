---@class Document: Class.Base
local M = Class 'Document'

---@param file File
function M:__init(file)
    self.file = file
    self.serverVersion = file.serverVersion
    self.clientVersion = file.clientVersion
end

---@type LuaParser.Ast
M.ast = nil

---@param self Document
---@return LuaParser.Ast | false
---@return true
M.__getter.ast = function (self)
    local suc, ast = xpcall(ls.parser.compile, log.error, self.file:getText(), self.file.uri)
    if not suc then
        return false, true
    end
    return ast, true
end

---@param offset integer
---@param accepts? string[]
---@return LuaParser.Node.Base[]
function M:findSources(offset, accepts)
    local ast = self.ast
    if not ast then
        return {}
    end
    local sources = {}

    for _, nodes in pairs(ast.nodesMap) do
        for _, node in ipairs(nodes) do
            if node.start <= offset and node.finish >= offset then
                if accepts and not accepts[node.kind] then
                    goto continue
                end
                sources[#sources+1] = node
            end
            ::continue::
        end
    end

    table.sort(sources, function (a, b)
        if a.start == b.start then
            return a.finish < b.finish
        end
        return a.start > b.start
    end)

    return sources
end
