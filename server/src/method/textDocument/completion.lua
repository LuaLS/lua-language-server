local core = require 'core'
local parser = require 'parser'

local function posToRange(lines, start, finish)
    local start_row,  start_col  = lines:rowcol(start)
    local finish_row, finish_col = lines:rowcol(finish)
    return {
        start = {
            line = start_row - 1,
            character = start_col - 1,
        },
        ['end'] = {
            line = finish_row - 1,
            character = finish_col,
        },
    }
end

local function findStartPos(pos, buf)
    local res = pos
    for i = pos-1, 1, -1 do
        local c = buf:sub(i, i)
        if c:find '%a' then
            res = i
        end
        if c == '.' or c == ':' then
            break
        end
    end
    return res
end

return function (lsp, params)
    local uri = params.textDocument.uri
    local vm, lines, buf = lsp:getVM(uri)
    if not vm then
        vm, lines, buf = lsp:loadVM(uri)
        if not vm then
            return nil
        end
    end
    -- lua是从1开始的，因此都要+1
    local position = lines:position(params.position.line + 1, params.position.character + 1)

    local startPos = findStartPos(position, buf)
    if not startPos then
        vm, lines, buf = lsp:loadVM(uri)
        if not vm then
            return nil
        end
    end

    local items = core.completion(vm, startPos or position, buf)
    if not items or #items == 0 then
        vm, lines, buf = lsp:loadVM(uri)
        if not vm then
            return nil
        end
        position = lines:position(params.position.line + 1, params.position.character + 1)
        startPos = findStartPos(position, buf)
        items = core.completion(vm, startPos or position, buf)
        if not items or #items == 0 then
            return nil
        end
    end
    for i, item in ipairs(items) do
        item.sortText = ('%04d'):format(i)
        if item.textEdit then
            item.textEdit.range = posToRange(lines, item.textEdit.start, item.textEdit.finish)
            item.textEdit.start = nil
            item.textEdit.finish = nil
        end
    end
    local response = {
        isIncomplete = false,
        items = items,
    }
    return response
end
