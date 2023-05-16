local files   = require 'files'
local guide   = require "parser.guide"
local await   = require 'await'
local helper  = require 'core.diagnostics.helper.missing-doc-helper'

---@async
return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    if not state.ast then
        return
    end

    ---@async
    guide.eachSourceType(state.ast, 'function', function (source)
        await.delay()

        if source.parent.type ~= 'setglobal' then
            return
        end

        helper.CheckFunction(source, callback, 'DIAG_MISSING_GLOBAL_DOC_COMMENT', 'DIAG_MISSING_GLOBAL_DOC_PARAM', 'DIAG_MISSING_GLOBAL_DOC_RETURN')
    end)
end
