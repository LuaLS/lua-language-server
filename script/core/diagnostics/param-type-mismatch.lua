local files = require 'files'
local lang  = require 'language'
local guide = require 'parser.guide'
local vm    = require 'vm'
local await = require 'await'

---@async
return function (uri, callback)
    if not PREVIEW and not TEST then
        return
    end
    local state = files.getState(uri)
    if not state then
        return
    end

    ---@param funcNode vm.node
    ---@param i integer
    ---@return vm.node?
    local function getDefNode(funcNode, i)
        local defNode = vm.createNode()
        for f in funcNode:eachObject() do
            if f.type == 'function'
            or f.type == 'doc.type.function' then
                local param = f.args and f.args[i]
                if param then
                    defNode:merge(vm.compileNode(param))
                end
            end
        end
        if defNode:isEmpty() then
            return nil
        end
        return defNode
    end

    ---@async
    guide.eachSourceType(state.ast, 'call', function (source)
        if not source.args then
            return
        end
        await.delay()
        local funcNode = vm.compileNode(source.node)
        for i, arg in ipairs(source.args) do
            local refNode = vm.compileNode(arg)
            local defNode = getDefNode(funcNode, i)
            if defNode then
                if not vm.canCastType(uri, defNode, refNode) then
                    callback {
                        start   = arg.start,
                        finish  = arg.finish,
                        message = lang.script('DIAG_PARAM_TYPE_MISMATCH', {
                            def = vm.getInfer(defNode):view(uri),
                            ref = vm.getInfer(refNode):view(uri),
                        })
                    }
                end
            end
        end
    end)
end
