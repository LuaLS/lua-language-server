local nodeMgr = require 'vm.node'

---@class parser.object
---@field _generic vm.generic

---@class vm.generic
---@field sign  vm.sign
---@field proto vm.node
local mt = {}
mt.__index = mt
mt.type = 'generic'

---@param node      vm.node
---@param resolved? table<string, vm.node>
---@return vm.node
local function cloneObject(node, resolved)
    if not resolved then
        return node
    end
    if node.type == 'doc.generic.name' then
        local key = node[1]
        return resolved[key] or node
    end
    if node.type == 'doc.type' then
        local newType = {
            type   = node.type,
            start  = node.start,
            finish = node.finish,
            parent = node.parent,
            types  = {},
        }
        for i, typeUnit in ipairs(node.types) do
            local newObj     = cloneObject(typeUnit, resolved)
            newObj.parent    = newType
            newType.types[i] = newObj
        end
        return newType
    end
    if node.type == 'doc.type.arg' then
        local newArg = {
            type    = node.type,
            start   = node.start,
            finish  = node.finish,
            parent  = node.parent,
            name    = node.name,
            extends = cloneObject(node.extends, resolved)
        }
        newArg.name.parent    = newArg
        newArg.extends.parent = newArg
        return newArg
    end
    if node.type == 'doc.type.array' then
        local newArray = {
            type   = node.type,
            start  = node.start,
            finish = node.finish,
            parent = node.parent,
            node   = cloneObject(node.node, resolved),
        }
        newArray.node.parent = newArray
        return newArray
    end
    if node.type == 'doc.type.table' then
        local newTable = {
            type   = node.type,
            start  = node.start,
            finish = node.finish,
            parent = node.parent,
            fields = {},
        }
        for i, field in ipairs(node.fields) do
            local newField = {
                type    = field.type,
                start   = field.start,
                finish  = field.finish,
                parent  = newTable,
                name    = cloneObject(field.name, resolved),
                extends = cloneObject(field.extends, resolved),
            }
            newField.name.parent    = newField
            newField.extends.parent = newField
            newTable.fields[i] = newField
        end
        return newTable
    end
    if node.type == 'doc.type.function' then
        local newDocFunc = {
            type    = node.type,
            start   = node.start,
            finish  = node.finish,
            parent  = node.parent,
            args    = {},
            returns = {},
        }
        for i, arg in ipairs(node.args) do
            local newObj       = cloneObject(arg, resolved)
            newObj.parent      = newDocFunc
            newObj.optional    = arg.optional
            newDocFunc.args[i] = newObj
        end
        for i, ret in ipairs(node.returns) do
            local newObj          = cloneObject(ret, resolved)
            newObj.parent         = newDocFunc
            newObj.optional       = ret.optional
            newDocFunc.returns[i] = cloneObject(ret, resolved)
        end
        return newDocFunc
    end
    return node
end

---@param uri uri
---@param argNodes vm.node[]
---@return parser.object
function mt:resolve(uri, argNodes)
    local resolved = self.sign:resolve(uri, argNodes)
    local newProto = cloneObject(self.proto, resolved)
    return newProto
end

function mt:eachNode()
    local nodes = {}
    for n in nodeMgr.eachNode(self.proto) do
        nodes[#nodes+1] = n
    end
    local i = 0
    return function ()
        i = i + 1
        return nodes[i], self
    end
end

---@param proto vm.node
---@param sign  vm.sign
return function (proto, sign)
    local compiler = require 'vm.compiler'
    local generic = setmetatable({
        sign  = sign,
        proto = compiler.compileNode(proto),
    }, mt)
    return generic
end
