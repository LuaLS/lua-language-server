local files = require 'files'
local guide = require 'parser.guide'
local lang  = require 'language'
local vm    = require "vm.vm"

---@param source parser.object
---@return boolean
local function isBindDoc(source)
    if not source.bindDocs then
        return false
    end
    for _, doc in ipairs(source.bindDocs) do
        if doc.type == 'doc.type'
        or doc.type == 'doc.class' then
            return true
        end
    end
    return false
end

return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    guide.eachSourceType(state.ast, 'getglobal', function (source)
        if source.node.tag == '_ENV' then
            return
        end

        if not isBindDoc(source.node) then
            return
        end

        if #vm.getDefs(source) > 0 then
            return
        end

        local key = source[1]
        callback {
            start   = source.start,
            finish  = source.finish,
            message = lang.script('DIAG_UNDEF_ENV_CHILD', key),
        }
    end)
end
