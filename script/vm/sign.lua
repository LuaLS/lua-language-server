local guide         = require 'parser.guide'
local nodeMgr       = require 'vm.node'
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
---@return table<string, vm.node>
function mt:resolve(uri, args)
    if not args then
        return nil
    end
    local globalMgr = require 'vm.global-manager'
    local resolved = {}

    ---@param typeUnit parser.object
    ---@param node     vm.node
    local function resolve(typeUnit, node)
        if typeUnit.type == 'doc.generic.name' then
            local key = typeUnit[1]
            if typeUnit.literal then
                -- 'number' -> `T`
                for n in nodeMgr.eachObject(node) do
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
            for n in nodeMgr.eachObject(node) do
                if n.type == 'doc.type.array' then
                    -- number[] -> T[]
                    resolve(typeUnit.node, vm.compileNode(n.node))
                end
            end
        end
        if typeUnit.type == 'doc.type.table' then
            for _, ufield in ipairs(typeUnit.fields) do
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

    for i, arg in ipairs(args) do
        local sign = self.signList[i]
        if not sign then
            break
        end
        for n in nodeMgr.eachObject(sign) do
            local argNode = vm.compileNode(arg)
            if argNode then
                if sign.optional then
                    argNode = nodeMgr.removeOptional(argNode)
                end
                resolve(n, argNode)
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
