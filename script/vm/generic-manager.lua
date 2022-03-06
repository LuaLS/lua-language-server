local createGeneric = require 'vm.generic'
local globalMgr     = require 'vm.global-manager'
local guide         = require 'parser.guide'
local nodeMgr       = require 'vm.node'

---@class vm.node.generic-manager
---@field parent   parser.object
---@field signList parser.object[]
local mt = {}
mt.__index = mt
mt.type = 'generic-manager'

---@param key parser.object
function mt:addSign(key)
    self.signList[#self.signList+1] = key
end

---@param node vm.node
function mt:getChild(node)
    local generic = createGeneric(self, node)
    return generic
end

---@param argNodes vm.node[]
---@return table<string, vm.node>
function mt:resolve(argNodes)
    local typeMgr  = require 'vm.type'
    local compiler = require 'vm.compiler'
    local resolved = {}

    ---@param typeUnit parser.object
    ---@param node     vm.node
    local function resolve(typeUnit, node)
        if typeUnit.type == 'doc.generic.name' then
            local key = typeUnit[1]
            if typeUnit.literal then
                for n in nodeMgr.eachNode(node) do
                    if n.type == 'string' then
                        local type = globalMgr.declareGlobal('type', n[1], guide.getUri(n))
                        resolved[key] = nodeMgr.mergeNode(type, resolved[key])
                    end
                end
            else
                resolved[key] = nodeMgr.mergeNode(node, resolved[key])
            end
        end
        if typeUnit.type == 'doc.type.array' then
            for n in nodeMgr.eachNode(node) do
                if n.type == 'doc.type.array' then
                    resolve(typeUnit.node, n.node)
                end
            end
        end
        if typeUnit.type == 'doc.type.table' then
            for _, ufield in ipairs(typeUnit.fields) do
                local utype = ufield.name
                local tnode = typeMgr.getTableValue(node, utype)
                resolve(compiler.compileNode(ufield.extends), tnode)
            end
        end
    end

    for i, node in ipairs(argNodes) do
        local sign = self.signList[i]
        if not sign then
            break
        end
        for _, typeUnit in ipairs(sign.types) do
            resolve(typeUnit, node)
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
