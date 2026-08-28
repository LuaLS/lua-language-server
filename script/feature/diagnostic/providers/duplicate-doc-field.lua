---@param field Node.Field
---@return string?
local function fieldKey(field)
    local key = field.key
    if not key then
        return nil
    end
    if key.kind == 'value' then
        ---@cast key Node.Value
        return tostring(key.literal)
    end
    if key.kind == 'type' then
        ---@cast key Node.Type
        return '[' .. key.typeName .. ']'
    end
    return nil
end

---@param field Node.Field
---@return boolean
local function isDocFunc(field)
    local value = field.value
    if not value then
        return false
    end
    return value.kind == 'function'
end

---@async
---@param param Feature.Diagnostic.Param
---@return Feature.Diagnostic[]
local function duplicateDocFieldProvider(param)
    local ast = param.ast
    local vfile = param.vfile
    if not vfile then
        return {}
    end
    local results = {}
    local delayer = ls.task.newThrottledDelayer(500)

    ---@type table<integer, LuaParser.Node.CatStateField>
    local fieldSource = {}
    for _, cf in ipairs(ast.nodesMap['catstatefield']) do
        delayer:delay()
        ---@cast cf LuaParser.Node.CatStateField
        if cf.key then
            fieldSource[cf.key.start] = cf
        end
    end

    local reported = {}
    for _, cls in ipairs(ast.nodesMap['catstateclass']) do
        delayer:delay()
        ---@cast cls LuaParser.Node.CatStateClass
        local node = vfile:getNode(cls)
        if not node or node.kind ~= 'class' then
            goto continue
        end
        ---@cast node Node.Class
        local fields = node.fields
        if not fields or not fields.fields then
            goto continue
        end
        ---@type table<string, Node.Field[]>
        local groups = {}
        for field in fields.fields:pairs() do
            ---@cast field Node.Field
            if isDocFunc(field) then
                goto continueField
            end
            local key = fieldKey(field)
            if not key then
                goto continueField
            end
            local group = groups[key]
            if not group then
                group = {}
                groups[key] = group
            end
            group[#group+1] = field
            ::continueField::
        end
        for key, group in pairs(groups) do
            if #group < 2 then
                goto continueGroup
            end
            for i = 1, #group do
                local field = group[i]
                local offset = field.location and field.location.offset
                local source = offset and fieldSource[offset]
                if not source or reported[field] then
                    goto continueField2
                end
                reported[field] = true
                local other = i == 1 and group[2] or group[1]
                local otherOffset = other.location and other.location.offset
                local otherSource = otherOffset and fieldSource[otherOffset]
                local related
                if otherSource then
                    related = { {
                        uri    = param.uri,
                        start  = otherSource.key.start,
                        finish = otherSource.key.finish,
                        message = 'Previous field definition.',
                    } }
                end
                results[#results+1] = {
                    code    = 'duplicate-doc-field',
                    level   = 0,
                    start   = source.key.start,
                    finish  = source.key.finish,
                    message = ('Duplicate field `%s`.'):format(key),
                    related = related,
                }
                ::continueField2::
            end
            ::continueGroup::
        end
        ::continue::
    end
    return results
end

ls.feature.provider.diagnostic(duplicateDocFieldProvider)
