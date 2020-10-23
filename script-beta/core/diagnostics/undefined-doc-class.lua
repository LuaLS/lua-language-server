local files   = require 'files'
local guide   = require 'parser.guide'
local lang    = require 'language'
local define  = require 'proto.define'
local vm      = require 'vm'

return function (uri, callback)
    local state = files.getAst(uri)
    if not state then
        return
    end

    if not state.ast.docs then
        return
    end

    local cache = {}
    for _, doc in ipairs(state.ast.docs) do
        if doc.type == 'doc.class' then
            local ext = doc.extends
            if not ext then
                goto CONTINUE
            end
            local name = ext[1]
            local docs = vm.getDocTypes(name)
            if cache[name] == nil then
                cache[name] = false
                for _, otherDoc in ipairs(docs) do
                    if otherDoc.type == 'doc.class.name' then
                        cache[name] = true
                        break
                    end
                end
            end
            if not cache[name] then
                callback {
                    start   = ext.start,
                    finish  = ext.finish,
                    related = cache,
                    message = lang.script('DIAG_UNDEFINED_DOC_CLASS', name)
                }
            end
        end
        ::CONTINUE::
    end
end
