local lclient = require 'lclient'
local furi    = require 'file-uri'
local ws      = require 'workspace'
local files   = require 'files'
local diag    = require 'provider.diagnostic'
local util    = require 'utility'
local json    = require 'json-beautify'
local lang    = require 'language'
local define  = require 'proto.define'
local config  = require 'config.config'

if type(CHECK) ~= 'string' then
    print(('The argument of CHECK must be a string, but got %s'):format(type(CHECK)))
end

local rootUri = furi.encode(CHECK)
if not rootUri then
    print(('The argument of CHECK must be a valid uri, but got %s'):format(CHECK))
end

util.enableCloseFunction()

local lastClock   = os.clock()
local results = {}
---@async
lclient():start(function (client)
    client:registerFakers()

    client:initialize {
        rootUri = rootUri,
    }

    client:register('textDocument/publishDiagnostics', function (params)
        results[params.uri] = params.diagnostics
    end)

    ws.awaitReady(rootUri)

    local checkLevel = define.DiagnosticSeverity[CHECKLEVEL] or define.DiagnosticSeverity.Warning
    local disables   = config.get(rootUri, 'Lua.diagnostics.disable')
    for name, serverity in pairs(define.DiagnosticDefaultSeverity) do
        serverity = config.get(rootUri, 'Lua.diagnostics.severity')[name] or 'Warning'
        if define.DiagnosticSeverity[serverity] > checkLevel then
            disables[name] = true
        end
    end
    config.set(nil, 'Lua.diagnostics.disable', disables)

    local uris = files.getAllUris(rootUri)
    local max  = #uris
    for i, uri in ipairs(uris) do
        files.open(uri)
        diag.doDiagnostic(uri, true)
        if os.clock() - lastClock > 0.2 then
            lastClock = os.clock()
            print(('%d/%d'):format(i, max))
        end
    end
end)

local count = 0
for uri, result in pairs(results) do
    count = count + #result
    if #result == 0 then
        results[uri] = nil
    end
end

if count == 0 then
    print(lang.script('CLI_CHECK_SUCCESS'))
else
    local outpath = LOGPATH .. '/check.json'
    util.saveFile(outpath, json.beautify(results))

    print(lang.script('CLI_CHECK_RESULTS', count, outpath))
end
