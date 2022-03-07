local createGeneric = require 'vm.generic'
local guide         = require 'parser.guide'
local nodeMgr       = require 'vm.node'

---@class vm.node.generic-manager
---@field parent   parser.object
---@field signList vm.node[]
local mt = {}
mt.__index = mt
mt.type = 'generic-manager'

---@param key parser.object
function mt:addSign(key)
    local compiler = require 'vm.compiler'
    self.signList[#self.signList+1] = compiler.compileNode(key)
end

---@param node vm.node
function mt:getChild(node)
    local generic = createGeneric(self, node)
    return generic
end

---@param argNodes vm.node[]
---@return table<string, vm.node>
function mt:resolve(argNodes)
    if not argNodes then
        return nil
    end
    local typeMgr   = require 'vm.type'
    local compiler  = require 'vm.compiler'
    local globalMgr = require 'vm.global-manager'
    local resolved = {}

    ---@param typeUnit parser.object
    ---@param node     vm.node
    local function resolve(typeUnit, node)
        if typeUnit.type == 'doc.generic.name' then
            local key = typeUnit[1]
            if typeUnit.literal then
                -- 'number' -> `T`
                for n in nodeMgr.eachNode(node) do
                    if n.type == 'string' then
                        local type = globalMgr.declareGlobal('type', n[1], guide.getUri(n))
                        resolved[key] = nodeMgr.mergeNode(type, resolved[key])
                    end
                end
            else
                -- number -> T
                resolved[key] = nodeMgr.mergeNode(node, resolved[key])
            end
        end
        if typeUnit.type == 'doc.type.array' then
            for n in nodeMgr.eachNode(node) do
                if n.type == 'doc.type.array' then
                    -- number[] -> T[]
                    resolve(typeUnit.node, n.node)
                end
            end
        end
        if typeUnit.type == 'doc.type.table' then
            for _, ufield in ipairs(typeUnit.fields) do
                local ufieldNode = compiler.compileNode(ufield.name)
                local uvalueNode = compiler.compileNode(ufield.extends)
                if ufieldNode.type == 'doc.generic.name' and uvalueNode.type == 'doc.generic.name' then
                    -- { [number]: number} -> { [K]: V }
                    local tfieldNode = typeMgr.getTableKey(node, 'any')
                    local tvalueNode = typeMgr.getTableValue(node, 'any')
                    resolve(ufieldNode, tfieldNode)
                    resolve(uvalueNode, tvalueNode)
                else
                    if ufieldNode.type == 'doc.generic.name' then
                        -- { [number]: number}|number[] -> { [K]: number }
                        local tnode = typeMgr.getTableKey(node, uvalueNode)
                        resolve(ufieldNode, tnode)
                    else
                        -- { [number]: number}|number[] -> { [number]: V }
                        local tnode = typeMgr.getTableValue(node, ufieldNode)
                        resolve(uvalueNode, tnode)
                    end
                end
            end
        end
    end

    for i, node in ipairs(argNodes) do
        local sign = self.signList[i]
        if not sign then
            break
        end
        for n in nodeMgr.eachNode(sign) do
            resolve(n, compiler.compileNode(node))
        end
    end

    return resolved
end

---@return vm.node.generic-manager
return function (parent)
    local genericMgr = setmetatable({
        parent   = parent,
        signList = {},
    }, mt)
    return genericMgr
end
