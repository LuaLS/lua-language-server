local files   = require 'files'
local lang    = require 'language'
local noder   = require 'core.noder'

return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    if not state.ast.docs then
        return
    end

    local mark
    for _, group in ipairs(state.ast.docs.groups) do
        for _, doc in ipairs(group) do
            if doc.type == 'doc.class' then
                mark = {}
            elseif doc.type == 'doc.field' then
                if mark then
                    local name = doc.field[1]
                    local eventName = noder.getFieldEventName(doc)
                    if eventName then
                        name = name .. '|' .. eventName
                    end
                    if mark[name] then
                        callback {
                            start  = doc.field.start,
                            finish = doc.field.finish,
                            message = lang.script('DIAG_DUPLICATE_DOC_FIELD', name),
                        }
                    end
                    mark[name] = true
                end
            end
        end
    end
end
