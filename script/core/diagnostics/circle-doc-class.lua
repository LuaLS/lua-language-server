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

    for _, doc in ipairs(state.ast.docs) do
        if doc.type == 'doc.class' then
            if not doc.extends then
                goto CONTINUE
            end
            await.delay()
            local myName = guide.getKeyName(doc)
            local list = { doc }
            local mark = {}
            for i = 1, 999 do
                local current = list[i]
                if not current then
                    goto CONTINUE
                end
                if current.extends then
                    for _, extend in ipairs(current.extends) do
                        local newName = extend[1]
                        if newName == myName then
                            callback {
                                start   = doc.start,
                                finish  = doc.finish,
                                message = lang.script('DIAG_CIRCLE_DOC_CLASS', myName)
                            }
                            goto CONTINUE
                        end
                        if newName and not mark[newName] then
                            mark[newName] = true
                            local docs = vm.getDocSets(uri, newName)
                            for _, otherDoc in ipairs(docs) do
                                if otherDoc.type == 'doc.class' then
                                    list[#list+1] = otherDoc
                                end
                            end
                        end
                    end
                end
            end
            ::CONTINUE::
        end
    end
end
