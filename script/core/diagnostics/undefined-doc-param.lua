local files   = require 'files'
local searcher   = require 'core.searcher'
local lang    = require 'language'
local define  = require 'proto.define'
local vm      = require 'vm'

local function hasParamName(func, name)
    if not func.args then
        return false
    end
    for _, arg in ipairs(func.args) do
        if arg[1] == name then
            return true
        end
        if arg.type == '...' and name == '...' then
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

    if not state.ast.docs then
        return
    end

    for _, doc in ipairs(state.ast.docs) do
        if doc.type ~= 'doc.param' then
            goto CONTINUE
        end
        local binds = doc.bindSources
        if not binds then
            goto CONTINUE
        end
        local param = doc.param
        local name = param[1]
        for _, source in ipairs(binds) do
            if source.type == 'function' then
                if not hasParamName(source, name) then
                    callback {
                        start   = param.start,
                        finish  = param.finish,
                        message = lang.script('DIAG_UNDEFINED_DOC_PARAM', name)
                    }
                end
            end
        end
        ::CONTINUE::
    end
end
