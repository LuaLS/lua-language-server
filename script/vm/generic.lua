---@class vm
local vm      = require 'vm.vm'

---@class parser.object
---@field package _generic vm.generic
---@field package _resolved vm.node

---@class vm.generic
---@field sign  vm.sign
---@field proto vm.object
local mt = {}
mt.__index = mt
mt.type = 'generic'

---@param source    vm.object?
---@param resolved? table<string, vm.node>
---@return vm.object?
local function cloneObject(source, resolved)
    if not resolved or not source then
        return source
    end
    if source.type == 'doc.generic.name' then
        local key = source[1]
        local newName = {
            type   = source.type,
            start  = source.start,
            finish = source.finish,
            parent = source.parent,
            [1]    = source[1],
        }
        if resolved[key] then
            vm.setNode(newName, resolved[key], true)
            newName._resolved = resolved[key]
        end
        return newName
    end
    if source.type == 'doc.type' then
        local newType = {
            type     = source.type,
            start    = source.start,
            finish   = source.finish,
            parent   = source.parent,
            optional = source.optional,
            types    = {},
        }
        for i, typeUnit in ipairs(source.types) do
            local newObj     = cloneObject(typeUnit, resolved)
            newType.types[i] = newObj
        end
        return newType
    end
    if source.type == 'doc.type.arg' then
        local newArg = {
            type    = source.type,
            start   = source.start,
            finish  = source.finish,
            parent  = source.parent,
            name    = source.name,
            extends = cloneObject(source.extends, resolved)
        }
        return newArg
    end
    if source.type == 'doc.type.array' then
        local newArray = {
            type   = source.type,
            start  = source.start,
            finish = source.finish,
            parent = source.parent,
            node   = cloneObject(source.node, resolved),
        }
        return newArray
    end
    if source.type == 'doc.type.table' then
        local newTable = {
            type   = source.type,
            start  = source.start,
            finish = source.finish,
            parent = source.parent,
            fields = {},
        }
        for i, field in ipairs(source.fields) do
            local newField = {
                type    = field.type,
                start   = field.start,
                finish  = field.finish,
                parent  = newTable,
                name    = cloneObject(field.name, resolved),
                extends = cloneObject(field.extends, resolved),
            }
            newTable.fields[i] = newField
        end
        return newTable
    end
    if source.type == 'doc.type.function' then
        local newDocFunc = {
            type    = source.type,
            start   = source.start,
            finish  = source.finish,
            parent  = source.parent,
            args    = {},
            returns = {},
        }
        for i, arg in ipairs(source.args) do
            local newObj = cloneObject(arg, resolved)
            newObj.optional    = arg.optional
            newDocFunc.args[i] = newObj
        end
        for i, ret in ipairs(source.returns) do
            local newObj  = cloneObject(ret, resolved)
            newObj.parent   = newDocFunc
            newObj.optional = ret.optional
            newDocFunc.returns[i] = cloneObject(ret, resolved)
        end
        return newDocFunc
    end
    return source
end

---@param uri uri
---@param args parser.object
---@return vm.node
function mt:resolve(uri, args)
    local resolved  = self.sign:resolve(uri, args)
    local protoNode = vm.compileNode(self.proto)
    local result = vm.createNode()
    for nd in protoNode:eachObject() do
        if nd.type == 'global' or nd.type == 'variable' then
            ---@cast nd vm.global | vm.variable
            result:merge(nd)
        else
            ---@cast nd -vm.global, -vm.variable
            local clonedObject = cloneObject(nd, resolved)
            if clonedObject then
                local clonedNode   = vm.compileNode(clonedObject)
                result:merge(clonedNode)
            end
        end
    end
    if protoNode:isOptional() then
        result:addOptional()
    end
    return result
end

---@param source parser.object
---@return vm.node?
function vm.getGenericResolved(source)
    if source.type ~= 'doc.generic.name' then
        return nil
    end
    return source._resolved
end

---@param source parser.object
---@param generic vm.generic
function vm.setGeneric(source, generic)
    source._generic = generic
end

---@param source parser.object
---@return vm.generic?
function vm.getGeneric(source)
    return source._generic
end

---@param proto vm.object
---@param sign  vm.sign
---@return vm.generic
function vm.createGeneric(proto, sign)
    local generic = setmetatable({
        sign  = sign,
        proto = proto,
    }, mt)
    return generic
end
