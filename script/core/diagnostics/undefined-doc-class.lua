local files   = require 'files'
local searcher   = require 'core.searcher'
local lang    = require 'language'
local define  = require 'proto.define'
local vm      = require 'vm'

return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    if not state.ast.docs then
        return
    end

    local cache = {
        ['any'] = true,
        ['nil'] = true,
    }
    for _, doc in ipairs(state.ast.docs) do
        if doc.type == 'doc.class' then
            if not doc.extends then
                goto CONTINUE
            end
            for _, ext in ipairs(doc.extends) do
                local name = ext[1]
                local docs = vm.getDocDefines(name)
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
        end
        ::CONTINUE::
    end
end
