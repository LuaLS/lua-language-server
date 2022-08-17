local files = require 'files'
local lang  = require 'language'
local guide = require 'parser.guide'
local vm    = require 'vm'
local await = require 'await'

---@async
return function (uri, callback)
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
                    if param[1] == '...' then
                        defNode:addOptional()
                    end
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
            if i == 1 and source.node.type == 'getmethod' then
                goto CONTINUE
            end
            local refNode = vm.compileNode(arg)
            if not refNode then
                goto CONTINUE
            end
            local defNode = getDefNode(funcNode, i)
            if not defNode then
                goto CONTINUE
            end
            if arg.type == 'getfield'
            or arg.type == 'getindex' then
                -- 由于无法对字段进行类型收窄，
                -- 因此将假值移除再进行检查
                refNode = refNode:copy():setTruthy()
            end
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
            ::CONTINUE::
        end
    end)
end
