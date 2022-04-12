local nodeMgr = require 'vm.node'
local union   = require 'vm.union'

---@class parser.object
---@field _generic vm.generic

---@class vm.generic
---@field sign  vm.sign
---@field proto vm.node
local mt = {}
mt.__index = mt
mt.type = 'generic'

---@param source    parser.object
---@param resolved? table<string, vm.node>
---@return vm.node
local function cloneObject(source, resolved)
    if not resolved then
        return source
    end
    if source.type == 'doc.generic.name' then
        local key = source[1]
        if not resolved[key] then
            return source
        end
        return resolved[key] or source
    end
    if source.type == 'doc.type' then
        local newType = {
            type   = source.type,
            start  = source.start,
            finish = source.finish,
            parent = source.parent,
            types  = {},
        }
        for i, typeUnit in ipairs(source.types) do
            local newObj     = cloneObject(typeUnit, resolved)
            newObj.parent    = newType
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
        newArg.name.parent    = newArg
        newArg.extends.parent = newArg
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
        newArray.node.parent = newArray
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
            newField.name.parent    = newField
            newField.extends.parent = newField
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
            local newObj       = cloneObject(arg, resolved)
            newObj.parent      = newDocFunc
            newObj.optional    = arg.optional
            newDocFunc.args[i] = newObj
        end
        for i, ret in ipairs(source.returns) do
            local newObj          = cloneObject(ret, resolved)
            newObj.parent         = newDocFunc
            newObj.optional       = ret.optional
            newDocFunc.returns[i] = cloneObject(ret, resolved)
        end
        return newDocFunc
    end
    return source
end

---@param uri uri
---@param args parser.object
---@return parser.object
function mt:resolve(uri, args)
    local resolved = self.sign:resolve(uri, args)
    local result = union()
    for nd in nodeMgr.eachObject(self.proto) do
        result:merge(cloneObject(nd, resolved))
    end
    return result
end

---@param proto vm.node
---@param sign  vm.sign
return function (proto, sign)
    local generic = setmetatable({
        sign  = sign,
        proto = proto,
    }, mt)
    return generic
end
