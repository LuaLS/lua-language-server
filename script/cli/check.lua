local lclient  = require 'lclient'
local furi     = require 'file-uri'
local ws       = require 'workspace'
local files    = require 'files'
local diag     = require 'provider.diagnostic'
local util     = require 'utility'
local jsonb    = require 'json-beautify'
local lang     = require 'language'
local define   = require 'proto.define'
local config   = require 'config.config'
local fs       = require 'bee.filesystem'
local provider = require 'provider'

require 'vm'

lang(LOCALE)

if type(CHECK) ~= 'string' then
    print(lang.script('CLI_CHECK_ERROR_TYPE', type(CHECK)))
    return
end

local rootPath = fs.absolute(fs.path(CHECK)):string()
local rootUri = furi.encode(rootPath)
if not rootUri then
    print(lang.script('CLI_CHECK_ERROR_URI', rootPath))
    return
end

if CHECKLEVEL then
    if not define.DiagnosticSeverity[CHECKLEVEL] then
        print(lang.script('CLI_CHECK_ERROR_LEVEL', 'Error, Warning, Information, Hint'))
        return
    end
end
local checkLevel = define.DiagnosticSeverity[CHECKLEVEL] or define.DiagnosticSeverity.Warning

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

    io.write(lang.script('CLI_CHECK_INITING'))

    provider.updateConfig(rootUri)

    ws.awaitReady(rootUri)

    local disables = util.arrayToHash(config.get(rootUri, 'Lua.diagnostics.disable'))
    for name, serverity in pairs(define.DiagnosticDefaultSeverity) do
        serverity = config.get(rootUri, 'Lua.diagnostics.severity')[name] or 'Warning'
        if serverity:sub(-1) == '!' then
            serverity = serverity:sub(1, -2)
        end
        if define.DiagnosticSeverity[serverity] > checkLevel then
            disables[name] = true
        end
    end
    config.set(rootUri, 'Lua.diagnostics.disable', util.getTableKeys(disables, true))

    local uris = files.getAllUris(rootUri)
    local max  = #uris
    for i, uri in ipairs(uris) do
        files.open(uri)
        diag.doDiagnostic(uri, true)
        if os.clock() - lastClock > 0.2 then
            lastClock = os.clock()
            local output = '\x0D'
                        .. ('>'):rep(math.ceil(i / max * 20))
                        .. ('='):rep(20 - math.ceil(i / max * 20))
                        .. ' '
                        .. ('0'):rep(#tostring(max) - #tostring(i))
                        .. tostring(i) .. '/' .. tostring(max)
            io.write(output)
        end
    end
    io.write('\x0D')
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
    local outpath = CHECK_OUT_PATH
    if outpath == nil then
        outpath = LOGPATH .. '/check.json'
    end
    util.saveFile(outpath, jsonb.beautify(results))

    print(lang.script('CLI_CHECK_RESULTS', count, outpath))
end
