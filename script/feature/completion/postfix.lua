local util = ls.feature.completionUtil

ls.feature.provider.completion(function (param, action)
    if param.inComment then
        return
    end
    if param.inString then
        return
    end

    local text = param.scanner.text
    local lineStart, lineLeft = util.getLineLeft(text, param.offset)

    if lineLeft:match('^%s*%-%-%-') then
        return
    end

    local expr, op = lineLeft:match('^(.-)@([%w_]+)$')
    local plusExpr, plusOp = lineLeft:match('^(.-)(%+%+%??)$')
    if plusExpr and plusOp then
        expr = plusExpr
        op = plusOp
    end
    if not expr or expr == '' or not op then
        return
    end

    action.skip()

    local exprStart = lineStart
    local exprFinish = lineStart + #expr
    local opStart = exprFinish
    local opFinish = opStart + #op

    local function pushPostfix(label, newText)
        ---@type any
        local item = {
            label = label,
            kind = ls.spec.CompletionItemKind.Snippet,
            textEdit = {
                start = opStart,
                finish = opFinish,
                newText = newText,
            },
            additionalTextEdits = {
                {
                    start = exprStart,
                    finish = exprFinish,
                    newText = '',
                }
            }
        }
        action.push(item)
    end

    if op == 'pcall' then
        local fn, args = expr:match('^([%w_%.:]+)%((.*)%)$')
        if fn then
            local call = args == '' and ('pcall(' .. fn .. ')') or ('pcall(' .. fn .. ', ' .. args .. ')')
            pushPostfix('pcall', call)
        else
            pushPostfix('pcall', 'pcall(' .. expr .. '$1)$0')
        end
        return
    end

    if op == 'xpcall' then
        local fn, args = expr:match('^([%w_%.:]+)%((.*)%)$')
        if fn then
            local call = args == ''
                and ('xpcall(' .. fn .. ', ${1:debug.traceback})$0')
                or  ('xpcall(' .. fn .. ', ${1:debug.traceback}, ' .. args .. ')$0')
            pushPostfix('xpcall', call)
        else
            pushPostfix('xpcall', 'xpcall(' .. expr .. ', ${1:debug.traceback}$2)$0')
        end
        return
    end

    if op == 'function' then
        pushPostfix('function', 'function ' .. expr .. '($1)\n\t$0\nend')
        return
    end

    if op == 'method' then
        local owner, method = expr:match('^([%w_%.]+)[%.:]([%w_]+)$')
        if owner and method then
            pushPostfix('method', 'function ' .. owner .. ':' .. method .. '($1)\n\t$0\nend')
        end
        return
    end

    if op == 'ifcall' then
        local fn, args = expr:match('^([%w_%.:]+)%((.*)%)$')
        if fn then
            if args ~= '' then
                pushPostfix('ifcall', 'if ' .. fn .. ' then ' .. fn .. '(' .. args .. ') end$0')
            else
                pushPostfix('ifcall', 'if ' .. fn .. ' then ' .. fn .. '() end$0')
            end
        else
            pushPostfix('ifcall', 'if ' .. expr .. ' then ' .. expr .. '($1) end$0')
        end
        return
    end

    if op == 'local' then
        pushPostfix('local', 'local $1 = ' .. expr .. '$0')
        return
    end

    if op == 'ipairs' then
        pushPostfix('ipairs', 'for ${1:i}, ${2:v} in ipairs(' .. expr .. ') do\n\t$0\nend')
        return
    end

    if op == 'pairs' then
        pushPostfix('pairs', 'for ${1:k}, ${2:v} in pairs(' .. expr .. ') do\n\t$0\nend')
        return
    end

    if op == 'unpack' then
        pushPostfix('unpack', 'unpack(' .. expr .. ')')
        return
    end

    if op == 'insert' then
        pushPostfix('insert', 'table.insert(' .. expr .. ', $0)')
        return
    end

    if op == 'remove' then
        pushPostfix('remove', 'table.remove(' .. expr .. ', $0)')
        return
    end

    if op == 'concat' then
        pushPostfix('concat', 'table.concat(' .. expr .. ', $0)')
        return
    end

    if op == '++' then
        pushPostfix('++', expr .. ' = ' .. expr .. ' + 1')
        pushPostfix('++?', expr .. ' = (' .. expr .. ' or 0) + 1')
        return
    end
end, 25)
