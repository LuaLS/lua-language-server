local await  = require 'await'
local proto  = require 'proto.proto'
local define = require 'proto.define'
local lang   = require 'language'
local files  = require 'files'
local config = require 'config'
local core   = require 'core.diagnostics'

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

    local related = err.info and err.info.related
    local relatedInformation
    if related then
        relatedInformation = {}
        for _, rel in ipairs(related) do
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

local function buildDiagnostic(uri, diag)
    local lines = files.getLines(uri)
    local text  = files.getText(uri)

    local relatedInformation
    if diag.related then
        relatedInformation = {}
        for _, rel in ipairs(diag.related) do
            local rtext  = files.getText(rel.uri)
            local rlines = files.getLines(rel.uri)
            relatedInformation[#relatedInformation+1] = {
                message  = rel.message or rtext:sub(rel.start, rel.finish),
                location = define.location(rel.uri, define.range(rlines, rtext, rel.start, rel.finish))
            }
        end
    end
    
    return {
        range    = define.range(lines, text, diag.start, diag.finish),
        source   = lang.script.DIAG_DIAGNOSTICS,
        severity = diag.level,
        message  = diag.message,
        code     = diag.code,
        tags     = diag.tags,
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

    local diags = core(uri)
    for _, diag in ipairs(diags) do
        diagnostics[#diagnostics+1] = buildDiagnostic(uri, diag)
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
        if uri then
            m.doDiagnostic(files.getOriginUri(uri))
        end
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
