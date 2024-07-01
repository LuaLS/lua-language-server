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

    local merged = {}
    local cache = {}
    for _, doc in ipairs(state.ast.docs) do
        if doc.type == 'doc.alias'
        or doc.type == 'doc.enum' then
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
                    or otherDoc.type == 'doc.class'
                    or otherDoc.type == 'doc.enum' then
                        cache[name][#cache[name]+1] = {
                            start  = otherDoc.start,
                            finish = otherDoc.finish,
                            uri    = guide.getUri(otherDoc),
                        }
                        merged[name] = merged[name] or vm.docHasAttr(otherDoc, 'partial')
                    end
                end
            end
            if not merged[name] and #cache[name] > 1 then
                callback {
                    start   = (doc.alias or doc.enum).start,
                    finish  = (doc.alias or doc.enum).finish,
                    related = cache,
                    message = lang.script('DIAG_DUPLICATE_DOC_ALIAS', name)
                }
            end
        end
    end
end
