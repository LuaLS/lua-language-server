local positionConverter = require 'tools.position-converter'
local class = require 'class'
local parser = require 'parser'

---@class Document: Class.Base, GCHost
local M = Class 'Document'

Extends('Document', 'GCHost')

M.version = 0

---@param file File
function M:__init(file)
    self.file = file
    self.version = 1

    file.onDidChange:on(function ()
        self.version = self.version + 1
        class.flush(self)
    end)

    file:bindGC(self)
end

---@type string
M.text = nil

M.__getter.text = function (self)
    return self.file:getText() or ''
end

---@type LuaParser.Ast
M.ast = nil

---@param self Document
---@return LuaParser.Ast | false
---@return true
M.__getter.ast = function (self)
    local suc, ast = xpcall(parser.compile, log.error, self.text, self.file.uri)
    if not suc then
        return false, true
    end
    return ast, true
end

---@type PositionConverter
M.positionConverter = nil

---@param self Document
---@return PositionConverter
---@return true
M.__getter.positionConverter = function (self)
    local text = self.file:getText() or ''
    return positionConverter.parse(text), true
end

---@param position LSP.Position
---@return integer offset # 0-based
function M:at(position)
    local pc = self.positionConverter
    return pc:positionToOffset(position.line, position.character)
end

---@param offset integer # 0-based
---@return LSP.Position
function M:positionOf(offset)
    local pc = self.positionConverter
    local line, character = pc:offsetToPosition(offset)
    return { line = line, character = character }
end

---@param startOffset integer # 0-based
---@param endOffset integer # 0-based
---@return LSP.Range
function M:rangeOf(startOffset, endOffset)
    return {
        start = self:positionOf(startOffset),
        ['end'] = self:positionOf(endOffset),
    }
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
