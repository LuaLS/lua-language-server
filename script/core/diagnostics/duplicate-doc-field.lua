local files   = require 'files'
local lang    = require 'language'
local vm      = require 'vm.vm'
local await   = require 'await'
local guide   = require 'parser.guide'

local function isDocFunc(doc)
    if not doc.extends then
        return false
    end
    if #doc.extends.types ~= 1 then
        return false
    end
    local docFunc = doc.extends.types[1]
    if docFunc.type ~= 'doc.type.function' then
        return false
    end
    return true
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
        if isDocFunc(field) then
            return nil
        end
        if not cachedKeys[field] then
            local view = vm.viewKey(field, uri)
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
