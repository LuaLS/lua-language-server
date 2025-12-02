local lang = require 'language'

local m    = {}

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

---@param functionName string
---@param source parser.object
---@param diagnosticRangeSource? parser.object sometimes the object with the data isn't the one that needs the diagnostics
---@param bindDocsSource? parser.object sometimes the object with the bind docs isn't the value (`a.b = c` syntax)
---@param callback fun(result: any)
---@param commentId string
---@param paramId string
---@param returnId string
local function checkFunctionNamed(functionName, source, diagnosticRangeSource, bindDocsSource, callback, commentId,
                                  paramId, returnId)
    diagnosticRangeSource = diagnosticRangeSource or source
    bindDocsSource = bindDocsSource or source
    local argCount = diagnosticRangeSource.args and #diagnosticRangeSource.args or 0

    if argCount == 0 and not source.returns and not bindDocsSource.bindDocs then
        callback {
            start   = diagnosticRangeSource.start,
            finish  = diagnosticRangeSource.finish,
            message = lang.script(commentId, functionName),
        }
    end

    if argCount > 0 then
        for _, arg in ipairs(source.args) do
            local argName = arg[1]
            if  argName ~= 'self'
            and argName ~= '_' then
                if not findParam(bindDocsSource.bindDocs, argName) then
                    callback {
                        start   = arg.start,
                        finish  = arg.finish,
                        message = lang.script(paramId, argName, functionName),
                    }
                end
            end
        end
    end

    if source.returns then
        for _, ret in ipairs(source.returns) do
            for index, expr in ipairs(ret) do
                if not findReturn(bindDocsSource.bindDocs, index) then
                    callback {
                        start   = expr.start,
                        finish  = expr.finish,
                        message = lang.script(returnId, index, functionName),
                    }
                end
            end
        end
    end
end

---@param source parser.object
---@param callback fun(result: any)
---@param commentId string
---@param paramId string
---@param returnId string
local function checkFunction(source, callback, commentId, paramId, returnId)
    local functionName = source.parent[1]
    checkFunctionNamed(functionName, source, nil, nil, callback, commentId, paramId, returnId)
end


---@param source parser.object
---@param callback fun(result: any)
---@param commentId string
---@param paramId string
---@param returnId string
local function checkMethod(source, callback, commentId, paramId, returnId)
    local functionName = source.method[1]
    checkFunctionNamed(functionName, source.value, source, nil, callback, commentId, paramId, returnId)
end

m.CheckFunction = checkFunction
m.CheckFunctionNamed = checkFunctionNamed
m.CheckMethod = checkMethod
return m
