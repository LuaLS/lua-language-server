return function (source, caller)
    if not source then
        return ''
    end
    local key
    if source:get 'simple' then
        local simple = source:get 'simple'
        local chars = {}
        for i, obj in ipairs(simple) do
            if obj.type == 'name' then
                chars[i] = obj[1]
            elseif obj.type == 'index' then
                chars[i] = '[?]'
            elseif obj.type == 'call' then
                chars[i] = '(?)'
            elseif obj.type == ':' then
                chars[i] = ':'
            elseif obj.type == '.' then
                chars[i] = '.'
            else
                chars[i] = '*' .. obj.type
            end
            if obj == source then
                break
            end
        end
        key = table.concat(chars)
    elseif source.type == 'name' then
        key = source[1]
    elseif source.type == 'string' then
        key = ('%q'):format(source[1])
    elseif source.type == 'number' or source.type == 'boolean' then
        key = tostring(source[1])
    elseif source.type == 'simple' then
        local chars = {}
        for i, obj in ipairs(source) do
            if obj.type == 'name' then
                chars[i] = obj[1]
            elseif obj.type == 'index' then
                chars[i] = '[?]'
            elseif obj.type == 'call' then
                chars[i] = '(?)'
            elseif obj.type == ':' then
                chars[i] = ':'
            elseif obj.type == '.' then
                chars[i] = '.'
            else
                chars[i] = '*' .. obj.type
            end
        end
        -- 这里有个特殊处理
        -- function mt:func() 以 mt.func 的形式调用时
        -- hover 显示为 mt.func(self)
        if caller then
            if chars[#chars-1] == ':' then
                if not caller:get 'object' then
                    chars[#chars-1] = '.'
                end
            elseif chars[#chars-1] == '.' then
                if caller:get 'object' then
                    chars[#chars-1] = ':'
                end
            end
        end
        key = table.concat(chars)
    else
        key = ''
    end
    return key
end
