local guide         = require 'parser.guide'
local vm            = require 'vm.vm'
local infer         = require 'vm.infer'

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
---@return table<string, vm.node>
function mt:resolve(uri, args)
    if not args then
        return nil
    end
    local globalMgr = require 'vm.global-manager'
    local resolved = {}

    ---@param object parser.object
    ---@param node   vm.node
    local function resolve(object, node)
        if object.type == 'doc.generic.name' then
            local key = object[1]
            if object.literal then
                -- 'number' -> `T`
                for n in node:eachObject() do
                    if n.type == 'string' then
                        local type = globalMgr.declareGlobal('type', n[1], guide.getUri(n))
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
            end
        end
        if object.type == 'doc.type.table' then
            for _, ufield in ipairs(object.fields) do
                local ufieldNode = vm.compileNode(ufield.name)
                local uvalueNode = vm.compileNode(ufield.extends)
                if ufieldNode[1].type == 'doc.generic.name' and uvalueNode[1].type == 'doc.generic.name' then
                    -- { [number]: number} -> { [K]: V }
                    local tfieldNode = vm.getTableKey(uri, node, 'any')
                    local tvalueNode = vm.getTableValue(uri, node, 'any')
                    resolve(ufieldNode[1], tfieldNode)
                    resolve(uvalueNode[1], tvalueNode)
                else
                    if ufieldNode[1].type == 'doc.generic.name' then
                        -- { [number]: number}|number[] -> { [K]: number }
                        local tnode = vm.getTableKey(uri, node, uvalueNode)
                        resolve(ufieldNode[1], tnode)
                    elseif uvalueNode[1].type == 'doc.generic.name' then
                        -- { [number]: number}|number[] -> { [number]: V }
                        local tnode = vm.getTableValue(uri, node, ufieldNode)
                        resolve(uvalueNode[1], tnode)
                    end
                end
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
                local hasGeneric
                guide.eachSourceType(obj, 'doc.generic.name', function (src)
                    hasGeneric = true
                    genericsNames[src[1]] = true
                end)
                if hasGeneric then
                    goto CONTINUE
                end
            end
            local view = infer.viewObject(obj)
            if view then
                knownTypes[view] = true
            end
            ::CONTINUE::
        end
        return knownTypes, genericsNames
    end

    -- remove un-generic type
    ---@param argNode vm.node
    ---@param knownTypes table<string, true>
    ---@return vm.node
    local function buildArgNode(argNode, knownTypes)
        local newArgNode = vm.createNode()
        for n in argNode:eachObject() do
            if argNode:isOptional() and vm.isFalsy(n) then
                goto CONTINUE
            end
            local view = infer.viewObject(n)
            if knownTypes[view] then
                goto CONTINUE
            end
            newArgNode:merge(n)
            ::CONTINUE::
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
            local newArgNode = buildArgNode(argNode, knownTypes)
            for n in sign:eachObject() do
                resolve(n, newArgNode)
            end
        end
    end

    return resolved
end

---@return vm.sign
return function ()
    local genericMgr = setmetatable({
        signList = {},
    }, mt)
    return genericMgr
end
