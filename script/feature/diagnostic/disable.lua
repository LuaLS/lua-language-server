---@class Feature.Diagnostic.Disable
local M = {}

---@class Feature.Diagnostic.DisableRange
---@field mode 'disable' | 'enable'
---@field names table<string, true>?
---@field row integer

---@param ast LuaParser.Ast
---@return Feature.Diagnostic.DisableRange[]
function M.buildRanges(ast)
    local ranges = {}
    for _, node in ipairs(ast.nodesMap['catstatediagnostic']) do
        ---@cast node LuaParser.Node.CatStateDiagnostic
        local names
        if node.names then
            names = {}
            for _, name in ipairs(node.names) do
                names[name.id] = true
            end
        end
        local row = node.startRow
        if node.mode == 'disable-next-line' then
            ranges[#ranges+1] = { mode = 'disable', names = names, row = row + 1 }
            ranges[#ranges+1] = { mode = 'enable',  names = names, row = row + 2 }
        elseif node.mode == 'disable-line' then
            ranges[#ranges+1] = { mode = 'disable', names = names, row = row }
            ranges[#ranges+1] = { mode = 'enable',  names = names, row = row + 1 }
        elseif node.mode == 'disable' then
            ranges[#ranges+1] = { mode = 'disable', names = names, row = row + 1 }
        elseif node.mode == 'enable' then
            ranges[#ranges+1] = { mode = 'enable',  names = names, row = row + 1 }
        end
    end
    table.sort(ranges, function (a, b)
        return a.row < b.row
    end)
    return ranges
end

---@param ranges Feature.Diagnostic.DisableRange[]
---@param row integer
---@param name string
---@param isSyntax boolean
---@return boolean
function M.isDisabled(ranges, row, name, isSyntax)
    if #ranges == 0 then
        return false
    end
    local count = 0
    for _, range in ipairs(ranges) do
        if range.row > row then
            break
        end
        if (range.names and range.names[name])
        or (not range.names and not isSyntax) then
            if range.mode == 'disable' then
                count = count + 1
            elseif range.mode == 'enable' then
                count = count - 1
            end
        end
    end
    return count > 0
end

return M
