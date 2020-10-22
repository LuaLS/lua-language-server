local files   = require 'files'
local lang    = require 'language'
local define  = require 'proto.define'
local guide   = require 'parser.guide'
local library = require 'library'
local util    = require 'utility'
local sp      = require 'bee.subprocess'

local function disableDiagnostic(uri, code, results)
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
                    uri    = uri,
                }
            }
        }
    }
end

local function markGlobal(uri, name, results)
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
                    uri    = uri,
                }
            }
        }
    }
end

local function changeVersion(uri, version, results)
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
                    uri    = uri,
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
        markGlobal(uri, name, results)

        if library.other[name] then
            for _, version in ipairs(library.other[name]) do
                changeVersion(uri, version, results)
            end
        end
    end)
end

local function solveLowercaseGlobal(uri, diag, results)
    local ast    = files.getAst(uri)
    local text   = files.getText(uri)
    local lines  = files.getLines(uri)
    local offset = define.offsetOfWord(lines, text, diag.range.start)
    guide.eachSourceContain(ast.ast, offset, function (source)
        if source.type ~= 'setglobal' then
            return
        end

        local name = guide.getName(source)
        markGlobal(uri, name, results)
    end)
end

local function findSyntax(uri, diag)
    local ast    = files.getAst(uri)
    local text   = files.getText(uri)
    local lines  = files.getLines(uri)
    for _, err in ipairs(ast.errs) do
        if err.type:lower():gsub('_', '-') == diag.code then
            local range = define.range(lines, text, err.start, err.finish)
            if util.equal(range, diag.range) then
                return err
            end
        end
    end
    return nil
end

local function solveSyntaxByChangeVersion(uri, err, results)
    if type(err.version) == 'table' then
        for _, version in ipairs(err.version) do
            changeVersion(uri, version, results)
        end
    else
        changeVersion(uri, err.version, results)
    end
end

local function solveSyntaxByAddDoEnd(uri, err, results)
    local text   = files.getText(uri)
    local lines  = files.getLines(uri)
    results[#results+1] = {
        title = lang.script.ACTION_ADD_DO_END,
        kind = 'quickfix',
        edit = {
            changes = {
                [uri] = {
                    {
                        range   = define.range(lines, text, err.start, err.finish),
                        newText = ('do %s end'):format(text:sub(err.start, err.finish)),
                    },
                }
            }
        }
    }
end

local function solveSyntaxByFix(uri, err, results)
    local text    = files.getText(uri)
    local lines   = files.getLines(uri)
    local changes = {}
    for _, fix in ipairs(err.fix) do
        changes[#changes+1] = {
            range = define.range(lines, text, fix.start, fix.finish),
            newText = fix.text,
        }
    end
    results[#results+1] = {
        title = lang.script['ACTION_' .. err.fix.title],
        kind  = 'quickfix',
        edit = {
            changes = {
                [uri] = changes,
            }
        }
    }
end

local function solveSyntax(uri, diag, results)
    local err = findSyntax(uri, diag)
    if not err then
        return
    end
    if err.version then
        solveSyntaxByChangeVersion(uri, err, results)
    end
    if err.type == 'ACTION_AFTER_BREAK' or err.type == 'ACTION_AFTER_RETURN' then
        solveSyntaxByAddDoEnd(uri, err, results)
    end
    if err.fix then
        solveSyntaxByFix(uri, err, results)
    end
end

local function solveNewlineCall(uri, diag, results)
    local text    = files.getText(uri)
    local lines   = files.getLines(uri)
    results[#results+1] = {
        title = lang.script.ACTION_ADD_SEMICOLON,
        kind = 'quickfix',
        edit = {
            changes = {
                [uri] = {
                    {
                        range = {
                            start   = diag.range.start,
                            ['end'] = diag.range.start,
                        },
                        newText = ';',
                    }
                }
            }
        }
    }
end

local function solveAmbiguity1(uri, diag, results)
    results[#results+1] = {
        title = lang.script.ACTION_ADD_BRACKETS,
        kind = 'quickfix',
        command = {
            title = lang.script.COMMAND_ADD_BRACKETS,
            command = 'lua.solve:' .. sp:get_id(),
            arguments = {
                {
                    name  = 'ambiguity-1',
                    uri   = uri,
                    range = diag.range,
                }
            }
        },
    }
end

local function solveTrailingSpace(uri, diag, results)
    results[#results+1] = {
        title = lang.script.ACTION_REMOVE_SPACE,
        kind = 'quickfix',
        command = {
            title = lang.script.COMMAND_REMOVE_SPACE,
            command = 'lua.removeSpace:' .. sp:get_id(),
            arguments = {
                {
                    uri = uri,
                }
            }
        },
    }
end

local function solveDiagnostic(uri, diag, results)
    if diag.source == lang.script.DIAG_SYNTAX_CHECK then
        solveSyntax(uri, diag, results)
        return
    end
    if not diag.code then
        return
    end
    if     diag.code == 'undefined-global' then
        solveUndefinedGlobal(uri, diag, results)
    elseif diag.code == 'lowercase-global' then
        solveLowercaseGlobal(uri, diag, results)
    elseif diag.code == 'newline-call' then
        solveNewlineCall(uri, diag, results)
    elseif diag.code == 'ambiguity-1' then
        solveAmbiguity1(uri, diag, results)
    elseif diag.code == 'trailing-space' then
        solveTrailingSpace(uri, diag, results)
    end
    disableDiagnostic(uri, diag.code, results)
end

return function (uri, range, diagnostics)
    local ast = files.getAst(uri)
    if not ast then
        return nil
    end

    local results = {}

    for _, diag in ipairs(diagnostics) do
        solveDiagnostic(uri, diag, results)
    end

    return results
end
