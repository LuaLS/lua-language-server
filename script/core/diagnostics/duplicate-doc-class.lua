local files    = require 'files'
local searcher = require 'core.searcher'
local lang     = require 'language'
local vm       = require 'vm'
local guide    = require 'parser.guide'

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
        if doc.type == 'doc.alias' then
            local name = guide.getKeyName(doc)
            if not cache[name] then
                local docs = vm.getDocDefines(name)
                cache[name] = {}
                for _, otherDoc in ipairs(docs) do
                    if otherDoc.type == 'doc.class.name'
                    or otherDoc.type == 'doc.alias.name' then
                        cache[name][#cache[name]+1] = {
                            start  = otherDoc.start,
                            finish = otherDoc.finish,
                            uri    = guide.getUri(otherDoc),
                        }
                    end
                end
            end
            if #cache[name] > 1 then
                callback {
                    start   = doc.start,
                    finish  = doc.finish,
                    related = cache,
                    message = lang.script('DIAG_DUPLICATE_DOC_CLASS', name)
                }
            end
        end
    end
end
