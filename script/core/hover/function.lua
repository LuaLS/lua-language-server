local emmyFunction = require 'core.hover.emmy_function'

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
    local args = {}
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
        args[#args+1] = strs[#strs]
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
    return text, argLabel, args
end

local function buildValueReturns(func)
    if not func then
        return '\n  -> any'
    end
    if not func:get 'hasReturn' then
        return ''
    end
    local strs = {}
    local emmys = {}
    local n = 0
    func:eachEmmyReturn(function (emmy)
        n = n + 1
        emmys[n] = emmy
    end)
    if func.returns then
        for i, rtn in ipairs(func.returns) do
            local emmy = emmys[i]
            local option = emmy and emmy.option
            if option and option.optional then
                if i > 1 then
                    strs[#strs+1] = ' ['
                else
                    strs[#strs+1] = '['
                end
            end
            if i > 1 then
                strs[#strs+1] = ('\n% 3d. '):format(i)
            end
            if emmy and emmy.name then
                strs[#strs+1] = ('%s: '):format(emmy.name)
            elseif option and option.name then
                strs[#strs+1] = ('%s: '):format(option.name)
            end
            strs[#strs+1] = rtn:getType()
            if option and option.optional == 'self' then
                strs[#strs+1] = ']'
            end
        end
        for i = 1, #func.returns do
            local emmy = emmys[i]
            if emmy and emmy.option and emmy.option.optional == 'after' then
                strs[#strs+1] = ']'
            end
        end
    end
    if #strs == 0 then
        strs[1] = 'any'
    end
    return '\n  -> ' .. table.concat(strs)
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
    local strs = {}
    local raw = {}
    for _, param in ipairs(params) do
        local first = true
        local name = param:getName()
        raw[name] = {}
        param:eachEnum(function (enum)
            if first then
                first = false
                strs[#strs+1] = ('\n%s: %s'):format(param:getName(), param:getType())
            end
            if enum.default then
                strs[#strs+1] = ('\n   |>%s'):format(enum[1])
            else
                strs[#strs+1] = ('\n   | %s'):format(enum[1])
            end
            if enum.comment then
                strs[#strs+1] = ' -- ' .. enum.comment
            end
            raw[name][#raw[name]+1] = enum[1]
        end)
    end
    if #strs == 0 then
        return nil
    end
    return table.concat(strs), raw
end

local function getComment(func)
    if not func then
        return nil
    end
    local comments = {}
    local params = func:getEmmyParams()
    if params then
        for _, param in ipairs(params) do
            local option = param:getOption()
            if option and option.comment then
                comments[#comments+1] = ('+ `%s`*(%s)*: %s'):format(param:getName(), param:getType(), option.comment)
            end
        end
    end
    comments[#comments+1] = func:getComment()
    if #comments == 0 then
        return nil
    end
    return table.concat(comments, '\n\n')
end

local function getOverLoads(name, func, object, select)
    local overloads = func and func:getEmmyOverLoads()
    if not overloads then
        return nil
    end
    local list = {}
    for _, ol in ipairs(overloads) do
        local hover = emmyFunction(name, ol, object, select)
        list[#list+1] = hover.label
    end
    return table.concat(list, '\n')
end

return function (name, func, object, select)
    local argStr, argLabel, args = buildValueArgs(func, object, select)
    local returns = buildValueReturns(func)
    local enum, rawEnum = buildEnum(func)
    local comment = getComment(func)
    local overloads = getOverLoads(name, func, object, select)
    return {
        label = ('function %s(%s)%s'):format(name, argStr, returns),
        name = name,
        argStr = argStr,
        returns = returns,
        description = comment,
        enum = enum,
        rawEnum = rawEnum,
        argLabel = argLabel,
        overloads = overloads,
        args = args,
    }
end
