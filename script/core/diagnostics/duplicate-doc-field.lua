local files   = require 'files'
local lang    = require 'language'
local vm      = require 'vm.vm'
local await   = require 'await'
local guide   = require 'parser.guide'

local function getFieldEventName(doc)
    if not doc.extends then
        return nil
    end
    if #doc.extends.types ~= 1 then
        return nil
    end
    local docFunc = doc.extends.types[1]
    if docFunc.type ~= 'doc.type.function' then
        return nil
    end
    for i = 1, 2 do
        local arg = docFunc.args[i]
        if  arg
        and arg.extends
        and #arg.extends.types == 1 then
            local literal = arg.extends.types[1]
            if literal.type == 'doc.type.boolean'
            or literal.type == 'doc.type.string'
            or literal.type == 'doc.type.integer' then
                return ('%q'):format(literal[1])
            end
        end
    end
    return nil
end

---@async
return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    if not state.ast.docs then
        return
    end

    local cachedKeys = {}

    ---@param field parser.object
    ---@return string?
    local function viewKey(field)
        if not cachedKeys[field] then
            local view = vm.viewKey(field, uri)
            if view then
                local eventName = getFieldEventName(field)
                if eventName then
                    view = view .. '|' .. eventName
                end
            end
            cachedKeys[field] = view or false
        end
        return cachedKeys[field] or nil
    end

    ---@async
    ---@param myField parser.object
    local function checkField(myField)
        await.delay()
        local myView = viewKey(myField)
        if not myView then
            return
        end

        local class = myField.class
        if not class then
            return
        end
        for _, set in ipairs(vm.getGlobal('type', class.class[1]):getSets(uri)) do
            if not set.fields then
                goto CONTINUE
            end
            for _, field in ipairs(set.fields) do
                if field == myField then
                    goto CONTINUE
                end
                local view = viewKey(field)
                if view ~= myView then
                    goto CONTINUE
                end
                callback {
                    start   = myField.field.start,
                    finish  = myField.field.finish,
                    message = lang.script('DIAG_DUPLICATE_DOC_FIELD', myView),
                    related = {{
                        start  = field.field.start,
                        finish = field.field.finish,
                        uri    = guide.getUri(field),
                    }}
                }
                do return end
                ::CONTINUE::
            end
            ::CONTINUE::
        end
    end

    for _, doc in ipairs(state.ast.docs) do
        if doc.type == 'doc.field' then
            checkField(doc)
        end
    end
end
