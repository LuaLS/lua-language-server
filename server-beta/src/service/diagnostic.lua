local await  = require 'await'
local proto  = require 'proto.proto'
local define = require 'proto.define'
local lang   = require 'language'
local files  = require 'files'
local config = require 'config'

local m = {}

m.version = 0

local function concat(t, sep)
    if type(t) ~= 'table' then
        return t
    end
    return table.concat(t, sep)
end

local function buildSyntaxError(uri, err)
    local lines   = files.getLines(uri)
    local text    = files.getText(uri)
    local message = lang.script('PARSER_'..err.type, err.info)

    if err.version then
        local version = err.info and err.info.version or config.config.runtime.version
        message = message .. ('(%s)'):format(lang.script('DIAG_NEED_VERSION'
            , concat(err.version, '/')
            , version
        ))
    end

    local relative = err.info and err.info.relative
    local relatedInformation
    if relative then
        relatedInformation = {}
        for _, rel in ipairs(relative) do
            relatedInformation[#relatedInformation+1] = {
                message  = lang.script('PARSER_'..rel.message),
                location = define.location(uri, define.range(lines, text, rel.start, rel.finish)),
            }
        end
    end

    return {
        range    = define.range(lines, text, err.start, err.finish),
        severity = define.DiagnosticSeverity.Error,
        source   = lang.script.DIAG_SYNTAX_CHECK,
        message  = message,
        relatedInformation = relatedInformation,
    }
end

function m.doDiagnostic(uri)
    local ast = files.getAst(uri)
    if not ast then
        return
    end

    local diagnostics = {}

    for _, err in ipairs(ast.errs) do
        diagnostics[#diagnostics+1] = buildSyntaxError(uri, err)
    end

    proto.notify('textDocument/publishDiagnostics', {
        uri = uri,
        diagnostics = diagnostics,
    })

end

function m.refresh(uri)
    m.version = m.version + 1
    local myVersion = m.version
    await.create(function ()
        m.doDiagnostic(files.getOriginUri(uri))
        await.sleep(1.0)
        if myVersion ~= m.version then
            return
        end
        for destUri in files.eachFile() do
            if destUri ~= uri then
                m.doDiagnostic(files.getOriginUri(destUri))
                await.sleep(0.001)
                if myVersion ~= m.version then
                    return
                end
            end
        end
    end)
end

return m
