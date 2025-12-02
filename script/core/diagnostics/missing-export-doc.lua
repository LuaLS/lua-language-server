local files  = require 'files'
local guide  = require 'parser.guide'
local await  = require 'await'
local helper = require 'core.diagnostics.helper.missing-doc-helper'

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
    guide.eachSourceType(state.ast, 'setfield', function (source)
        await.delay()
        if source.value.type ~= "function" then return end
        helper.CheckFunctionNamed(source.field[1], source.value, source.value, callback,
            'DIAG_MISSING_EXPORTED_FIELD_DOC_COMMENT',
            'DIAG_MISSING_EXPORTED_FIELD_DOC_PARAM',
            'DIAG_MISSING_EXPORTED_FIELD_DOC_RETURN')
    end)

    ---@async
    guide.eachSourceType(state.ast, 'setmethod', function (source)
        await.delay()
        helper.CheckMethod(source, callback, 'DIAG_MISSING_EXPORTED_METHOD_DOC_COMMENT',
            'DIAG_MISSING_EXPORTED_METHOD_DOC_PARAM',
            'DIAG_MISSING_EXPORTED_METHOD_DOC_RETURN')
    end)
end
