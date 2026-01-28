local files = require 'files'
local guide = require 'parser.guide'
local vm    = require 'vm'
local lang  = require 'language'
local await = require 'await'

---@param node vm.node
---@return string|nil
local function getTruthiness(node)
    if node:alwaysTruthy() then
        return 'true'
    end
    if node:alwaysFalsy() then
        return 'false'
    end
    return nil
end

---@param infer vm.infer
---@param uri uri
---@return boolean|nil
local function isBooleanOnly(infer, uri)
    if infer:hasAny(uri) or infer:hasUnknown(uri) then
        return nil
    end
    local hasBoolean = infer:hasType(uri, 'boolean')
    if not hasBoolean then
        return false
    end
    for view in infer:eachView(uri) do
        if view ~= 'boolean' then
            return false
        end
    end
    return true
end

---@param source parser.object?
---@param uri uri
---@param callback fun(result: diag.result)
local function checkExpression(source, uri, callback)
    if not source then
        return
    end
    local node = vm.compileNode(source)
    local truthiness = getTruthiness(node)
    if truthiness then
        callback {
            start   = source.start,
            finish  = source.finish,
            message = lang.script('DIAG_BOOLEAN_CONTEXT_ALWAYS', truthiness),
        }
        return
    end
    local infer = vm.getInfer(source)
    local onlyBoolean = isBooleanOnly(infer, uri)
    if onlyBoolean == true or onlyBoolean == nil then
        return
    end
    callback {
        start   = source.start,
        finish  = source.finish,
        message = lang.script('DIAG_BOOLEAN_CONTEXT_NONBOOLEAN', infer:view(uri)),
    }
end

---@async
return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    ---@async
    guide.eachSourceTypes(state.ast, {'ifblock', 'elseifblock', 'while', 'repeat'}, function (source)
        await.delay()
        if source.filter
        and source.filter.type == 'binary'
        and source.filter.op
        and (source.filter.op.type == 'and' or source.filter.op.type == 'or') then
            return
        end
        checkExpression(source.filter, uri, callback)
    end)

    ---@async
    guide.eachSourceType(state.ast, 'binary', function (source)
        await.delay()
        local op = source.op and source.op.type
        if op ~= 'and' and op ~= 'or' then
            return
        end
        checkExpression(source[1], uri, callback)
    end)
end
