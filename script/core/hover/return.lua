local infer    = require 'core.infer'

local function getReturnDualByDoc(source)
    local docs = source.bindDocs
    if not docs then
        return
    end
    local dual
    for _, doc in ipairs(docs) do
        if doc.type == 'doc.return' then
            for _, rtn in ipairs(doc.returns) do
                if not dual then
                    dual = {}
                end
                dual[#dual+1] = { rtn }
            end
        end
    end
    return dual
end

local function getReturnDualByGrammar(source)
    if not source.returns then
        return nil
    end
    local dual
    for _, rtn in ipairs(source.returns) do
        if not dual then
            dual = {}
        end
        for n = 1, #rtn do
            if not dual[n] then
                dual[n] = {}
            end
            dual[n][#dual[n]+1] = rtn[n]
        end
    end
    return dual
end

local function asFunction(source)
    local dual = getReturnDualByDoc(source)
            or   getReturnDualByGrammar(source)
    if not dual then
        return
    end
    local returns = {}
    for i, rtn in ipairs(dual) do
        local line = {}
        local infers = {}
        if i == 1 then
            line[#line+1] = '  -> '
        else
            line[#line+1] = ('% 3d. '):format(i)
        end
        for n = 1, #rtn do
            if rtn[n].type == 'doc.type' then
                for _, typeUnit in ipairs(rtn[n].types) do
                    if typeUnit[1] == 'nil' then
                        infers['nil'] = true
                    end
                end
            end
            local values = infer.searchInfers(rtn[n])
            for tp in pairs(values) do
                infers[tp] = true
            end
        end
        if next(infers) or rtn[1] then
            local tp = infer.viewInfers(infers)
            if rtn[1].name then
                line[#line+1] = ('%s%s: %s'):format(
                    rtn[1].name[1],
                    rtn[1].optional and '?' or '',
                    tp
                )
            else
                line[#line+1] = ('%s%s'):format(
                    tp,
                    rtn[1].optional and '?' or ''
                )
            end
        else
            break
        end
        returns[i] = table.concat(line)
    end
    if #returns == 0 then
        return nil
    end
    return table.concat(returns, '\n')
end

local function asDocFunction(source)
    if not source.returns or #source.returns == 0 then
        return nil
    end
    local returns = {}
    for i, rtn in ipairs(source.returns) do
        local rtnText = ('%s%s'):format(
            infer.searchAndViewInfers(rtn),
            rtn.optional and '?' or ''
        )
        if i == 1 then
            returns[#returns+1] = ('  -> %s'):format(rtnText)
        else
            returns[#returns+1] = ('% 3d. %s'):format(i, rtnText)
        end
    end
    return table.concat(returns, '\n')
end

return function (source)
    if source.type == 'function' then
        return asFunction(source)
    end
    if source.type == 'doc.type.function' then
        return asDocFunction(source)
    end
end
