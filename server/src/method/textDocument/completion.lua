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
    local res = nil
    for i = pos-1, 1, -1 do
        local c = buf:sub(i, i)
        if c:find '%a' then
            res = i
        else
            break
        end
    end
    return res
end

local function findWord(position, text)
    for i = position-1, 1, -1 do
        local c = text:sub(i, i)
        if not c:find '%w' then
            return text:sub(i+1, position)
        end
    end
    return text:sub(1, position)
end

return function (lsp, params)
    local uri = params.textDocument.uri
    local text = lsp:getText(uri)
    if not text then
        return nil
    end

    local lines = parser:lines(text, 'utf8')
    -- lua是从1开始的，因此都要+1
    local position = lines:position(params.position.line + 1, params.position.character + 1)
    local word = findWord(position, text)
    local startPos = findStartPos(position, text)

    local vm = lsp:getVM(uri)
    if not vm or not startPos then
        vm = lsp:loadVM(uri)
        if not vm then
            return nil
        end
    end
    startPos = startPos or position

    local items = core.completion(vm, startPos, word)
    if not items or #items == 0 then
        vm = lsp:loadVM(uri)
        if not vm then
            return nil
        end
        startPos = startPos or position
        items = core.completion(vm, startPos, word)
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
