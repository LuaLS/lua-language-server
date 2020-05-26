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

local function fastCompletion(lsp, params, lines)
    local uri = params.textDocument.uri
    local text, oldText = lsp:getText(uri)
    -- lua是从1开始的，因此都要+1
    local position = lines:positionAsChar(params.position.line + 1, params.position.character)

    local vm = lsp:getVM(uri)
    if not vm then
        vm = lsp:loadVM(uri)
        if not vm then
            return nil
        end
    end

    local items = core.completion(vm, text, position, oldText)
    if not items or #items == 0 then
        vm = lsp:loadVM(uri)
        if not vm then
            return nil
        end
        items = core.completion(vm, text, position)
        if not items or #items == 0 then
            return nil
        end
    end

    return items, position
end

local function finishCompletion(lsp, params, lines)
    local uri = params.textDocument.uri
    local text = lsp:getText(uri)
    -- lua是从1开始的，因此都要+1
    local position = lines:positionAsChar(params.position.line + 1, params.position.character)

    local vm = lsp:loadVM(uri)
    if not vm then
        return nil
    end

    local items = core.completion(vm, text, position)
    if not items or #items == 0 then
        return nil
    end

    return items
end

local function cuterFactory(lines, text, position)
    local start = position
    local head = ''
    for i = position, position - 100, -1 do
        if not text:sub(i, i):match '[%w_]' then
            start = i + 1
            head = text:sub(start, position)
            break
        end
    end
    return function (insertText)
        return {
            newText = insertText,
            range   = posToRange(lines, start, position)
        }
    end
end

--- @param lsp LSP
--- @param params table
--- @return table
return function (lsp, params)
    local uri = params.textDocument.uri
    local text, oldText = lsp:getText(uri)
    if not text then
        return nil
    end

    local lines = parser:lines(text, 'utf8')
    local items, position = fastCompletion(lsp, params, lines)
    --local items = finishCompletion(lsp, params, lines)
    if not items then
        return nil
    end

    -- TODO 在协议阶段将 `insertText` 转化为 `textEdit` ，
    -- 以避免不同客户端对 `insertText` 实现的不一致。
    -- 重构后直接在 core 中使用 `textEdit` 。
    local cuter = cuterFactory(lines, text, position)

    for i, item in ipairs(items) do
        item.sortText = ('%04d'):format(i)
        item.insertTextFormat = 2

        if item.textEdit then
            item.textEdit.range = posToRange(lines, item.textEdit.start, item.textEdit.finish)
            item.textEdit.start = nil
            item.textEdit.finish = nil
        else
            item.textEdit = cuter(item.insertText or item.label)
        end
        if item.additionalTextEdits then
            for _, textEdit in ipairs(item.additionalTextEdits) do
                textEdit.range = posToRange(lines, textEdit.start, textEdit.finish)
                textEdit.start = nil
                textEdit.finish = nil
            end
        end
    end

    local response = {
        isIncomplete = true,
        items = items,
    }

    return response
end
