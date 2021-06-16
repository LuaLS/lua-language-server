local files   = require 'files'
local guide   = require 'parser.guide'
local lang    = require 'language'
local vm      = require 'vm'

return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    if not state.ast.docs then
        return
    end

    local function hasNameOfGeneric(name, source)
        if not source.typeGeneric then
            return false
        end
        if not source.typeGeneric[name] then
            return false
        end
        return true
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
        if name == '...' then
            return
        end
        if vm.isDocDefined(name)
        or hasNameOfGeneric(name, source) then
            return
        end
        callback {
            start   = source.start,
            finish  = source.finish,
            message = lang.script('DIAG_UNDEFINED_DOC_NAME', name)
        }
    end)
end
