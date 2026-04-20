local markdown = require 'tools.markdown'

local M = {}

---@param sources LuaParser.Node.Base[]
---@return LuaParser.Node.Base?
function M.getTargetSource(sources)
    return sources[1]
end

---@param scope Scope
---@param source LuaParser.Node.Base
---@return Node?
function M.getSemanticNode(scope, source)
    return scope.vm:getNode(source)
end

---@param view string?
---@return string?
function M.toLuaCodeBlock(view)
    if not view or view == '' then
        return nil
    end
    return markdown.create()
        : append('lua', view)
        : string()
end

---@param node? Node
---@return string[]
function M.getNodeHoverViews(node)
    if not node then
        return {}
    end

    local value = node.value
    if value.kind == 'union' then
        ---@cast value Node.Union
        local views = {}
        for _, subNode in ipairs(value.values) do
            local view = subNode:view()
            if view and view ~= '' then
                views[#views+1] = view
            end
        end
        return views
    end

    local view = value:view()
    if not view or view == '' then
        return {}
    end
    return { view }
end

---@param node? Node
---@param source? LuaParser.Node.Base
---@return string[]
function M.buildMarkdownBlocks(node, source)
    local blocks = {}
    for _, view in ipairs(M.getNodeHoverViews(node)) do
        local block = M.toLuaCodeBlock(view)
        if block then
            blocks[#blocks+1] = block
        end
    end
    if #blocks > 0 then
        return blocks
    end

    if source and source.code then
        local fallback = M.toLuaCodeBlock(source.code)
        if fallback then
            blocks[1] = fallback
        end
    end
    return blocks
end

---@param blocks string[]?
---@return string?
function M.concatMarkdownBlocks(blocks)
    if not blocks or #blocks == 0 then
        return nil
    end
    return table.concat(blocks, '\n\n---\n\n')
end

---@param scope Scope
---@param source LuaParser.Node.Base
---@return string?
function M.getSourceView(scope, source)
    local node = M.getSemanticNode(scope, source)
    if node then
        return node:view()
    end
    return source.code
end

return M
