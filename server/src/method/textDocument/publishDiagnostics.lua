local matcher = require 'matcher'

local DiagnosticSeverity = {
    Error       = 1,
    Warning     = 2,
    Information = 3,
    Hint        = 4,
}

--[[
/**
 * Represents a related message and source code location for a diagnostic. This should be
 * used to point to code locations that cause or related to a diagnostics, e.g when duplicating
 * a symbol in a scope.
 */
export interface DiagnosticRelatedInformation {
    /**
     * The location of this related diagnostic information.
     */
    location: Location;

    /**
     * The message of this related diagnostic information.
     */
    message: string;
}
]]--

local function getRange(start, finish, lines)
    local start_row,  start_col  = lines:rowcol(start)
    local finish_row, finish_col = lines:rowcol(finish)
    return {
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
end

local function createInfo(data, lines)
    local diagnostic = {
        source   = 'Lua Language Server',
        range    = getRange(data.start, data.finish, lines),
        severity = DiagnosticSeverity[data.level],
        message  = data.message,
    }
    if data.related then
        local related = {}
        for i, info in ipairs(data.related) do
            local message = info.message
            if not message then
                local start_line  = lines:rowcol(info.start)
                local finish_line = lines:rowcol(info.finish)
                local chars = {}
                for n = start_line, finish_line do
                    chars[#chars+1] = lines:line(n)
                end
                message = table.concat(chars, '\n')
            end
            related[i] = {
                message = message,
                location = {
                    uri = info.uri,
                    range = getRange(info.start, info.finish, lines),
                }
            }
        end
        diagnostic.relatedInformation = related
    end
    return diagnostic
end

return function (lsp, params)
    local vm     = params.vm
    local lines  = params.lines
    local uri    = params.uri

    local diagnostics = {}
    if vm then
        local datas = matcher.diagnostics(vm, lines, uri)
        for _, data in ipairs(datas) do
            diagnostics[#diagnostics+1] = createInfo(data, lines)
        end
    end

    return diagnostics
end
