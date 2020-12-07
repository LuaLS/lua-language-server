local await  = require 'await'
local proto  = require 'proto.proto'
local define = require 'proto.define'
local lang   = require 'language'
local files  = require 'files'
local config = require 'config'
local core   = require 'core.diagnostics'
local util   = require 'utility'
local ws     = require 'workspace'

local m = {}
m._start = false
m.cache = {}
m.sleepRest = 0.0

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
            local rmessage
            if rel.message then
                rmessage = lang.script('PARSER_'..rel.message)
            else
                rmessage = text:sub(rel.start, rel.finish)
            end
            relatedInformation[#relatedInformation+1] = {
                message  = rmessage,
                location = define.location(uri, define.range(lines, text, rel.start, rel.finish)),
            }
        end
    end

    return {
        code     = err.type:lower():gsub('_', '-'),
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
        data     = diag.data,
        relatedInformation = relatedInformation,
    }
end

local function merge(a, b)
    if not a and not b then
        return nil
    end
    local t = {}
    if a then
        for i = 1, #a do
            if #t >= 100 then
                break
            end
            t[#t+1] = a[i]
        end
    end
    if b then
        for i = 1, #b do
            if #t >= 100 then
                break
            end
            t[#t+1] = b[i]
        end
    end
    return t
end

function m.clear(uri)
    local luri = files.asKey(uri)
    if not m.cache[luri] then
        return
    end
    m.cache[luri] = nil
    proto.notify('textDocument/publishDiagnostics', {
        uri = files.getOriginUri(luri) or uri,
        diagnostics = {},
    })
    log.debug('clearDiagnostics', files.getOriginUri(uri))
end

function m.clearAll()
    for luri in pairs(m.cache) do
        m.clear(luri)
    end
end

function m.syntaxErrors(uri, ast)
    if #ast.errs == 0 then
        return nil
    end

    local results = {}

    for _, err in ipairs(ast.errs) do
        if not config.config.diagnostics.disable[err.type:lower():gsub('_', '-')] then
            results[#results+1] = buildSyntaxError(uri, err)
        end
    end

    return results
end

function m.diagnostics(uri, diags)
    if not m._start then
        return
    end

    core(uri, function (results)
        if #results == 0 then
            return
        end
        for i = 1, #results do
            diags[#diags+1] = buildDiagnostic(uri, results[i])
        end
    end)
end

function m.doDiagnostic(uri)
    if not config.config.diagnostics.enable then
        return
    end
    uri = files.asKey(uri)
    if (files.isLibrary(uri) or ws.isIgnored(uri))
    and not files.isOpen(uri) then
        return
    end

    await.delay()

    local ast = files.getAst(uri)
    if not ast then
        m.clear(uri)
        return
    end

    local syntax = m.syntaxErrors(uri, ast)
    local diags = {}

    local function pushResult()
        local full = merge(syntax, diags)
        if not full then
            m.clear(uri)
            return
        end

        if util.equal(m.cache[uri], full) then
            return
        end
        m.cache[uri] = full

        proto.notify('textDocument/publishDiagnostics', {
            uri = files.getOriginUri(uri),
            diagnostics = full,
        })
        if #full > 0 then
            log.debug('publishDiagnostics', files.getOriginUri(uri), #full)
        end
    end

    if await.hasID 'diagnosticsAll' then
        m.checkStepResult = nil
    else
        local clock = os.clock()
        m.checkStepResult = function ()
            if os.clock() - clock >= 0.2 then
                pushResult()
                clock = os.clock()
            end
        end
    end

    m.diagnostics(uri, diags)
    pushResult()
    m.checkStepResult = nil
end

function m.refresh(uri)
    if not m._start then
        return
    end
    await.call(function ()
        if uri then
            m.doDiagnostic(uri)
        end
        m.diagnosticsAll()
    end, 'files.version')
end

function m.diagnosticsAll()
    if not config.config.diagnostics.enable then
        m.clearAll()
        return
    end
    if not m._start then
        return
    end
    local delay = config.config.diagnostics.workspaceDelay / 1000
    if delay < 0 then
        return
    end
    await.close 'diagnosticsAll'
    await.call(function ()
        await.sleep(delay)
        m.diagnosticsAllClock = os.clock()
        local clock = os.clock()
        for uri in files.eachFile() do
            m.doDiagnostic(uri)
            await.delay()
        end
        log.debug('全文诊断耗时：', os.clock() - clock)
    end, 'files.version', 'diagnosticsAll')
end

function m.start()
    m._start = true
    m.diagnosticsAll()
end

function m.checkStepResult()
    if await.hasID 'diagnosticsAll' then
        return
    end
end

function m.checkWorkspaceDiag()
    if not await.hasID 'diagnosticsAll' then
        return
    end
    local speedRate = config.config.diagnostics.workspaceRate
    if speedRate <= 0 or speedRate >= 100 then
        return
    end
    local currentClock = os.clock()
    local passed = currentClock - m.diagnosticsAllClock
    local sleepTime = passed * (100 - speedRate) / speedRate + m.sleepRest
    m.sleepRest = 0.0
    if sleepTime < 0.001 then
        m.sleepRest = m.sleepRest + sleepTime
        return
    end
    if sleepTime > 0.1 then
        m.sleepRest = sleepTime - 0.1
        sleepTime = 0.1
    end
    await.sleep(sleepTime)
    m.diagnosticsAllClock = os.clock()
    return false
end

files.watch(function (ev, uri)
    if ev == 'remove' then
        m.clear(uri)
    elseif ev == 'update' then
        m.refresh(uri)
    elseif ev == 'open' then
        m.doDiagnostic(uri)
    elseif ev == 'close' then
        if files.isLibrary(uri)
        or ws.isIgnored(uri) then
            m.clear(uri)
        end
    end
end)

await.watch(function (ev, co)
    if ev == 'delay' then
        if m.checkStepResult then
            m.checkStepResult()
        end
        return m.checkWorkspaceDiag()
    end
end)

return m
