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
        if not source.value then return end -- if the assignment is unbalanced then there is no value
        if source.value.type ~= "function" then return end

        -- TODO: find a better way to distinguish a.b = function and function a.b, or alternatively make them both work
        -- the same way?
        -- the issue is they have very similar ASTs but bindDocs is either inside or outside value

        helper.CheckFunctionNamed(source.field[1], source.value, nil, source.bindDocs and source or source.value,
            callback,
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
