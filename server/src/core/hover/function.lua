local function buildValueArgs(func, object, select)
    if not func then
        return '', nil
    end
    local names = {}
    local values = {}
    local options = {}
    if func.argValues then
        for i, value in ipairs(func.argValues) do
            values[i] = value:getType()
        end
    end
    if func.args then
        for i, arg in ipairs(func.args) do
            names[#names+1] = arg:getName()
            local param = func:findEmmyParamByName(arg:getName())
            if param then
                values[i] = param:getType()
                options[i] = param:getOption()
            end
        end
    end
    local strs = {}
    local start = 1
    if object then
        start = 2
    end
    local max
    if func:getSource() then
        max = #names
    else
        max = math.max(#names, #values)
    end
    for i = start, max do
        local name = names[i]
        local value = values[i] or 'any'
        local option = options[i]
        if option and option.optional then
            if i > start then
                strs[#strs+1] = ' ['
            else
                strs[#strs+1] = '['
            end
        end
        if i > start then
            strs[#strs+1] = ', '
        end

        if i == select then
            strs[#strs+1] = '@ARG'
        end
        if name then
            strs[#strs+1] = name .. ': ' .. value
        else
            strs[#strs+1] = value
        end
        if i == select then
            strs[#strs+1] = '@ARG'
        end

        if option and option.optional == 'self' then
            strs[#strs+1] = ']'
        end
    end
    if func:hasDots() then
        if max > 0 then
            strs[#strs+1] = ', '
        end
        strs[#strs+1] = '...'
    end

    if options then
        for _, option in pairs(options) do
            if option.optional == 'after' then
                strs[#strs+1] = ']'
            end
        end
    end

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
    return text, argLabel
end

local function buildValueReturns(func)
    if not func then
        return '\n  -> any'
    end
    if not func:get 'hasReturn' then
        return ''
    end
    local strs = {}
    if func.returns then
        for i, rtn in ipairs(func.returns) do
            strs[i] = rtn:getType()
        end
    end
    if #strs == 0 then
        strs[1] = 'any'
    end
    return '\n  -> ' .. table.concat(strs, ', ')
end

---@param func emmyFunction
local function buildEnum(func)
    if not func then
        return nil
    end
    local params = func:getEmmyParams()
    if not params then
        return nil
    end
end

local function getComment(func)
    if not func then
        return nil
    end
    return func:getComment()
end

return function (name, func, object, select)
    local args, argLabel = buildValueArgs(func, object, select)
    local returns = buildValueReturns(func)
    local enum = buildEnum(func)
    local comment = getComment(func)
    local headLen = #('function %s('):format(name)
    local title = ('function %s(%s)%s'):format(name, args, returns)
    if argLabel then
        argLabel[1] = argLabel[1] + headLen
        argLabel[2] = argLabel[2] + headLen
    end
    return {
        label = title,
        description = comment,
        enum = enum,
        argLabel = argLabel,
    }
end
