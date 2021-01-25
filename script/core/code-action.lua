local files   = require 'files'
local lang    = require 'language'
local define  = require 'proto.define'
local guide   = require 'parser.guide'
local util    = require 'utility'
local sp      = require 'bee.subprocess'
local vm      = require 'vm'

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
    local offset = files.offsetOfWord(uri, diag.range.start)
    guide.eachSourceContain(ast.ast, offset, function (source)
        if source.type ~= 'getglobal' then
            return
        end

        local name = guide.getKeyName(source)
        markGlobal(uri, name, results)
    end)

    if diag.data and diag.data.versions then
        for _, version in ipairs(diag.data.versions) do
            changeVersion(uri, version, results)
        end
    end
end

local function solveLowercaseGlobal(uri, diag, results)
    local ast    = files.getAst(uri)
    local offset = files.offsetOfWord(uri, diag.range.start)
    guide.eachSourceContain(ast.ast, offset, function (source)
        if source.type ~= 'setglobal' then
            return
        end

        local name = guide.getKeyName(source)
        markGlobal(uri, name, results)
    end)
end

local function findSyntax(uri, diag)
    local ast = files.getAst(uri)
    for _, err in ipairs(ast.errs) do
        if err.type:lower():gsub('_', '-') == diag.code then
            local range = files.range(uri, err.start, err.finish)
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
    results[#results+1] = {
        title = lang.script.ACTION_ADD_DO_END,
        kind = 'quickfix',
        edit = {
            changes = {
                [uri] = {
                    {
                        start   = err.start,
                        finish  = err.finish,
                        newText = ('do %s end'):format(text:sub(err.start, err.finish)),
                    },
                }
            }
        }
    }
end

local function solveSyntaxByFix(uri, err, results)
    local changes = {}
    for _, fix in ipairs(err.fix) do
        changes[#changes+1] = {
            start   = fix.start,
            finish  = fix.finish,
            newText = fix.text,
        }
    end
    results[#results+1] = {
        title = lang.script('ACTION_' .. err.fix.title, err.fix),
        kind  = 'quickfix',
        edit = {
            changes = {
                [uri] = changes,
            }
        }
    }
end

local function solveSyntaxUnicodeName(uri, err, results)
    results[#results+1] = {
        title   = lang.script('ACTION_RUNTIME_UNICODE_NAME'),
        kind    = 'quickfix',
        command = {
            title     = lang.script.COMMAND_UNICODE_NAME,
            command   = 'lua.config',
            arguments = {
                {
                    key    = 'Lua.runtime.unicodeName',
                    action = 'set',
                    value  = true,
                    uri    = uri,
                }
            }
        },
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
    if err.type == 'UNICODE_NAME' then
        solveSyntaxUnicodeName(uri, err, results)
    end
    if err.fix then
        solveSyntaxByFix(uri, err, results)
    end
end

local function solveNewlineCall(uri, diag, results)
    local start   = files.unrange(uri, diag.range)
    results[#results+1] = {
        title = lang.script.ACTION_ADD_SEMICOLON,
        kind = 'quickfix',
        edit = {
            changes = {
                [uri] = {
                    {
                        start  = start,
                        finish = start,
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

local function checkQuickFix(results, uri, diagnostics)
    if not diagnostics then
        return
    end
    for _, diag in ipairs(diagnostics) do
        solveDiagnostic(uri, diag, results)
    end
end

local function checkSwapParams(results, uri, start, finish)
    local ast  = files.getAst(uri)
    local text = files.getText(uri)
    if not ast then
        return
    end
    local args = {}
    guide.eachSourceBetween(ast.ast, start, finish, function (source)
        if source.type == 'callargs'
        or source.type == 'funcargs' then
            local targetIndex
            for index, arg in ipairs(source) do
                if arg.start - 1 <= finish and arg.finish >= start then
                    -- should select only one param
                    if targetIndex then
                        return
                    end
                    targetIndex = index
                end
            end
            if not targetIndex then
                return
            end
            local node
            if source.type == 'callargs' then
                node = text:sub(source.parent.node.start, source.parent.node.finish)
            elseif source.type == 'funcargs' then
                local var = source.parent.parent
                if vm.isSet(var) then
                    node = text:sub(var.start, var.finish)
                else
                    node = lang.script.SYMBOL_ANONYMOUS
                end
            end
            args[#args+1] = {
                source = source,
                index  = targetIndex,
                node   = node,
            }
        end
    end)
    if #args == 0 then
        return
    end
    table.sort(args, function (a, b)
        return a.source.start > b.source.start
    end)
    local target = args[1]
    uri = files.getOriginUri(uri)
    local myArg = target.source[target.index]
    for i, targetArg in ipairs(target.source) do
        if i ~= target.index then
            results[#results+1] = {
                title = lang.script('ACTION_SWAP_PARAMS', {
                    node  = target.node,
                    index = i,
                }),
                kind = 'refactor.rewrite',
                edit = {
                    changes = {
                        [uri] = {
                            {
                                start   = myArg.start,
                                finish  = myArg.finish,
                                newText = text:sub(targetArg.start, targetArg.finish),
                            },
                            {
                                start   = targetArg.start,
                                finish  = targetArg.finish,
                                newText = text:sub(myArg.start, myArg.finish),
                            },
                        }
                    }
                }
            }
        end
    end
end

--local function checkExtractAsFunction(results, uri, start, finish)
--    local ast = files.getAst(uri)
--    local text = files.getText(uri)
--    local funcs = {}
--    guide.eachSourceContain(ast.ast, start, function (source)
--        if source.type == 'function'
--        or source.type == 'main' then
--            funcs[#funcs+1] = source
--        end
--    end)
--    table.sort(funcs, function (a, b)
--        return a.start > b.start
--    end)
--    local func = funcs[1]
--    if not func then
--        return
--    end
--    if #func == 0 then
--        return
--    end
--    if func.finish < finish then
--        return
--    end
--    local actions = {}
--    for i = 1, #func do
--        local action = func[i]
--        if  action.start  < start
--        and action.finish > start then
--            return
--        end
--        if  action.start  < finish
--        and action.finish > finish then
--            return
--        end
--        if  action.finish >= start
--        and action.start  <= finish then
--            actions[#actions+1] = action
--        end
--    end
--    if text:sub(start, actions[1].start - 1):find '[%C%S]' then
--        return
--    end
--    if text:sub(actions[1].finish + 1, finish):find '[%C%S]' then
--        return
--    end
--    while func do
--        local funcName = getExtractFuncName(uri, actions[1].start)
--        local funcParams = getExtractFuncParams(uri, actions[1].start)
--        results[#results+1] = {
--            title = lang.script('ACTION_EXTRACT'),
--            kind = 'refactor.extract',
--            edit = {
--                changes = {
--                    [uri] = {
--                        {
--                            start   = actions[1].start,
--                            finish  = actions[1].start - 1,
--                            newText = text:sub(targetArg.start, targetArg.finish),
--                        },
--                        {
--                            start   = targetArg.start,
--                            finish  = targetArg.finish,
--                            newText = text:sub(myArg.start, myArg.finish),
--                        },
--                    }
--                }
--            }
--        }
--        func = guide.getParentFunction(func)
--    end
--end

return function (uri, start, finish, diagnostics)
    local ast = files.getAst(uri)
    if not ast then
        return nil
    end

    local results = {}

    checkQuickFix(results, uri, diagnostics)
    checkSwapParams(results, uri, start, finish)
    --checkExtractAsFunction(results, uri, start, finish)

    return results
end
