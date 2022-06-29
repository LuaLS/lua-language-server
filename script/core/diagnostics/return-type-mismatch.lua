local files = require 'files'
local lang  = require 'language'
local guide = require 'parser.guide'
local vm    = require 'vm'
local await = require 'await'

---@param func parser.object
---@return vm.node[]?
local function getDocReturns(func)
    if not func.bindDocs then
        return nil
    end
    local returns = {}
    for _, doc in ipairs(func.bindDocs) do
        if doc.type == 'doc.return' then
            for _, ret in ipairs(doc.returns) do
                returns[ret.returnIndex] = vm.compileNode(ret)
            end
        end
    end
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
            if not vm.canCastType(uri, docRet, retNode) then
                callback {
                    start   = exp.start,
                    finish  = exp.finish,
                    message = lang.script('DIAG_RETURN_TYPE_MISMATCH', {
                        def   = vm.getInfer(docRet):view(uri),
                        ref   = vm.getInfer(retNode):view(uri),
                        index = i,
                    }),
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
