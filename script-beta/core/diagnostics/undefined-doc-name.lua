local files   = require 'files'
local guide   = require 'parser.guide'
local lang    = require 'language'
local define  = require 'proto.define'
local vm      = require 'vm'

-- TODO
local builtin = {
    ['any']           = true,
    ['nil']           = true,
    ['void']          = true,
    ['boolean']       = true,
    ['number']        = true,
    ['integer']       = true,
    ['thread']        = true,
    ['table']         = true,
    ['file']          = true,
    ['string']        = true,
    ['userdata']      = true,
    ['lightuserdata'] = true,
    ['function']      = true,
}

return function (uri, callback)
    local state = files.getAst(uri)
    if not state then
        return
    end

    if not state.ast.docs then
        return
    end

    local cache = {}
    guide.eachSource(state.ast.docs, function (source)
        if  source.type ~= 'doc.extends.name'
        and source.type ~= 'doc.type.name' then
            return
        end
        if source.parent.type == 'doc.class' then
            return
        end
        local name = source[1]
        if builtin[name] then
            return
        end
        if cache[name] == nil then
            cache[name] = false
            local docs = vm.getDocTypes(name)
            for _, otherDoc in ipairs(docs) do
                if otherDoc.type == 'doc.class.name'
                or otherDoc.type == 'doc.alias.name' then
                    cache[name] = true
                    break
                end
            end
        end
        if not cache[name] then
            callback {
                start   = source.start,
                finish  = source.finish,
                related = cache,
                message = lang.script('DIAG_UNDEFINED_DOC_NAME', name)
            }
        end
    end)
end
