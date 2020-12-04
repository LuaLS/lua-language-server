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
        if doc.type == 'doc.class'
        or doc.type == 'doc.alias' then
            local name = guide.getKeyName(doc)
            if not cache[name] then
                local docs = vm.getDocTypes(name)
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
