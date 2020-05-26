local core = require 'core'
local lang = require 'language'
local config = require 'config'

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

local function createInfo(lsp, data, lines)
    local diagnostic = {
        source   = lang.script.DIAG_DIAGNOSTICS,
        range    = getRange(data.start, data.finish, lines),
        severity = data.level,
        message  = data.message,
        code     = data.code,
        tags     = data.tags,
    }
    if data.related then
        local related = {}
        for _, info in ipairs(data.related) do
            local _, lines = lsp:getVM(info.uri)
            if lines then
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
                related[#related+1] = {
                    message = message,
                    location = {
                        uri = info.uri,
                        range = getRange(info.start, info.finish, lines),
                    }
                }
            end
        end
        diagnostic.relatedInformation = related
    end
    return diagnostic
end

local function buildError(err, lines, uri)
    local diagnostic = {
        source  = lang.script.DIAG_SYNTAX_CHECK,
        message = lang.script('PARSER_'..err.type, err.info)
    }
    if err.version then
        local currentVersion = err.info and err.info.version or config.config.runtime.version
        if type(err.version) == 'table' then
            diagnostic.message = ('%s(%s)'):format(diagnostic.message, lang.script('DIAG_NEED_VERSION', table.concat(err.version, '/'), currentVersion))
        else
            diagnostic.message = ('%s(%s)'):format(diagnostic.message, lang.script('DIAG_NEED_VERSION', err.version, currentVersion))
        end
    end
    if err.level == 'error' then
        diagnostic.severity = DiagnosticSeverity.Error
    else
        diagnostic.severity = DiagnosticSeverity.Warning
    end
    local startrow, startcol = lines:rowcol(err.start)
    local endrow, endcol = lines:rowcol(err.finish)
    if err.type == 'UNKNOWN' then
        local _, max = lines:range(endrow)
        endcol = max
    end
    local range = {
        start = {
            line = startrow - 1,
            character = startcol - 1,
        },
        ['end'] = {
            line = endrow - 1,
            character = endcol,
        },
    }
    diagnostic.range = range

    local related = err.info and err.info.related
    if related then
        local start_line  = lines:rowcol(related[1])
        local finish_line = lines:rowcol(related[2])
        local chars = {}
        for n = start_line, finish_line do
            chars[#chars+1] = lines:line(n)
        end
        local message = table.concat(chars, '\n')
        diagnostic.relatedInformation = {
            {
                message = message,
                location = {
                    uri = uri,
                    range = getRange(related[1], related[2], lines),
                }
            }
        }
    end
    return diagnostic
end

--- @param lsp LSP
--- @param params table
--- @return table
return function (lsp, params)
    local vm     = params.vm
    local lines  = params.lines
    local uri    = params.uri
    local errs   = lsp:getAstErrors(uri)

    local diagnostics = {}
    if vm then
        local datas = core.diagnostics(vm, lines, uri)
        for _, data in ipairs(datas) do
            diagnostics[#diagnostics+1] = createInfo(lsp, data, lines)
        end
    end
    if errs then
        for _, err in ipairs(errs) do
            diagnostics[#diagnostics+1] = buildError(err, lines, uri)
        end
    end

    return diagnostics
end
