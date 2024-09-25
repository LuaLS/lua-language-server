local files   = require 'files'
local guide   = require "parser.guide"
local await   = require 'await'
local helper  = require 'core.diagnostics.helper.missing-doc-helper'

---@async
local function findSetField(ast, name, callback)
    ---@async
    guide.eachSourceType(ast, 'setfield', function (source)
        await.delay()
        if source.node[1] == name then
            local funcPtr = source.value.node
            if not funcPtr then
                return
            end
            local func = funcPtr.value
            if not func then
                return
            end
            if funcPtr.type == 'local' and func.type == 'function' then
                helper.CheckFunction(func, callback, 'DIAG_MISSING_LOCAL_EXPORT_DOC_COMMENT', 'DIAG_MISSING_LOCAL_EXPORT_DOC_PARAM', 'DIAG_MISSING_LOCAL_EXPORT_DOC_RETURN')
            end
        end
    end)
end

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
    guide.eachSourceType(state.ast, 'return', function (source)
        await.delay()
        --table

        for _, ret in ipairs(source) do
            if ret.type == 'getlocal' then
                if ret.node.value and ret.node.value.type == 'table' then
                    findSetField(state.ast, ret[1], callback)
                end
            end
        end
    end)
end
