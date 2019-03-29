local lang = require 'language'

local function disableDiagnostic(lsp, uri, data, callback)
    callback {
        title = lang.script('ACTION_DISABLE_DIAG', data.code),
        kind = 'quickfix',
        command = {
            title = lang.script.COMMAND_DISABLE_DIAG,
            command = 'config',
            arguments = {
                {
                    key = {'diagnostics', 'disable'},
                    action = 'add',
                    value = data.code,
                }
            }
        }
    }
end

local function addGlobal(lines, text, data, callback)
    local start = lines:position(data.range.start.line + 1, data.range.start.character + 1)
    local finish = lines:position(data.range['end'].line + 1, data.range['end'].character)
    local name = text:sub(start, finish)
    if #name < 0 or name:find('[^%w_]') then
        return
    end
    callback {
        title = lang.script('ACTION_MARK_GLOBAL', name),
        kind = 'quickfix',
        command = {
            title = lang.script.COMMAND_MARK_GLOBAL,
            command = 'config',
            arguments = {
                {
                    key = {'diagnostics', 'globals'},
                    action = 'add',
                    value = name,
                }
            }
        },
    }
end

local function solveUndefinedGlobal(lsp, uri, data, callback)
    local vm, lines, text = lsp:getVM(uri)
    if not vm then
        return
    end
    addGlobal(lines, text, data, callback)
end

local function solveLowercaseGlobal(lsp, uri, data, callback)
    local vm, lines, text = lsp:getVM(uri)
    if not vm then
        return
    end
    addGlobal(lines, text, data, callback)
end

local function solveTrailingSpace(lsp, uri, data, callback)
    callback {
        title = lang.script.ACTION_REMOVE_SPACE,
        kind = 'quickfix',
        command = {
            title = lang.script.COMMAND_REMOVE_SPACE,
            command = 'removeSpace',
            arguments = {
                {
                    uri = uri,
                }
            }
        },
    }
end

local function solveNewlineCall(lsp, uri, data, callback)
    callback {
        title = lang.script.ACTION_ADD_SEMICOLON,
        kind = 'quickfix',
        edit = {
            changes = {
                [uri] = {
                    {
                        range = {
                            start = data.range.start,
                            ['end'] = data.range.start,
                        },
                        newText = ';',
                    }
                }
            }
        }
    }
end

local function solveAmbiguity1(lsp, uri, data, callback)
    callback {
        title = lang.script.ACTION_ADD_BRACKETS,
        kind = 'quickfix',
        command = {
            title = lang.script.COMMAND_ADD_BRACKETS,
            command = 'solve',
            arguments = {
                {
                    name = 'ambiguity-1',
                    uri = uri,
                    range = data.range,
                }
            }
        },
    }
end

local function solveDiagnostic(lsp, uri, data, callback)
    if not data.code then
        return
    end
    if data.code == 'undefined-global' then
        solveUndefinedGlobal(lsp, uri, data, callback)
    end
    if data.code == 'trailing-space' then
        solveTrailingSpace(lsp, uri, data, callback)
    end
    if data.code == 'newline-call' then
        solveNewlineCall(lsp, uri, data, callback)
    end
    if data.code == 'ambiguity-1' then
        solveAmbiguity1(lsp, uri, data, callback)
    end
    if data.code == 'lowercase-global' then
        solveLowercaseGlobal(lsp, uri, data, callback)
    end
    disableDiagnostic(lsp, uri, data, callback)
end

return function (lsp, params)
    local uri = params.textDocument.uri

    local results = {}

    for _, data in ipairs(params.context.diagnostics) do
        solveDiagnostic(lsp, uri, data, function (result)
            results[#results+1] = result
        end)
    end

    if #results == 0 then
        return nil
    end

    return results
end
