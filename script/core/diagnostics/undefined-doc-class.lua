local files   = require 'files'
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

    local cache = {}

    for _, doc in ipairs(state.ast.docs) do
        if doc.type == 'doc.class' then
            if not doc.extends then
                goto CONTINUE
            end
            for _, ext in ipairs(doc.extends) do
                local name = ext.type == 'doc.extends.name' and ext[1]
                if name then
                    local docs = vm.getDocSets(uri, name)
                    if cache[name] == nil then
                        cache[name] = false
                        for _, otherDoc in ipairs(docs) do
                            if otherDoc.type == 'doc.class' then
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
            end
        end
        ::CONTINUE::
    end
end
