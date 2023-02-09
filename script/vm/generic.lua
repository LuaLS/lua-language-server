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

local function markHasGeneric(obj)
    if obj.type == 'doc' then
        return
    end
    if obj.hasGeneric then
        return
    end
    obj.hasGeneric = true
    markHasGeneric(obj.parent)
end

---@param source    vm.object?
---@param resolved? table<parser.object, vm.node>
---@param parent?   parser.object
---@param removeUnresolved? boolean
---@return vm.object?
local function cloneObject(source, resolved, parent, removeUnresolved)
    if not source then
        return source
    end
    if not source.hasGeneric then
        return source
    end
    if source.type == 'doc.generic.name' then
        local generic = source.generic
        local newName = {
            type    = source.type,
            start   = source.start,
            finish  = source.finish,
            parent  = parent or source.parent,
            generic = source.generic,
            cloned  = true,
            [1]     = source[1],
        }
        local resolvedNode = resolved and resolved[generic]
        if not resolvedNode then
            if removeUnresolved then
                newName.type = 'doc.generic.resolved'
            else
                markHasGeneric(newName)
            end
            return newName
        end

        vm.setNode(newName, resolvedNode, true)
        newName._resolved = resolvedNode
        local hasGeneric
        for n in resolvedNode:eachObject() do
            if n.type == 'doc.generic.name' then
                hasGeneric = true
                break
            end
        end

        if hasGeneric then
            markHasGeneric(newName)
        else
            newName.type = 'doc.generic.resolved'
        end

        return newName
    end
    if source.type == 'doc.type' then
        local newType = {
            type     = source.type,
            start    = source.start,
            finish   = source.finish,
            parent   = parent or source.parent,
            optional = source.optional,
            cloned   = true,
            types    = {},
        }
        for i, typeUnit in ipairs(source.types) do
            local newObj     = cloneObject(typeUnit, resolved, newType)
            newType.types[i] = newObj
        end
        return newType
    end
    if source.type == 'doc.type.arg' then
        local newArg = {
            type    = source.type,
            start   = source.start,
            finish  = source.finish,
            parent  = parent or source.parent,
            name    = source.name,
            cloned  = true,
        }
        newArg.extends = cloneObject(source.extends, resolved, newArg)
        return newArg
    end
    if source.type == 'doc.type.array' then
        local newArray = {
            type   = source.type,
            start  = source.start,
            finish = source.finish,
            parent = parent or source.parent,
            cloned = true,
        }
        newArray.node   = cloneObject(source.node, resolved, newArray)
        return newArray
    end
    if source.type == 'doc.type.table' then
        local newTable = {
            type   = source.type,
            start  = source.start,
            finish = source.finish,
            parent = parent or source.parent,
            cloned = true,
            fields = {},
        }
        for i, field in ipairs(source.fields) do
            if field.hasGeneric then
                local newField = {
                    type    = field.type,
                    start   = field.start,
                    finish  = field.finish,
                    parent  = newTable,
                    cloned  = true,
                }
                newField.name    = cloneObject(field.name, resolved, newField)
                newField.extends = cloneObject(field.extends, resolved, newField)
                newTable.fields[i] = newField
            else
                newTable.fields[i] = field
            end
        end
        return newTable
    end
    if source.type == 'doc.type.function' then
        local newDocFunc = {
            type    = source.type,
            start   = source.start,
            finish  = source.finish,
            parent  = parent or source.parent,
            cloned  = true,
            args    = {},
            returns = {},
        }
        for i, arg in ipairs(source.args) do
            local newObj = cloneObject(arg, resolved, newDocFunc)
            newObj.optional    = arg.optional
            newDocFunc.args[i] = newObj
        end
        for i, ret in ipairs(source.returns) do
            local newObj  = cloneObject(ret, resolved, newDocFunc)
            newObj.optional = ret.optional
            newDocFunc.returns[i] = cloneObject(ret, resolved, newDocFunc)
        end
        return newDocFunc
    end
    return source
end

---@param uri uri
---@param args parser.object
---@param removeUnresolved? boolean
---@return vm.node
function mt:resolve(uri, args, removeUnresolved)
    local resolved  = self.sign:resolve(uri, args)
    local protoNode = vm.compileNode(self.proto)
    local result = vm.createNode()
    for nd in protoNode:eachObject() do
        if nd.type == 'global' then
            ---@cast nd vm.global
            if nd.cate == 'variable' then
                result:merge(nd)
            end
            if nd.cate == 'type' then
                if not nd:getSigns(uri) then
                    result:merge(nd)
                end
            end
        elseif nd.type == 'variable' then
            ---@cast nd vm.variable
            result:merge(nd)
        else
            ---@cast nd -vm.global, -vm.variable
            local clonedObject = cloneObject(nd, resolved, nil, removeUnresolved)
            if clonedObject then
                local clonedNode   = vm.compileNode(clonedObject)
                result:merge(clonedNode)
            end
        end
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
    proto._generic = generic
    return generic
end
