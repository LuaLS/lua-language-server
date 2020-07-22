local lang = require 'language'
local library = require 'core.library'

local function disableDiagnostic(lsp, uri, data, callback)
    callback {
        title = lang.script('ACTION_DISABLE_DIAG', data.code),
        kind = 'quickfix',
        command = {
            title = lang.script.COMMAND_DISABLE_DIAG,
            command = 'lua.config',
            arguments = {
                {
                    key    = 'Lua.diagnostics.disable',
                    action = 'add',
                    value  = data.code,
                    uri    = uri,
                }
            }
        }
    }
end

local function addGlobal(name, uri, callback)
    callback {
        title = lang.script('ACTION_MARK_GLOBAL', name),
        kind = 'quickfix',
        command = {
            title = lang.script.COMMAND_MARK_GLOBAL,
            command = 'lua.config',
            arguments = {
                {
                    key    = 'Lua.diagnostics.globals',
                    action = 'add',
                    value  = name,
                    uri    = uri,
                }
            }
        },
    }
end

local function changeVersion(version, uri, callback)
    callback {
        title = lang.script('ACTION_RUNTIME_VERSION', version),
        kind = 'quickfix',
        command = {
            title = lang.script.COMMAND_RUNTIME_VERSION,
            command = 'lua.config',
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

local function openCustomLibrary(libName, uri, callback)
    callback {
        title = lang.script('ACTION_OPEN_LIBRARY', libName),
        kind = 'quickfix',
        command = {
            title = lang.script.COMMAND_OPEN_LIBRARY,
            command = 'lua.config',
            arguments = {
                {
                    key    = 'Lua.runtime.library',
                    action = 'add',
                    value  = libName,
                    uri    = uri,
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
    local start = lines:position(data.range.start.line + 1, data.range.start.character + 1)
    local finish = lines:position(data.range['end'].line + 1, data.range['end'].character)
    local name = text:sub(start, finish)
    if #name < 0 or name:find('[^%w_]') then
        return
    end
    addGlobal(name, uri, callback)
    local otherVersion = library.other[name]
    if otherVersion then
        for _, version in ipairs(otherVersion) do
            changeVersion(version, uri, callback)
        end
    end

    local customLibrary = library.custom[name]
    if customLibrary then
        for _, libName in ipairs(customLibrary) do
            openCustomLibrary(libName, uri, callback)
        end
    end
end

local function solveLowercaseGlobal(lsp, uri, data, callback)
    local vm, lines, text = lsp:getVM(uri)
    if not vm then
        return
    end
    local start = lines:position(data.range.start.line + 1, data.range.start.character + 1)
    local finish = lines:position(data.range['end'].line + 1, data.range['end'].character)
    local name = text:sub(start, finish)
    if #name < 0 or name:find('[^%w_]') then
        return
    end
    addGlobal(name, uri, callback)
end

local function solveTrailingSpace(lsp, uri, data, callback)
    callback {
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
            command = 'lua.solve',
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

local function findSyntax(astErr, lines, data)
    local start = lines:position(data.range.start.line + 1, data.range.start.character + 1)
    local finish = lines:position(data.range['end'].line + 1, data.range['end'].character)
    for _, err in ipairs(astErr) do
        if err.start == start and err.finish == finish then
            return err
        end
    end
    return nil
end

local function solveSyntaxByChangeVersion(err, uri, callback)
    if type(err.version) == 'table' then
        for _, version in ipairs(err.version) do
            changeVersion(version, uri, callback)
        end
    else
        changeVersion(err.version, uri, callback)
    end
end

local function solveSyntaxByAddDoEnd(uri, data, callback)
    callback {
        title = lang.script.ACTION_ADD_DO_END,
        kind = 'quickfix',
        edit = {
            changes = {
                [uri] = {
                    {
                        range = {
                            start = data.range.start,
                            ['end'] = data.range.start,
                        },
                        newText = 'do ',
                    },
                    {
                        range = {
                            start = data.range['end'],
                            ['end'] = data.range['end'],
                        },
                        newText = ' end',
                    }
                }
            }
        }
    }
end

local function solveSyntaxByFix(uri, err, lines, callback)
    local changes = {}
    for _, e in ipairs(err.fix) do
        local start_row,  start_col  = lines:rowcol(e.start)
        local finish_row, finish_col = lines:rowcol(e.finish)
        changes[#changes+1] = {
            range = {
                start = {
                    line = start_row - 1,
                    character = start_col - 1,
                },
                ['end'] = {
                    line = finish_row - 1,
                    character = finish_col,
                },
            },
            newText = e.text,
        }
    end
    callback {
        title = lang.script['ACTION_' .. err.fix.title],
        kind  = 'quickfix',
        edit = {
            changes = {
                [uri] = changes,
            }
        }
    }
end

local function findEndPosition(lines, row, endrow)
    if endrow == row then
        return {
            newText = ' end',
            range = {
                start = {
                    line = row - 1,
                    character = 999999,
                },
                ['end'] = {
                    line = row - 1,
                    character = 999999,
                }
            }
        }
    else
        local l = lines[row]
        return {
            newText = ('\t'):rep(l.tab) .. (' '):rep(l.sp) .. 'end\n',
            range = {
                start = {
                    line = endrow,
                    character = 0,
                },
                ['end'] = {
                    line = endrow,
                    character = 0,
                }
            }
        }
    end
end

local function isIfPart(id, lines, i)
    if id ~= 'if' then
        return false
    end
    local buf = lines:line(i)
    local first = buf:match '^[%s\t]*([%w]+)'
    if first == 'else' or first == 'elseif' then
        return true
    end
    return false
end

local function solveSyntaxByAddEnd(uri, start, finish, lines, callback)
    local row = lines:rowcol(start)
    local line = lines[row]
    if not line then
        return nil
    end
    local id = lines.buf:sub(start, finish)
    local sp = line.sp + line.tab * 4
    for i = row + 1, #lines do
        local nl = lines[i]
        local lsp = nl.sp + nl.tab * 4
        if lsp <= sp and not isIfPart(id, lines, i) then
            callback {
                title = lang.script['ACTION_ADD_END'],
                kind  = 'quickfix',
                edit  = {
                    changes = {
                        [uri] = {
                            findEndPosition(lines, row, i - 1)
                        }
                    }
                }
            }
            return
        end
    end
    return nil
end

---@param lsp LSP
---@param uri uri
---@param data table
---@param callback function
local function solveSyntax(lsp, uri, data, callback)
    local file = lsp:getFile(uri)
    if not file then
        return
    end
    local astErr, lines = file:getAstErr(), file:getLines()
    if not astErr or not lines then
        return
    end
    local err = findSyntax(astErr, lines, data)
    if not err then
        return nil
    end
    if err.version then
        solveSyntaxByChangeVersion(err, uri, callback)
    end
    if err.type == 'ACTION_AFTER_BREAK' or err.type == 'ACTION_AFTER_RETURN' then
        solveSyntaxByAddDoEnd(uri, data, callback)
    end
    if err.type == 'MISS_END' then
        solveSyntaxByAddEnd(uri, err.start, err.finish, lines, callback)
    end
    if err.type == 'MISS_SYMBOL' and err.info.symbol == 'end' then
        solveSyntaxByAddEnd(uri, err.info.related[1], err.info.related[2], lines, callback)
    end
    if err.fix then
        solveSyntaxByFix(uri, err, lines, callback)
    end
end

local function solveDiagnostic(lsp, uri, data, callback)
    if data.source == lang.script.DIAG_SYNTAX_CHECK then
        solveSyntax(lsp, uri, data, callback)
    end
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

local function rangeContain(a, b)
    if a.start.line > b.start.line then
        return false
    end
    if a.start.character > b.start.character then
        return false
    end
    if a['end'].line < b['end'].line then
        return false
    end
    if a['end'].character < b['end'].character then
        return false
    end
    return true
end

return function (lsp, uri, diagnostics, range)
    local results = {}

    for _, data in ipairs(diagnostics) do
        if rangeContain(data.range, range) then
            solveDiagnostic(lsp, uri, data, function (result)
                results[#results+1] = result
            end)
        end
    end

    return results
end
