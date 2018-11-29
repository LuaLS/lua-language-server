local parser = require 'parser'
local matcher = require 'matcher'

return function (lsp, params)
    local uri = params.textDocument.uri
    local text = lsp:loadText(uri)
    if not text then
        return nil, '找不到文件：' .. uri
    end
    local start_clock = os.clock()
    local ast, err = parser:ast(text)
    local lines    = parser:lines(text)
    if not ast then
        return nil, err
    end
    -- lua是从1开始的，因此都要+1
    local position = lines:position(params.position.line + 1, params.position.character + 1)
    local suc, start, finish = matcher.definition(ast, position, 'utf8')
    if not suc then
        if finish then
            log.debug(start, uri)
            finish.lua = nil
            log.debug(table.dump(finish))
        end
        return {}
    end

    local start_row,  start_col  = lines:rowcol(start,  'utf8')
    local finish_row, finish_col = lines:rowcol(finish, 'utf8')

    local response = {
        uri = uri,
        range = {
            start = {
                line = start_row - 1,
                character = start_col - 1,
            },
            ['end'] = {
                line = finish_row - 1,
                -- 这里不用-1，因为前端期待的是匹配完成后的位置
                character = finish_col,
            },
        },
    }
    local passed_clock = os.clock() - start_clock
    if passed_clock >= 0.01 then
        log.warn(('[转到定义]耗时[%.3f]秒，文件大小[%s]字节'):format(passed_clock, #text))
    end

    return response
end
