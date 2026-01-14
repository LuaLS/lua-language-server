local files   = require 'files'
local guide   = require 'parser.guide'
local lang    = require 'language'
local vm      = require 'vm'

--- Check if name is a generic parameter from a class context
---@param source parser.object  The doc.type.name source
---@param name string  The type name to check
---@param uri uri  The file URI
---@return boolean
local function isClassGenericParam(source, name, uri)
    -- Find containing doc node
    local doc = guide.getParentTypes(source, {
        ['doc.return'] = true,
        ['doc.param'] = true,
        ['doc.type'] = true,
        ['doc.field'] = true,
        ['doc.overload'] = true,
        ['doc.vararg'] = true,
    })
    if not doc then
        return false
    end

    -- Walk up to find a doc node with bindGroup (intermediate doc.type nodes don't have it)
    while doc and not doc.bindGroup do
        doc = doc.parent
    end
    if not doc then
        return false
    end

    -- Check bindGroup for class/alias with matching generic sign
    local bindGroup = doc.bindGroup
    if bindGroup then
        for _, other in ipairs(bindGroup) do
            if (other.type == 'doc.class' or other.type == 'doc.alias') and other.signs then
                for _, sign in ipairs(other.signs) do
                    if sign[1] == name then
                        return true
                    end
                end
            end
        end
    end

    -- Check direct class reference (for doc.field, doc.overload, doc.operator)
    if doc.class and doc.class.signs then
        for _, sign in ipairs(doc.class.signs) do
            if sign[1] == name then
                return true
            end
        end
    end

    -- Check if bound to a method on a generic class
    -- First, find the function from any doc in the bindGroup
    local func = nil
    if bindGroup then
        for _, other in ipairs(bindGroup) do
            local bindSource = other.bindSource
            if bindSource then
                if bindSource.type == 'function' then
                    func = bindSource
                    break
                elseif bindSource.parent and bindSource.parent.type == 'function' then
                    func = bindSource.parent
                    break
                end
            end
        end
    end

    -- If we found a function, check if it's a method on a generic class
    if func and func.parent then
        local parent = func.parent
        if parent.type == 'setmethod' or parent.type == 'setfield' or parent.type == 'setindex' then
            local classGlobal = vm.getDefinedClass(uri, parent.node)
            if classGlobal then
                for _, set in ipairs(classGlobal:getSets(uri)) do
                    if set.type == 'doc.class' and set.signs then
                        for _, sign in ipairs(set.signs) do
                            if sign[1] == name then
                                return true
                            end
                        end
                    end
                end
            end
        end
    end

    return false
end

return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    if not state.ast.docs then
        return
    end

    guide.eachSource(state.ast.docs, function (source)
        if  source.type ~= 'doc.extends.name'
        and source.type ~= 'doc.type.name' then
            return
        end
        if source.parent.type == 'doc.class' then
            return
        end
        local name = source[1]
        if name == '...' or name == '_' or name == 'self' then
            return
        end
        if isClassGenericParam(source, name, uri) then
            return
        end
        if #vm.getDocSets(uri, name) > 0 then
            return
        end
        callback {
            start   = source.start,
            finish  = source.finish,
            message = lang.script('DIAG_UNDEFINED_DOC_NAME', name)
        }
    end)
end
