local files    = require 'files'
local lang     = require 'language'
local vm       = require 'vm'
local guide    = require 'parser.guide'
local await    = require 'await'

---@async
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
            if not name then
                return
            end
            await.delay()
            if not cache[name] then
                local docs = vm.getDocSets(uri, name)
                cache[name] = {}
                for _, otherDoc in ipairs(docs) do
                    if otherDoc.type == 'doc.alias'
                    or otherDoc.type == 'doc.class' then
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
                    start   = doc.alias.start,
                    finish  = doc.alias.finish,
                    related = cache,
                    message = lang.script('DIAG_DUPLICATE_DOC_ALIAS', name)
                }
            end
        end
    end
end
