local files     = require 'files'
local lang      = require 'language'
local util      = require 'utility'
local sp        = require 'bee.subprocess'
local guide     = require "parser.guide"
local converter = require 'proto.converter'
local autoreq   = require 'core.completion.auto-require'
local rpath     = require 'workspace.require-path'
local furi      = require 'file-uri'
local undefined = require 'core.diagnostics.undefined-global'
local vm        = require 'vm'

---@param uri  uri
---@param row  integer
---@param mode string
---@param code string
local function checkDisableByLuaDocExits(uri, row, mode, code)
    if row < 0 then
        return nil
    end
    local state = files.getState(uri)
    if not state then
        return nil
    end
    local lines = state.lines
    if state.ast.docs and lines then
        return guide.eachSourceBetween(
            state.ast.docs,
            guide.positionOf(row, 0),
            guide.positionOf(row + 1, 0),
            function (doc)
                if  doc.type == 'doc.diagnostic'
                and doc.mode == mode then
                    if doc.names then
                        return {
                            start   = doc.finish,
                            finish  = doc.finish,
                            newText = ', ' .. code,
                        }
                    else
                        return {
                            start   = doc.finish,
                            finish  = doc.finish,
                            newText = ': ' .. code,
                        }
                    end
                end
            end
        )
    end
    return nil
end

local function checkDisableByLuaDocInsert(uri, row, mode, code)
    return {
        start   = guide.positionOf(row, 0),
        finish  = guide.positionOf(row, 0),
        newText = '---@diagnostic ' .. mode .. ': ' .. code .. '\n',
    }
end

local function disableDiagnostic(uri, code, start, results)
    local row = guide.rowColOf(start)
    results[#results+1] = {
        title   = lang.script('ACTION_DISABLE_DIAG', code),
        kind    = 'quickfix',
        command = {
            title     = lang.script.COMMAND_DISABLE_DIAG,
            command   = 'lua.setConfig',
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
    local function pushEdit(title, edit)
        results[#results+1] = {
            title   = title,
            kind    = 'quickfix',
            edit    = {
                changes = {
                    [uri] = { edit }
                }
            }
        }
    end

    pushEdit(lang.script('ACTION_DISABLE_DIAG_LINE', code),
           checkDisableByLuaDocExits (uri, row - 1, 'disable-next-line', code)
        or checkDisableByLuaDocInsert(uri, row,     'disable-next-line', code))
    pushEdit(lang.script('ACTION_DISABLE_DIAG_FILE', code),
           checkDisableByLuaDocExits (uri, 0,   'disable',           code)
        or checkDisableByLuaDocInsert(uri, 0,   'disable',           code))
end

local function markGlobal(uri, name, results)
    results[#results+1] = {
        title   = lang.script('ACTION_MARK_GLOBAL', name),
        kind    = 'quickfix',
        command = {
            title     = lang.script.COMMAND_MARK_GLOBAL,
            command   = 'lua.setConfig',
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
            command   = 'lua.setConfig',
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
    local state = files.getState(uri)
    if not state then
        return
    end
    local start = converter.unpackRange(state, diag.range)
    guide.eachSourceContain(state.ast, start, function (source)
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
    local state = files.getState(uri)
    if not state then
        return
    end
    local start = converter.unpackRange(state, diag.range)
    guide.eachSourceContain(state.ast, start, function (source)
        if source.type ~= 'setglobal' then
            return
        end

        local name = guide.getKeyName(source)
        markGlobal(uri, name, results)
    end)
end

local function findSyntax(uri, diag)
    local state = files.getState(uri)
    if not state then
        return
    end
    for _, err in ipairs(state.errs) do
        if err.type:lower():gsub('_', '-') == diag.code then
            local range = converter.packRange(state, err.start, err.finish)
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
    results[#results+1] = {
        title = lang.script.ACTION_ADD_DO_END,
        kind = 'quickfix',
        edit = {
            changes = {
                [uri] = {
                    {
                        start   = err.start,
                        finish  = err.start,
                        newText = 'do ',
                    },
                    {
                        start   = err.finish,
                        finish  = err.finish,
                        newText = ' end',
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
        edit  = {
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
            command   = 'lua.setConfig',
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
    local state = files.getState(uri)
    if not state then
        return
    end
    local start = converter.unpackRange(state, diag.range)
    results[#results+1] = {
        title = lang.script.ACTION_ADD_SEMICOLON,
        kind = 'quickfix',
        edit = {
            changes = {
                [uri] = {
                    {
                        start   = start,
                        finish  = start,
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
            command = 'lua.solve',
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
            command = 'lua.removeSpace',
            arguments = {
                {
                    uri = uri,
                }
            }
        },
    }
end

local function solveAwaitInSync(uri, diag, results)
    local state = files.getState(uri)
    if not state then
        return
    end
    local start, finish = converter.unpackRange(state, diag.range)
    local parentFunction
    guide.eachSourceType(state.ast, 'function', function (source)
        if source.start > finish
        or source.finish < start then
            return
        end
        if not parentFunction or parentFunction.start < source.start then
            parentFunction = source
        end
    end)
    if not parentFunction then
        return
    end
    local row = guide.rowColOf(parentFunction.start)
    local pos = guide.positionOf(row, 0)
    local offset = guide.positionToOffset(state, pos + 1)
    local space = state.lua:match('[ \t]*', offset)
    results[#results+1] = {
        title = lang.script.ACTION_MARK_ASYNC,
        kind = 'quickfix',
        edit = {
            changes = {
                [uri] = {
                    {
                        start   = pos,
                        finish  = pos,
                        newText = space .. '---@async\n',
                    }
                }
            }
        },
    }
end

local function solveSpell(uri, diag, results)
    local state = files.getState(uri)
    if not state then
        return
    end
    local spell = require 'provider.spell'
    local word = diag.data
    if word == nil then
        return
    end

    results[#results+1] = {
        title   = lang.script('ACTION_ADD_DICT', word),
        kind    = 'quickfix',
        command = {
            title     = lang.script.COMMAND_ADD_DICT,
            command   = 'lua.setConfig',
            arguments = {
                {
                    key    = 'Lua.spell.dict',
                    action = 'add',
                    value  = word,
                    uri    = uri,
                }
            }
        }
    }

    local suggests = spell.getSpellSuggest(word)
    for _, suggest in ipairs(suggests) do
        results[#results+1] = {
            title = suggest,
            kind = 'quickfix',
            edit = {
                changes = {
                    [uri] = {
                        {
                            start   = converter.unpackPosition(state, diag.range.start),
                            finish  = converter.unpackPosition(state, diag.range["end"]),
                            newText = suggest
                        }
                    }
                }
            }
        }
    end

end

local function solveDiagnostic(uri, diag, start, results)
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
    elseif diag.code == 'await-in-sync' then
        solveAwaitInSync(uri, diag, results)
    elseif diag.code == 'spell-check' then
        solveSpell(uri, diag, results)
    end
    disableDiagnostic(uri, diag.code, start, results)
end

local function checkQuickFix(results, uri, start, diagnostics)
    if not diagnostics then
        return
    end
    for _, diag in ipairs(diagnostics) do
        solveDiagnostic(uri, diag, start, results)
    end
end

local function checkSwapParams(results, uri, start, finish)
    local state = files.getState(uri)
    local text  = files.getText(uri)
    if not state or not text then
        return
    end
    local args = {}
    guide.eachSourceBetween(state.ast, start, finish, function (source)
        if source.type == 'callargs'
        or source.type == 'funcargs' then
            local targetIndex
            for index, arg in ipairs(source) do
                if arg.start <= finish and arg.finish >= start then
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
                node = text:sub(
                    guide.positionToOffset(state, source.parent.node.start) + 1,
                    guide.positionToOffset(state, source.parent.node.finish)
                )
            elseif source.type == 'funcargs' then
                local var = source.parent.parent
                if guide.isAssign(var) then
                    if var.type == 'tablefield' then
                        var = var.field
                    end
                    if var.type == 'tableindex' then
                        var = var.index
                    end
                    node = text:sub(
                        guide.positionToOffset(state, var.start) + 1,
                        guide.positionToOffset(state, var.finish)
                    )
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
                                newText = text:sub(
                                    guide.positionToOffset(state, targetArg.start) + 1,
                                    guide.positionToOffset(state, targetArg.finish)
                                ),
                            },
                            {
                                start   = targetArg.start,
                                finish  = targetArg.finish,
                                newText = text:sub(
                                    guide.positionToOffset(state, myArg.start) + 1,
                                    guide.positionToOffset(state, myArg.finish)
                                ),
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

local function checkJsonToLua(results, uri, start, finish)
    local text         = files.getText(uri)
    local state        = files.getState(uri)
    if not state or not text then
        return
    end
    local startOffset  = guide.positionToOffset(state, start)
    local finishOffset = guide.positionToOffset(state, finish)
    local jsonStart = text:match('()["%{%[]', startOffset + 1)
    if not jsonStart then
        return
    end
    local jsonFinish, finishChar
    for i = math.min(finishOffset, #text), jsonStart + 1, -1 do
        local char = text:sub(i, i)
        if char == ']'
        or char == '}' then
            jsonFinish = i
            finishChar = char
            break
        end
    end
    if not jsonFinish then
        return
    end
    if finishChar == '}' then
        if not text:sub(jsonStart, jsonFinish):find '"%s*%:' then
            return
        end
    end
    if finishChar == ']' then
        if not text:sub(jsonStart, jsonFinish):find ',' then
            return
        end
    end
    results[#results+1] = {
        title = lang.script.ACTION_JSON_TO_LUA,
        kind = 'refactor.rewrite',
        command = {
            title = lang.script.COMMAND_JSON_TO_LUA,
            command = 'lua.jsonToLua',
            arguments = {
                {
                    uri    = uri,
                    start  = guide.offsetToPosition(state, jsonStart) - 1,
                    finish = guide.offsetToPosition(state, jsonFinish),
                }
            }
        },
    }
end

local function findRequireTargets(visiblePaths)
    local targets = {}
    for _, visible in ipairs(visiblePaths) do
        targets[#targets+1] = visible.name
    end
    return targets
end

local function checkMissingRequire(results, uri, start, finish)
    local state = files.getState(uri)
    local text  = files.getText(uri)
    if not state or not text then
        return
    end

    local function addRequires(global, endpos)
        autoreq.check(state, global, endpos, function(moduleFile, stemname, targetSource)
            local visiblePaths = rpath.getVisiblePath(uri, furi.decode(moduleFile))
            if not visiblePaths or #visiblePaths == 0 then return end

            for _, target in ipairs(findRequireTargets(visiblePaths)) do
                results[#results+1] = {
                    title = lang.script('ACTION_AUTOREQUIRE', target, global),
                    kind = 'refactor.rewrite',
                    command = {
                        title     = 'autoRequire',
                        command   = 'lua.autoRequire',
                        arguments = {
                            {
                                uri         = guide.getUri(state.ast),
                                target      = moduleFile,
                                name        = global,
                                requireName = target
                            },
                        },
                    }
                }
            end
        end)
    end

    guide.eachSourceBetween(state.ast, start, finish, function (source)
        if vm.isUndefinedGlobal(source) then
            addRequires(source[1], source.finish)
        end
    end)
end

return function (uri, start, finish, diagnostics)
    local ast = files.getState(uri)
    if not ast then
        return nil
    end

    local results = {}

    checkQuickFix(results, uri, start, diagnostics)
    checkSwapParams(results, uri, start, finish)
    --checkExtractAsFunction(results, uri, start, finish)
    checkJsonToLua(results, uri, start, finish)
    checkMissingRequire(results, uri, start, finish)

    return results
end
