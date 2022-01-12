local await     = require 'await'
local proto     = require 'proto.proto'
local define    = require 'proto.define'
local lang      = require 'language'
local files     = require 'files'
local config    = require 'config'
local core      = require 'core.diagnostics'
local util      = require 'utility'
local ws        = require 'workspace'
local progress  = require "progress"
local client    = require 'client'
local converter = require 'proto.converter'

---@class diagnosticProvider
local m = {}
m.cache = {}
m.sleepRest = 0.0

local function concat(t, sep)
    if type(t) ~= 'table' then
        return t
    end
    return table.concat(t, sep)
end

local function buildSyntaxError(uri, err)
    local text    = files.getText(uri)
    local message = lang.script('PARSER_'..err.type, err.info)

    if err.version then
        local version = err.info and err.info.version or config.get(uri, 'Lua.runtime.version')
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
            local relUri = rel.uri or uri
            relatedInformation[#relatedInformation+1] = {
                message  = rmessage,
                location = converter.location(relUri, converter.packRange(relUri, rel.start, rel.finish)),
            }
        end
    end

    return {
        code     = err.type:lower():gsub('_', '-'),
        range    = converter.packRange(uri, err.start, err.finish),
        severity = define.DiagnosticSeverity[err.level],
        source   = lang.script.DIAG_SYNTAX_CHECK,
        message  = message,
        relatedInformation = relatedInformation,
        data     = 'syntax',
    }
end

local function buildDiagnostic(uri, diag)
    if not files.exists(uri) then
        return
    end

    local relatedInformation
    if diag.related then
        relatedInformation = {}
        for _, rel in ipairs(diag.related) do
            local rtext  = files.getText(rel.uri)
            relatedInformation[#relatedInformation+1] = {
                message  = rel.message or rtext:sub(rel.start, rel.finish),
                location = converter.location(rel.uri, converter.packRange(rel.uri, rel.start, rel.finish))
            }
        end
    end

    return {
        range    = converter.packRange(uri, diag.start, diag.finish),
        source   = lang.script.DIAG_DIAGNOSTICS,
        severity = diag.level,
        message  = diag.message,
        code     = diag.code,
        tags     = diag.tags,
        data     = diag.data,
        relatedInformation = relatedInformation,
    }
end

local function mergeDiags(a, b, c)
    if not a and not b and not c then
        return nil
    end
    local t = {}

    local function merge(diags)
        if not diags then
            return
        end
        for i = 1, #diags do
            local diag = diags[i]
            local severity = diag.severity
            if severity == define.DiagnosticSeverity.Hint
            or severity == define.DiagnosticSeverity.Information then
                if #t > 10000 then
                    goto CONTINUE
                end
            end
            t[#t+1] = diag
            ::CONTINUE::
        end
    end

    merge(a)
    merge(b)
    merge(c)

    return t
end

function m.clear(uri)
    await.close('diag:' .. uri)
    if not m.cache[uri] then
        return
    end
    m.cache[uri] = nil
    proto.notify('textDocument/publishDiagnostics', {
        uri = uri,
        diagnostics = {},
    })
    log.debug('clearDiagnostics', uri)
end

function m.clearCache(uri)
    m.cache[uri] = false
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

    pcall(function ()
        local disables = config.get(uri, 'Lua.diagnostics.disable')
        for _, err in ipairs(ast.errs) do
            if not disables[err.type:lower():gsub('_', '-')] then
                results[#results+1] = buildSyntaxError(uri, err)
            end
        end
    end)

    return results
end

local function copyDiagsWithoutSyntax(diags)
    if not diags then
        return nil
    end
    local copyed = {}
    for _, diag in ipairs(diags) do
        if diag.data ~= 'syntax' then
            copyed[#copyed+1] = diag
        end
    end
    return copyed
end

---@async
function m.doDiagnostic(uri, isScopeDiag)
    if not config.get(uri, 'Lua.diagnostics.enable') then
        return
    end
    if files.isLibrary(uri) then
        local status = config.get(uri, 'Lua.diagnostics.libraryFiles')
        if status == 'Disable' then
            return
        elseif status == 'Opened' then
            if not files.isOpen(uri) then
                return
            end
        end
    end
    if ws.isIgnored(uri) then
        local status = config.get(uri, 'Lua.diagnostics.ignoredFiles')
        if status == 'Disable' then
            return
        elseif status == 'Opened' then
            if not files.isOpen(uri) then
                return
            end
        end
    end

    await.delay()

    local state = files.getState(uri)
    if not state then
        m.clear(uri)
        return
    end

    local version = files.getVersion(uri)
    local scp = ws.getScope(uri)

    local prog <close> = progress.create(scp, lang.script.WINDOW_DIAGNOSING, 0.5)
    prog:setMessage(ws.getRelativePath(uri))

    local syntax = m.syntaxErrors(uri, state)

    local diags = {}
    local lastDiag = copyDiagsWithoutSyntax(m.cache[uri])
    local function pushResult()
        tracy.ZoneBeginN 'mergeSyntaxAndDiags'
        local _ <close> = tracy.ZoneEnd
        local full = mergeDiags(syntax, lastDiag, diags)
        if not full then
            m.clear(uri)
            return
        end

        if util.equal(m.cache[uri], full) then
            return
        end
        m.cache[uri] = full

        proto.notify('textDocument/publishDiagnostics', {
            uri = uri,
            version = version,
            diagnostics = full,
        })
        if #full > 0 then
            log.debug('publishDiagnostics', uri, #full)
        end
    end

    pushResult()

    local lastPushClock = os.clock()
    ---@async
    xpcall(core, log.error, uri, isScopeDiag, function (result)
        diags[#diags+1] = buildDiagnostic(uri, result)

        if not isScopeDiag and os.clock() - lastPushClock >= 0.2 then
            lastPushClock = os.clock()
            pushResult()
        end
    end, function (checkedName)
        if not lastDiag then
            return
        end
        for i, diag in ipairs(lastDiag) do
            if diag.code == checkedName then
                lastDiag[i] = lastDiag[#lastDiag]
                lastDiag[#lastDiag] = nil
            end
        end
    end)

    lastDiag = nil
    pushResult()
end

function m.refresh(uri)
    if not ws.isReady(uri) then
        return
    end
    await.close('diag:' .. uri)
    await.call(function () ---@async
        if uri then
            await.setID('diag:' .. uri)
            await.sleep(0.1)
            xpcall(m.doDiagnostic, log.error, uri)
        end
        m.diagnosticsScope(uri)
    end, 'files.version')
end

---@async
local function askForDisable(uri)
    if m.dontAskedForDisable then
        return
    end
    local delay = 30
    local delayTitle = lang.script('WINDOW_DELAY_WS_DIAGNOSTIC', delay)
    local item = proto.awaitRequest('window/showMessageRequest', {
        type    = define.MessageType.Info,
        message = lang.script.WINDOW_SETTING_WS_DIAGNOSTIC,
        actions = {
            {
                title = lang.script.WINDOW_DONT_SHOW_AGAIN,
            },
            {
                title = delayTitle,
            },
            {
                title = lang.script.WINDOW_DISABLE_DIAGNOSTIC,
            },
        }
    })
    if not item then
        return
    end
    if     item.title == lang.script.WINDOW_DONT_SHOW_AGAIN then
        m.dontAskedForDisable = true
    elseif item.title == delayTitle then
        client.setConfig {
            {
                key    = 'Lua.diagnostics.workspaceDelay',
                action = 'set',
                value  = delay * 1000,
                uri    = uri,
            }
        }
    elseif item.title == lang.script.WINDOW_DISABLE_DIAGNOSTIC then
        client.setConfig {
            {
                key    = 'Lua.diagnostics.workspaceDelay',
                action = 'set',
                value  = -1,
                uri    = uri,
            }
        }
    end
end

function m.diagnosticsScope(uri, force)
    if not ws.isReady(uri) then
        return
    end
    if not force and not config.get(uri, 'Lua.diagnostics.enable') then
        m.clearAll()
        return
    end
    local delay = config.get(uri, 'Lua.diagnostics.workspaceDelay') / 1000
    if not force and delay < 0 then
        return
    end
    await.close ('diagnosticsScope:' .. uri)
    await.call(function () ---@async
        await.sleep(math.max(delay, 0.1))
        local clock = os.clock()
        local bar <close> = progress.create(ws.getScope(uri), lang.script.WORKSPACE_DIAGNOSTIC, 1)
        local cancelled
        bar:onCancel(function ()
            log.debug('Cancel workspace diagnostics')
            cancelled = true
            ---@async
            await.call(function ()
                askForDisable(uri)
            end)
        end)
        local uris = files.getAllUris()
        for i, uri in ipairs(uris) do
            bar:setMessage(('%d/%d'):format(i, #uris))
            bar:setPercentage(i / #uris * 100)
            xpcall(m.doDiagnostic, log.error, uri, true)
            await.delay()
            if cancelled then
                log.debug('Break workspace diagnostics')
                break
            end
        end
        bar:remove()
        log.debug('全文诊断耗时：', os.clock() - clock)
    end, 'files.version', ('diagnosticsScope:' .. uri))
end

ws.watch(function (ev, uri)
    if ev == 'reload' then
        m.diagnosticsScope(uri)
    end
end)

files.watch(function (ev, uri) ---@async
    if ev == 'remove' then
        m.clear(uri)
        m.refresh(uri)
    elseif ev == 'update' then
        if ws.isReady(uri) then
            m.refresh(uri)
        end
    elseif ev == 'open' then
        if ws.isReady(uri) then
            xpcall(m.doDiagnostic, log.error, uri)
        end
    elseif ev == 'close' then
        if files.isLibrary(uri)
        or ws.isIgnored(uri) then
            m.clear(uri)
        end
    end
end)

config.watch(function (uri, key, value, oldValue)
    if key:find 'Lua.diagnostics' then
        if value ~= oldValue then
            m.diagnosticsScope(uri)
        end
    end
end)

return m
