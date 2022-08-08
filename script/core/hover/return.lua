local vm       = require 'vm.vm'
local guide    = require 'parser.guide'

---@param source parser.object
---@return parser.object[]
local function getReturnDocs(source)
    local returns = {}

    local docs = source.bindDocs
    if docs then
        for _, doc in ipairs(docs) do
            if doc.type == 'doc.return' then
                for _, rtn in ipairs(doc.returns) do
                    returns[rtn.returnIndex] = rtn
                end
            end
        end
    end

    return returns
end

local function asFunction(source)
    local _, _, num = vm.countReturnsOfFunction(source)
    if num == 0 then
        return nil
    end

    local docs = getReturnDocs(source)

    local returns = {}

    for i = 1, num do
        local rtn  = vm.getReturnOfFunction(source, i)
        local doc  = docs[i]
        local name = doc and doc.name and doc.name[1]
        if name and name ~= '...' then
            name = name .. ': '
        end
        local text = rtn and ('%s%s'):format(
            name or '',
            vm.getInfer(rtn):view(guide.getUri(source))
        ) or 'unknown'
        if i == 1 then
            returns[i] = ('  -> %s'):format(text)
        else
            returns[i] = ('% 3d. %s'):format(i, text)
        end
    end

    return table.concat(returns, '\n')
end

local function asDocFunction(source)
    if not source.returns or #source.returns == 0 then
        return nil
    end
    local returns = {}
    for i, rtn in ipairs(source.returns) do
        local rtnText = vm.getInfer(rtn):view(guide.getUri(source))
        if rtn.name then
            if rtn.name[1] == '...' then
                rtnText = rtn.name[1] .. rtnText
            else
                rtnText = rtn.name[1] .. ': ' .. rtnText
            end
        end
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
