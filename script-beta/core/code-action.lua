local files   = require 'files'
local lang    = require 'language'
local define  = require 'proto.define'
local guide   = require 'parser.guide'
local library = require 'library'

local function disableDiagnostic(code, results)
    results[#results+1] = {
        title   = lang.script('ACTION_DISABLE_DIAG', code),
        kind    = 'quickfix',
        command = {
            title    = lang.script.COMMAND_DISABLE_DIAG,
            command  = 'lua.config',
            arguments = {
                {
                    key    = 'Lua.diagnostics.disable',
                    action = 'add',
                    value  = code,
                }
            }
        }
    }
end

local function markGlobal(name, results)
    results[#results+1] = {
        title   = lang.script('ACTION_MARK_GLOBAL', name),
        kind    = 'quickfix',
        command = {
            title     = lang.script.COMMAND_MARK_GLOBAL,
            command   = 'lua.config',
            arguments = {
                {
                    key    = 'Lua.diagnostics.globals',
                    action = 'add',
                    value  = name,
                }
            }
        }
    }
end

local function changeVersion(version, results)
    results[#results+1] = {
        title   = lang.script('ACTION_RUNTIME_VERSION', version),
        kind    = 'quickfix',
        command = {
            title     = lang.script.COMMAND_RUNTIME_VERSION,
            command   = 'lua.config',
            arguments = {
                {
                    key    = 'Lua.runtime.version',
                    action = 'set',
                    value  = version,
                }
            }
        },
    }
end

local function solveUndefinedGlobal(uri, diag, results)
    local ast    = files.getAst(uri)
    local text   = files.getText(uri)
    local lines  = files.getLines(uri)
    local offset = define.offsetOfWord(lines, text, diag.range.start)
    guide.eachSourceContain(ast.ast, offset, function (source)
        if source.type ~= 'getglobal' then
            return
        end

        local name = guide.getName(source)
        markGlobal(name, results)

        if library.other[name] then
            for _, version in ipairs(library.other[name]) do
                changeVersion(version, results)
            end
        end
    end)
end

local function solveDiagnostic(uri, diag, results)
    if diag.code == 'undefined-global' then
        solveUndefinedGlobal(uri, diag, results)
    end
    disableDiagnostic(diag.code, results)
end

return function (uri, range, diagnostics)
    local ast = files.getAst(uri)
    if not ast then
        return nil
    end

    local results = {}

    for _, data in ipairs(diagnostics) do
        solveDiagnostic(uri, data, results)
    end

    return results
end
