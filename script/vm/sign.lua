local guide         = require 'parser.guide'
---@class vm
local vm            = require 'vm.vm'

---@class vm.sign
---@field parent   parser.object
---@field signList vm.node[]
local mt = {}
mt.__index = mt
mt.type = 'sign'

---@param node vm.node
function mt:addSign(node)
    self.signList[#self.signList+1] = node
end

---@param uri uri
---@param args parser.object
---@param removeGeneric true?
---@return table<string, vm.node>?
function mt:resolve(uri, args, removeGeneric)
    if not args then
        return nil
    end
    local resolved = {}

    ---@param object vm.node.object
    ---@param node   vm.node
    local function resolve(object, node)
        if object.type == 'doc.generic.name' then
            local key = object[1]
            if object.literal then
                -- 'number' -> `T`
                for n in node:eachObject() do
                    if n.type == 'string' then
                        ---@cast n parser.object
                        local type = vm.declareGlobal('type', n[1], guide.getUri(n))
                        resolved[key] = vm.createNode(type, resolved[key])
                    end
                end
            else
                -- number -> T
                resolved[key] = vm.createNode(node, resolved[key])
            end
        end
        if object.type == 'doc.type.array' then
            for n in node:eachObject() do
                if n.type == 'doc.type.array' then
                    -- number[] -> T[]
                    resolve(object.node, vm.compileNode(n.node))
                end
                if n.type == 'doc.type.table' then
                    -- { [integer]: number } -> T[]
                    local tvalueNode = vm.getTableValue(uri, node, 'integer', true)
                    if tvalueNode then
                        resolve(object.node, tvalueNode)
                    end
                end
                if n.type == 'global' and n.cate == 'type' then
                    -- ---@field [integer]: number -> T[]
                    ---@cast n vm.global
                    vm.getClassFields(uri, n, vm.declareGlobal('type', 'integer'), false, function (field)
                        resolve(object.node, vm.compileNode(field.extends))
                    end)
                end
                if n.type == 'table' and #n >= 1 then
                    -- { x } / { ... } -> T[]
                    resolve(object.node, vm.compileNode(n[1]))
                end
            end
        end
        if object.type == 'doc.type.table' then
            for _, ufield in ipairs(object.fields) do
                local ufieldNode = vm.compileNode(ufield.name)
                local uvalueNode = vm.compileNode(ufield.extends)
                local firstField = ufieldNode:get(1)
                local firstValue = uvalueNode:get(1)
                if not firstField or not firstValue then
                    goto CONTINUE
                end
                if firstField.type == 'doc.generic.name' and firstValue.type == 'doc.generic.name' then
                    -- { [number]: number} -> { [K]: V }
                    local tfieldNode = vm.getTableKey(uri, node, 'any', true)
                    local tvalueNode = vm.getTableValue(uri, node, 'any', true)
                    if tfieldNode then
                        resolve(firstField, tfieldNode)
                    end
                    if tvalueNode then
                        resolve(firstValue, tvalueNode)
                    end
                else
                    if ufieldNode:get(1).type == 'doc.generic.name' then
                        -- { [number]: number}|number[] -> { [K]: number }
                        local tnode = vm.getTableKey(uri, node, uvalueNode, true)
                        if tnode then
                            resolve(firstField, tnode)
                        end
                    elseif uvalueNode:get(1).type == 'doc.generic.name' then
                        -- { [number]: number}|number[] -> { [number]: V }
                        local tnode = vm.getTableValue(uri, node, ufieldNode, true)
                        if tnode then
                            resolve(firstValue, tnode)
                        end
                    end
                end
                ::CONTINUE::
            end
        end
    end

    ---@param sign vm.node
    ---@return table<string, true>
    ---@return table<string, true>
    local function getSignInfo(sign)
        local knownTypes = {}
        local genericsNames   = {}
        for obj in sign:eachObject() do
            if obj.type == 'doc.generic.name' then
                genericsNames[obj[1]] = true
                goto CONTINUE
            end
            if obj.type == 'doc.type.table'
            or obj.type == 'doc.type.function'
            or obj.type == 'doc.type.array' then
                ---@cast obj parser.object
                local hasGeneric
                guide.eachSourceType(obj, 'doc.generic.name', function (src)
                    hasGeneric = true
                    genericsNames[src[1]] = true
                end)
                if hasGeneric then
                    goto CONTINUE
                end
            end
            local view = vm.viewObject(obj, uri)
            if view then
                knownTypes[view] = true
            end
            ::CONTINUE::
        end
        return knownTypes, genericsNames
    end

    -- remove un-generic type
    ---@param argNode vm.node
    ---@param sign vm.node
    ---@param knownTypes table<string, true>
    ---@return vm.node
    local function buildArgNode(argNode, sign, knownTypes)
        local newArgNode = vm.createNode()
        local needRemoveNil = sign:hasFalsy()
        for n in argNode:eachObject() do
            if needRemoveNil then
                if n.type == 'nil' then
                    goto CONTINUE
                end
                if n.type == 'global' and n.cate == 'type' and n.name == 'nil' then
                    goto CONTINUE
                end
            end
            local view = vm.viewObject(n, uri)
            if knownTypes[view] then
                goto CONTINUE
            end
            newArgNode:merge(n)
            ::CONTINUE::
        end
        if not needRemoveNil and argNode:isOptional() then
            newArgNode:addOptional()
        end
        return newArgNode
    end

    ---@param genericNames table<string, true>
    local function isAllResolved(genericNames)
        for n in pairs(genericNames) do
            if not resolved[n] then
                return false
            end
        end
        return true
    end

    for i, arg in ipairs(args) do
        local sign = self.signList[i]
        if not sign then
            break
        end
        local argNode = vm.compileNode(arg)
        local knownTypes, genericNames = getSignInfo(sign)
        if not isAllResolved(genericNames) then
            local newArgNode = buildArgNode(argNode,sign, knownTypes)
            for n in sign:eachObject() do
                resolve(n, newArgNode)
            end
        end
    end

    return resolved
end

---@return vm.sign
function vm.createSign()
    local genericMgr = setmetatable({
        signList = {},
    }, mt)
    return genericMgr
end
