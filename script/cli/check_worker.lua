local lclient   = require 'lclient'()
local furi      = require 'file-uri'
local ws        = require 'workspace'
local files     = require 'files'
local diag      = require 'provider.diagnostic'
local util      = require 'utility'
local jsonb     = require 'json-beautify'
local lang      = require 'language'
local define    = require 'proto.define'
local protoDiag = require 'proto.diagnostic'
local config    = require 'config.config'
local fs        = require 'bee.filesystem'
local provider  = require 'provider'
local await     = require 'await'
require 'plugin'
require 'vm'

local export = {}

local function clear_line()
    -- Write out empty space to ensure that the previous lien is cleared.
    io.write('\x0D', (' '):rep(80), '\x0D')
end

--- @param i integer
--- @param max integer
--- @param results table<string, table[]>
local function report_progress(i, max, results)
    local filesWithErrors = 0
    local errors = 0
    for _, diags in pairs(results) do
        filesWithErrors = filesWithErrors + 1
        errors = errors + #diags
    end

    clear_line()
    io.write(
        ('>'):rep(math.ceil(i / max * 20)),
        ('='):rep(20 - math.ceil(i / max * 20)),
        ' ',
        ('0'):rep(#tostring(max) - #tostring(i)),
        tostring(i),
        '/',
        tostring(max)
    )
    if errors > 0 then
        io.write(' [', lang.script('CLI_CHECK_PROGRESS', errors, filesWithErrors), ']')
    end
    io.flush()
end

--- @param uri string
--- @param checkLevel integer
local function apply_check_level(uri, checkLevel)
    local config_disables = util.arrayToHash(config.get(uri, 'Lua.diagnostics.disable'))
    local config_severities = config.get(uri, 'Lua.diagnostics.severity')
    for name, serverity in pairs(define.DiagnosticDefaultSeverity) do
        serverity = config_severities[name] or serverity
        if serverity:sub(-1) == '!' then
            serverity = serverity:sub(1, -2)
        end
        if define.DiagnosticSeverity[serverity] > checkLevel then
            config_disables[name] = true
        end
    end
    config.set(uri, 'Lua.diagnostics.disable', util.getTableKeys(config_disables, true))
end

local function downgrade_checks_to_opened(uri)
    local diagStatus = config.get(uri, 'Lua.diagnostics.neededFileStatus')
    for d, status in pairs(diagStatus) do
        if status == 'Any' or status == 'Any!' then
            diagStatus[d] = 'Opened!'
        end
    end
    for d, status in pairs(protoDiag.getDefaultStatus()) do
        if status == 'Any' or status == 'Any!' then
            diagStatus[d] = 'Opened!'
        end
    end
    config.set(uri, 'Lua.diagnostics.neededFileStatus', diagStatus)
end

function export.runCLI()
    lang(LOCALE)

    local numThreads = tonumber(NUM_THREADS or 1)
    local threadId = tonumber(THREAD_ID or 1)

    if type(CHECK_WORKER) ~= 'string' then
        print(lang.script('CLI_CHECK_ERROR_TYPE', type(CHECK_WORKER)))
        return
    end

    local rootPath = fs.absolute(fs.path(CHECK_WORKER)):string()
    local rootUri = furi.encode(rootPath)
    if not rootUri then
        print(lang.script('CLI_CHECK_ERROR_URI', rootPath))
        return
    end
    rootUri = rootUri:gsub("/$", "")

    if CHECKLEVEL and not define.DiagnosticSeverity[CHECKLEVEL] then
        print(lang.script('CLI_CHECK_ERROR_LEVEL', 'Error, Warning, Information, Hint'))
        return
    end
    local checkLevel = define.DiagnosticSeverity[CHECKLEVEL] or define.DiagnosticSeverity.Warning

    util.enableCloseFunction()

    local lastClock = os.clock()
    local results = {}  --- @type table<string, table[]>

    local function errorhandler(err)
        print(err)
        print(debug.traceback())
    end

    ---@async
    xpcall(lclient.start, errorhandler, lclient, function (client)
        await.disable()
        client:registerFakers()

        client:initialize {
            rootUri = rootUri,
        }

        client:register('textDocument/publishDiagnostics', function (params)
            results[params.uri] = params.diagnostics
        end)

        if not QUIET then
            io.write(lang.script('CLI_CHECK_INITING'))
        end

        provider.updateConfig(rootUri)

        ws.awaitReady(rootUri)

        -- Disable any diagnostics that are above the check level
        apply_check_level(rootUri, checkLevel)

        -- Downgrade file opened status to Opened for everything to avoid
        -- reporting during compilation on files that do not belong to this thread
        downgrade_checks_to_opened(rootUri)

        local uris = files.getChildFiles(rootUri)
        local max  = #uris
        table.sort(uris)    -- sort file list to ensure the work distribution order across multiple threads
        for i, uri in ipairs(uris) do
            if (i % numThreads + 1) == threadId then
                files.open(uri)
                diag.doDiagnostic(uri, true)
                -- Print regularly but always print the last entry to ensure
                -- that logs written to files don't look incomplete.
                if not QUIET and (os.clock() - lastClock > 0.2 or i == #uris) then
                    lastClock = os.clock()
                    client:update()
                    report_progress(i, max, results)
                end
            end
        end
        if not QUIET then
            io.write('\x0D')
        end
    end)

    local count = 0
    for uri, result in pairs(results) do
        count = count + #result
        if #result == 0 then
            results[uri] = nil
        end
    end

    local outpath = CHECK_OUT_PATH or LOGPATH .. '/check.json'

    -- Always write result, even if it's empty to make sure no one accidentally looks at an old output after a successful run.
    util.saveFile(outpath, jsonb.beautify(results))

    if not QUIET then
        if count == 0 then
            print(lang.script('CLI_CHECK_SUCCESS'))
        else
            print(lang.script('CLI_CHECK_RESULTS', count, outpath))
        end
    end
    return count == 0 and 0 or 1
end

return export
