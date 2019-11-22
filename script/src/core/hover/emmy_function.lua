---@param emmy EmmyFunctionType
local function buildEmmyArgs(emmy, object, select)
    local start
    if object then
        start = 2
    else
        start = 1
    end
    local strs = {}
    local args = {}
    local i = 0
    emmy:eachParam(function (name, typeObj)
        i = i + 1
        if i < start then
            return
        end
        if i > start then
            strs[#strs+1] = ', '
        end
        if i == select then
            strs[#strs+1] = '@ARG'
        end
        strs[#strs+1] = name .. ': ' .. typeObj:getType()
        args[#args+1] = strs[#strs]
        if i == select then
            strs[#strs+1] = '@ARG'
        end
    end)
    local text = table.concat(strs)
    local argLabel = {}
    for i = 1, 2 do
        local pos = text:find('@ARG', 1, true)
        if pos then
            if i == 1 then
                argLabel[i] = pos
            else
                argLabel[i] = pos - 1
            end
            text = text:sub(1, pos-1) .. text:sub(pos+4)
        end
    end
    if #argLabel == 0 then
        argLabel = nil
    end
    return text, argLabel, args
end

local function buildEmmyReturns(emmy)
    local rtns = {}
    local i = 0
    emmy:eachReturn(function (rtn)
        i = i + 1
        if i > 1 then
            rtns[#rtns+1] = ('\n% 3d. '):format(i)
        end
        rtns[#rtns+1] = rtn:getType()
    end)
    if #rtns == 0 then
        return '\n  -> ' .. 'any'
    else
        return '\n  -> ' .. table.concat(rtns)
    end
end

local function buildEnum(lib)
    if not lib.enums then
        return ''
    end
    local container = table.container()
    for _, enum in ipairs(lib.enums) do
        if not enum.name or (not enum.enum and not enum.code) then
            goto NEXT_ENUM
        end
        if not container[enum.name] then
            container[enum.name] = {}
            if lib.args then
                for _, arg in ipairs(lib.args) do
                    if arg.name == enum.name then
                        container[enum.name].type = arg.type
                        break
                    end
                end
            end
            if lib.returns then
                for _, rtn in ipairs(lib.returns) do
                    if rtn.name == enum.name then
                        container[enum.name].type = rtn.type
                        break
                    end
                end
            end
        end
        table.insert(container[enum.name], enum)
        ::NEXT_ENUM::
    end
    local strs = {}
    local raw = {}
    for name, enums in pairs(container) do
        local tp
        if type(enums.type) == 'table' then
            tp = table.concat(enums.type, '/')
        else
            tp = enums.type
        end
        raw[name] = {}
        strs[#strs+1] = ('\n%s: %s'):format(name, tp or 'any')
        for _, enum in ipairs(enums) do
            if enum.default then
                strs[#strs+1] = '\n  -> '
            else
                strs[#strs+1] = '\n   | '
            end
            if enum.code then
                strs[#strs+1] = tostring(enum.code)
            else
                strs[#strs+1] = ('%q'):format(enum.enum)
            end
            raw[name][#raw[name]+1] = strs[#strs]
            if enum.description then
                strs[#strs+1] = ' -- ' .. enum.description
            end
        end
    end
    return table.concat(strs), raw
end

return function (name, emmy, object, select)
    local argStr, argLabel, args = buildEmmyArgs(emmy, object, select)
    local returns = buildEmmyReturns(emmy)
    local enum, rawEnum = buildEnum(emmy)
    local tip = emmy.description
    return {
        label = ('function %s(%s)%s'):format(name, argStr, returns),
        name = name,
        argStr = argStr,
        returns = returns,
        description = tip,
        enum = enum,
        rawEnum = rawEnum,
        argLabel = argLabel,
        args = args,
    }
end
