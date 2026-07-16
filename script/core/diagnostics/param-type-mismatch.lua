local files = require 'files'
local lang  = require 'language'
local guide = require 'parser.guide'
local vm    = require 'vm'
local await = require 'await'

---@param defNode  vm.node
---@param classGenericMap table<string, vm.node>?
local function expandGenerics(defNode, classGenericMap)
    ---@type parser.object[]
    local generics = {}
    for dn in defNode:eachObject() do
        if dn.type == 'doc.generic.name' then
            ---@cast dn parser.object
            generics[#generics+1] = dn
        end
    end

    for _, generic in ipairs(generics) do
        defNode:removeObject(generic)
    end

    for _, generic in ipairs(generics) do
        -- First check if this generic is a class generic that can be resolved
        local genericName = generic[1]
        if classGenericMap and genericName and classGenericMap[genericName] then
            defNode:merge(classGenericMap[genericName])
        else
            -- Fall back to constraint or unknown
            local limits = generic.generic and generic.generic.extends
            if limits then
                defNode:merge(vm.compileNode(limits))
            else
                local unknownType = vm.declareGlobal('type', 'unknown')
                defNode:merge(unknownType)
            end
        end
    end
end

---@param uri uri
---@param source parser.object
---@return table<string, vm.node>?
local function getReceiverGenericMap(uri, source)
    local callNode = source.node
    if not callNode then
        return nil
    end
    -- Only resolve generics for method calls (obj:method()), not static calls (Class.method())
    if callNode.type ~= 'getmethod' then
        return nil
    end
    local receiver = callNode.node
    if not receiver then
        return nil
    end
    local receiverNode = vm.compileNode(receiver)
    for rn in receiverNode:eachObject() do
        if rn.type == 'doc.type.sign' and rn.signs and rn.node and rn.node[1] then
            local classGlobal = vm.getGlobal('type', rn.node[1])
            if classGlobal then
                return vm.getClassGenericMap(uri, classGlobal, rn.signs)
            end
        end
    end
    return nil
end

---@param funcNode vm.node
---@param i integer
---@param classGenericMap table<string, vm.node>?
---@return vm.node?
local function getDefNode(funcNode, i, classGenericMap)
    local defNode = vm.createNode()
    for src in funcNode:eachObject() do
        if src.type == 'function'
        or src.type == 'doc.type.function' then
            local param = src.args and src.args[i]
            if param then
                local paramNode = vm.compileNode(param)
                -- Check for global type references that match class generic params
                if classGenericMap then
                    local newNode = vm.createNode()
                    for pn in paramNode:eachObject() do
                        if pn.type == 'global' and pn.cate == 'type' and classGenericMap[pn.name] then
                            -- Replace the global type reference with the resolved type
                            newNode:merge(classGenericMap[pn.name])
                        else
                            newNode:merge(pn)
                        end
                    end
                    defNode:merge(newNode)
                else
                    defNode:merge(paramNode)
                end
                if param[1] == '...' then
                    defNode:addOptional()
                end
            end
        end
    end
    if defNode:isEmpty() then
        return nil
    end

    expandGenerics(defNode, classGenericMap)

    return defNode
end

---@param funcNode vm.node
---@param i integer
---@return vm.node
local function getRawDefNode(funcNode, i)
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
    return defNode
end

---@async
return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    ---@async
    guide.eachSourceType(state.ast, 'call', function (source)
        if not source.args then
            return
        end
        await.delay()
        local funcNode = vm.compileNode(source.node)
        -- Get the class generic map for method calls on generic class instances
        local classGenericMap = getReceiverGenericMap(uri, source)
        for i, arg in ipairs(source.args) do
            local refNode = vm.compileNode(arg)
            if not refNode then
                goto CONTINUE
            end
            local defNode = getDefNode(funcNode, i, classGenericMap)
            if not defNode then
                goto CONTINUE
            end
            if arg.type == 'getfield'
            or arg.type == 'getindex'
            or arg.type == 'self' then
                -- 由于无法对字段进行类型收窄，
                -- 因此将假值移除再进行检查
                refNode = refNode:copy():setTruthy()
            end
            local errs = {}
            if not vm.canCastType(uri, defNode, refNode, errs) then
                local rawDefNode = getRawDefNode(funcNode, i)
                assert(errs)
                callback {
                    start   = arg.start,
                    finish  = arg.finish,
                    message = lang.script('DIAG_PARAM_TYPE_MISMATCH', {
                        def = vm.getInfer(rawDefNode):view(uri),
                        ref = vm.getInfer(refNode):view(uri),
                    }) .. '\n' .. vm.viewTypeErrorMessage(uri, errs),
                }
            end
            ::CONTINUE::
        end
    end)
end
