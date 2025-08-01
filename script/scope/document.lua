---@class Document: Class.Base, GCHost
local M = Class 'Document'

Extends('Document', 'GCHost')

---@param file File
function M:__init(file)
    self.file = file
    self.serverVersion = file.serverVersion
    self.clientVersion = file.clientVersion

    file:bindGC(self)
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

function M:remove()
    Delete(self)
end

---@param offset integer
---@param accepts? table<string, true>
---@return LuaParser.Node.Base[]
function M:findSources(offset, accepts)
    local ast = self.ast
    if not ast then
        return {}
    end
    local sources = {}

    for kind, nodes in pairs(ast.nodesMap) do
        if kind == 'error' then
            goto continue
        end
        for _, node in ipairs(nodes) do
            if  node.start <= offset
            and node.finish >= offset
            and not node.dummy then
                if accepts and not accepts[node.kind] then
                    goto continue
                end
                sources[#sources+1] = node
            end
            ::continue::
        end
        ::continue::
    end

    ---@param source LuaParser.Node.Base
    ---@return integer
    local function countStack(source)
        for i = 1, 1000 do
            if source.kind == 'main' then
                return i
            end
            source = source.parent
        end
        return 1000
    end

    table.sort(sources, function (a, b)
        if a.start ~= b.start then
            return a.start > b.start
        end
        if a.finish ~= b.finish then
            return a.finish < b.finish
        end
        return countStack(a) > countStack(b)
    end)

    return sources
end
