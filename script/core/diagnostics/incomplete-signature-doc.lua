-- incomplete-signature-doc
local files   = require 'files'
local lang    = require 'language'
local guide   = require "parser.guide"
local await   = require 'await'

local function findParam(docs, param)
    if not docs then
        return false
    end

    for _, doc in ipairs(docs) do
        if doc.type == 'doc.param' then
            if doc.param[1] == param then
                return true
            end
        end
    end

    return false
end

local function findReturn(docs, index)
    if not docs then
        return false
    end

    for _, doc in ipairs(docs) do
        if doc.type == 'doc.return' then
            for _, ret in ipairs(doc.returns) do
                if ret.returnIndex == index then
                    return true
                end
            end
        end
    end

    return false
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
    guide.eachSourceType(state.ast, 'function', function (source)
        await.delay()

        if not source.bindDocs then
            return
        end

        local functionName = source.parent[1]

        if #source.args > 0 then
            for _, arg in ipairs(source.args) do
                local argName = arg[1]
                if argName ~= 'self' then
                    if not findParam(source.bindDocs, argName) then
                        callback {
                            start   = arg.start,
                            finish  = arg.finish,
                            message = lang.script('DIAG_INCOMPLETE_SIGNATURE_DOC_PARAM', argName, functionName),
                        }
                    end
                end
            end
        end

        if  source.returns then
            for _, ret in ipairs(source.returns) do
                for index, expr in ipairs(ret) do
                    if not findReturn(source.bindDocs, index) then
                        callback {
                            start   = expr.start,
                            finish  = expr.finish,
                            message = lang.script('DIAG_INCOMPLETE_SIGNATURE_DOC_RETURN', index, functionName),
                        }
                    end
                end
            end
        end
    end)
end
