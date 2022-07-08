local files   = require 'files'
local lang    = require 'language'
local vm      = require 'vm.vm'
local await   = require 'await'

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

    local mark
    for _, group in ipairs(state.ast.docs.groups) do
        for _, doc in ipairs(group) do
            if     doc.type == 'doc.class' then
                mark = {}
            elseif doc.type == 'doc.field' then
                if mark then
                    await.delay()
                    local name
                    if doc.field.type == 'doc.type' then
                        name = ('[%s]'):format(vm.getInfer(doc.field):view(uri))
                    else
                        name = ('%q'):format(doc.field[1])
                    end
                    local eventName = getFieldEventName(doc)
                    if eventName then
                        name = name .. '|' .. eventName
                    end
                    if mark[name] then
                        callback {
                            start   = doc.field.start,
                            finish  = doc.field.finish,
                            message = lang.script('DIAG_DUPLICATE_DOC_FIELD', name),
                        }
                    end
                    mark[name] = true
                end
            end
        end
    end
end
