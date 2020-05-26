local core = require 'core'

local timerCache = {}

local function convertRange(lines, range)
    local start_row,  start_col  = lines:rowcol(range.start)
    local finish_row, finish_col = lines:rowcol(range.finish)
    local result = {
        startLine      = start_row - 1,
        endLine        = finish_row - 2,
        kind           = range.kind,
    }
    if result.startLine >= result.endLine then
        return nil
    end
    return result
end

--- @param lsp LSP
--- @param params table
--- @return function
return function (lsp, params)
    local uri = params.textDocument.uri
    if timerCache[uri] then
        timerCache[uri]:remove()
        timerCache[uri] = nil
    end

    return function (response)
        local clock = os.clock()
        timerCache[uri] = ac.loop(0.1, function (t)
            local vm, lines = lsp:getVM(uri)
            if not vm then
                if os.clock() - clock > 10 then
                    t:remove()
                    timerCache[uri] = nil
                    response(nil)
                end
                return
            end

            t:remove()
            timerCache[uri] = nil

            local comments = lsp:getComments(uri)
            local ranges = core.foldingRange(vm, comments)
            if not ranges then
                response(nil)
                return
            end

            local results = {}
            for _, range in ipairs(ranges) do
                results[#results+1] = convertRange(lines, range)
            end

            response(results)
        end)
    end
end
