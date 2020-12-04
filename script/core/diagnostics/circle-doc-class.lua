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

    for _, doc in ipairs(state.ast.docs) do
        if doc.type == 'doc.class' then
            if not doc.extends then
                goto CONTINUE
            end
            local myName = guide.getKeyName(doc)
            local list = { doc }
            local mark = {}
            for i = 1, 999 do
                local current = list[i]
                if not current then
                    goto CONTINUE
                end
                if current.extends then
                    local newName = current.extends[1]
                    if newName == myName then
                        callback {
                            start   = doc.start,
                            finish  = doc.finish,
                            message = lang.script('DIAG_CIRCLE_DOC_CLASS', myName)
                        }
                        goto CONTINUE
                    end
                    if not mark[newName] then
                        mark[newName] = true
                        local docs = vm.getDocTypes(newName)
                        for _, otherDoc in ipairs(docs) do
                            if otherDoc.type == 'doc.class.name' then
                                list[#list+1] = otherDoc.parent
                            end
                        end
                    end
                end
            end
            ::CONTINUE::
        end
    end
end
