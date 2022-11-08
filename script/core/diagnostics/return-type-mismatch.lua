local files = require 'files'
local lang  = require 'language'
local guide = require 'parser.guide'
local vm    = require 'vm'
local await = require 'await'
local util  = require 'utility'

---@param func parser.object
---@return vm.node[]?
local function getDocReturns(func)
    ---@type table<integer, vm.node>
    local returns = util.defaultTable(function ()
        return vm.createNode()
    end)
    if func.bindDocs then
        for _, doc in ipairs(func.bindDocs) do
            if doc.type == 'doc.return' then
                for _, ret in ipairs(doc.returns) do
                    returns[ret.returnIndex]:merge(vm.compileNode(ret))
                end
            end
            if doc.type == 'doc.overload' then
                for i, ret in ipairs(doc.overload.returns) do
                    returns[i]:merge(vm.compileNode(ret))
                end
            end
        end
    end
    for nd in vm.compileNode(func):eachObject() do
        if nd.type == 'doc.type.function' then
            ---@cast nd parser.object
            for i, ret in ipairs(nd.returns) do
                returns[i]:merge(vm.compileNode(ret))
            end
        end
    end
    setmetatable(returns, nil)
    if #returns == 0 then
        return nil
    end
    return returns
end
---@async
return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    ---@param docReturns vm.node[]
    ---@param rets parser.object
    local function checkReturn(docReturns, rets)
        for i, docRet in ipairs(docReturns) do
            local retNode, exp = vm.selectNode(rets, i)
            if not exp then
                break
            end
            if retNode:hasName 'nil' then
                if exp.type == 'getfield'
                or exp.type == 'getindex' then
                    retNode = retNode:copy():removeOptional()
                end
            end
            local errs = {}
            if not vm.canCastType(uri, docRet, retNode, errs) then
                callback {
                    start   = exp.start,
                    finish  = exp.finish,
                    message = lang.script('DIAG_RETURN_TYPE_MISMATCH', {
                        def   = vm.getInfer(docRet):view(uri),
                        ref   = vm.getInfer(retNode):view(uri),
                        index = i,
                    }) .. '\n' .. vm.viewTypeErrorMessage(uri, errs),
                }
            end
        end
    end

    ---@async
    guide.eachSourceType(state.ast, 'function', function (source)
        if not source.returns then
            return
        end
        await.delay()
        local docReturns = getDocReturns(source)
        if not docReturns then
            return
        end
        for _, ret in ipairs(source.returns) do
            checkReturn(docReturns, ret)
            await.delay()
        end
    end)
end
