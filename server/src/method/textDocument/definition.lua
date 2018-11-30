local parser = require 'parser'
local matcher = require 'matcher'

return function (lsp, params)
    local start_clock = os.clock()
    local uri = params.textDocument.uri
    local ast, lines = lsp:loadText(uri)
    if not ast then
        return {}
    end
    -- lua是从1开始的，因此都要+1
    local position = lines:position(params.position.line + 1, params.position.character + 1, 'utf8')
    local suc, results = matcher.definition(ast, position)
    if not suc then
        return {}
    end

    local locations = {}
    for i, result in ipairs(results) do
        local start, finish = result[1], result[2]
        local start_row,  start_col  = lines:rowcol(start,  'utf8')
        local finish_row, finish_col = lines:rowcol(finish, 'utf8')
        locations[i] = {
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
            }
        }
    end

    local response = locations
    local passed_clock = os.clock() - start_clock
    if passed_clock >= 0.01 then
        log.warn(('[转到定义]耗时[%.3f]秒，文件大小[%s]字节'):format(passed_clock, #lines.buf))
    end

    return response
end
