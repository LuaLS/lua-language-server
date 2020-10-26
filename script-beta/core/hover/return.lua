local guide = require 'parser.guide'
local vm    = require 'vm'

local function mergeTypes(returns)
    if type(returns) == 'string' then
        return returns
    end
    return guide.mergeTypes(returns)
end

local function asLibrary(source)
    if not source.returns then
        return nil
    end
    local returns = {}
    for i, rtn in ipairs(source.returns) do
        local line = {}
        local name = rtn.name
        local tp = rtn.type and mergeTypes(rtn.type) or 'any'
        if i == 1 then
            line[#line+1] = '  ->'
        else
            line[#line+1] = ('% 3d.'):format(i)
        end
        if rtn.optional then
            line[#line+1] = '['
        else
            line[#line+1] = ' '
        end
        if name then
            line[#line+1] = ('%s: %s'):format(name, tp)
        else
            line[#line+1] = tp
        end
        if rtn.optional then
            line[#line+1] = ']'
        end
        returns[i] = table.concat(line)
    end
    if #returns == 0 then
        return nil
    end
    return table.concat(returns, '\n')
end

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
        local types = {}
        if i == 1 then
            line[#line+1] = '  -> '
        else
            line[#line+1] = ('% 3d. '):format(i)
        end
        for n = 1, #rtn do
            local values = vm.getInfers(rtn[n])
            for _, value in ipairs(values) do
                if value.type then
                    for tp in value.type:gmatch '[^|]+' do
                        types[#types+1] = tp
                    end
                end
            end
        end
        if #types > 0 or rtn[1] then
            local tp = mergeTypes(types) or 'any'
            line[#line+1] = tp
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
    if not source.returns then
        return ''
    end
    local returns = {}
    for i, rtn in ipairs(source.returns) do
        local rtnText = vm.getInferType(rtn)
        if i == 1 then
            returns[#returns+1] = ('  -> %s'):format(rtnText)
        else
            returns[#returns+1] = ('% 3d. %s'):format(i, rtnText)
        end
    end
    return table.concat(returns, '\n')
end

return function (source)
    if source.type == 'library' then
        return asLibrary(source.value)
    elseif source.library then
        return asLibrary(source)
    end
    if source.type == 'function' then
        return asFunction(source)
    end
    if source.type == 'doc.type.function' then
        return asDocFunction(source)
    end
end
