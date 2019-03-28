local function disableDiagnostic(lsp, uri, data, callback)
    callback {
        title = ('禁用诊断(%s)'):format(data.code),
        kind = 'quickfix',
        command = {
            title = '禁用诊断',
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
    callback {
        title = ('标记 `%s` 为已定义的全局变量'):format(name),
        kind = 'quickfix',
        command = {
            title = '标记全局变量',
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

local function solveTrailingSpace(lsp, uri, data, callback)
    callback {
        title = '清除所有后置空格',
        kind = 'quickfix',
        command = {
            title = '清除所有后置空格',
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
        title = '添加 `;`',
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
        title = '添加括号',
        kind = 'quickfix',
        command = {
            title = '添加括号',
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
