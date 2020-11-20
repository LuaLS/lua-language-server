local files   = require 'files'
local guide   = require 'parser.guide'
local lang    = require 'language'
local define  = require 'proto.define'
local vm      = require 'vm'

local function hasNameOfClassOrAlias(name)
    local docs = vm.getDocTypes(name)
    for _, otherDoc in ipairs(docs) do
        if otherDoc.type == 'doc.class.name'
        or otherDoc.type == 'doc.alias.name' then
            return true
        end
    end
    return false
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

return function (uri, callback)
    local state = files.getAst(uri)
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
        if name == '...' then
            return
        end
        if hasNameOfClassOrAlias(name)
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
