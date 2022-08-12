---@class vm
local vm        = require 'vm.vm'
local guide     = require 'parser.guide'
local config    = require 'config.config'
local util      = require 'utility'

---@param object vm.node.object
---@return string?
local function getNodeName(object)
    if object.type == 'global' and object.cate == 'type' then
        ---@cast object vm.global
        return object.name
    end
    if object.type == 'nil'
    or object.type == 'boolean'
    or object.type == 'number'
    or object.type == 'string'
    or object.type == 'table'
    or object.type == 'function'
    or object.type == 'integer' then
        return object.type
    end
    if object.type == 'doc.type.boolean' then
        return 'boolean'
    end
    if object.type == 'doc.type.integer' then
        return 'integer'
    end
    if object.type == 'doc.type.function' then
        return 'function'
    end
    if object.type == 'doc.type.table' then
        return 'table'
    end
    if object.type == 'doc.type.array' then
        return 'table'
    end
    if object.type == 'doc.type.string' then
        return 'string'
    end
    return nil
end

---@param parentName string
---@param child      vm.node.object
---@param uri        uri
---@return boolean?
local function checkEnum(parentName, child, uri)
    local parentClass = vm.getGlobal('type', parentName)
    if not parentClass then
        return nil
    end
    for _, set in ipairs(parentClass:getSets(uri)) do
        if set.type == 'doc.enum' then
            if not set._enums then
                return false
            end
            if  child.type ~= 'string'
            and child.type ~= 'doc.type.string'
            and child.type ~= 'integer'
            and child.type ~= 'number'
            and child.type ~= 'doc.type.integer' then
                return false
            end
            return util.arrayHas(set._enums, child[1])
        end
    end

    return nil
end

---@param parent vm.node.object
---@param child  vm.node.object
---@return boolean
local function checkValue(parent, child)
    if parent.type == 'doc.type.integer' then
        if child.type == 'integer'
        or child.type == 'doc.type.integer'
        or child.type == 'number' then
            return parent[1] == child[1]
        end
    elseif parent.type == 'doc.type.string' then
        if child.type == 'string'
        or child.type == 'doc.type.string' then
            return parent[1] == child[1]
        end
    end

    return true
end

---@param uri uri
---@param child  vm.node|string|vm.node.object
---@param parent vm.node|string|vm.node.object
---@param mark?  table
---@return boolean
function vm.isSubType(uri, child, parent, mark)
    mark = mark or {}

    if type(child) == 'string' then
        local global = vm.getGlobal('type', child)
        if not global then
            return false
        end
        child = global
    elseif child.type == 'vm.node' then
        if config.get(uri, 'Lua.type.weakUnionCheck') then
            local hasKnownType
            for n in child:eachObject() do
                if getNodeName(n) then
                    hasKnownType = true
                    if vm.isSubType(uri, n, parent, mark) then
                        return true
                    end
                end
            end
            return not hasKnownType
        else
            local weakNil   = config.get(uri, 'Lua.type.weakNilCheck')
            for n in child:eachObject() do
                local nodeName = getNodeName(n)
                if  nodeName
                and not (nodeName == 'nil' and weakNil)
                and not vm.isSubType(uri, n, parent, mark) then
                    return false
                end
            end
            if not weakNil and child:isOptional() then
                if not vm.isSubType(uri, 'nil', parent, mark) then
                    return false
                end
            end
            return true
        end
    end

    if type(parent) == 'string' then
        local global = vm.getGlobal('type', parent)
        if not global then
            return false
        end
        parent = global
    elseif parent.type == 'vm.node' then
        for n in parent:eachObject() do
            if  getNodeName(n)
            and vm.isSubType(uri, child, n, mark) then
                return true
            end
            if n.type == 'doc.generic.name' then
                return true
            end
        end
        if parent:isOptional() then
            if vm.isSubType(uri, child, 'nil', mark) then
                return true
            end
        end
        return false
    end

    ---@cast child  vm.node.object
    ---@cast parent vm.node.object

    local childName  = getNodeName(child)
    local parentName = getNodeName(parent)
    if childName  == 'any'
    or parentName == 'any'
    or childName  == 'unknown'
    or parentName == 'unknown'
    or not childName
    or not parentName then
        return true
    end

    if childName == parentName then
        if not checkValue(parent, child) then
            return false
        end
        return true
    end

    if parentName == 'number' and childName == 'integer' then
        return true
    end

    if parentName == 'integer' and childName == 'number' then
        if config.get(uri, 'Lua.type.castNumberToInteger') then
            return true
        end
        if  child.type == 'number'
        and child[1]
        and not math.tointeger(child[1]) then
            return false
        end
        if  child.type == 'global'
        and child.cate == 'type' then
            return false
        end
        return true
    end

    local isEnum = checkEnum(parentName, child, uri)
    if isEnum ~= nil then
        return isEnum
    end

    -- TODO: check duck
    if parentName == 'table' and not guide.isBasicType(childName) then
        return true
    end
    if childName == 'table' and not guide.isBasicType(parentName) then
        return true
    end

    -- check class parent
    if childName and not mark[childName] then
        mark[childName] = true
        local isBasicType = guide.isBasicType(childName)
        local childClass = vm.getGlobal('type', childName)
        if childClass then
            for _, set in ipairs(childClass:getSets(uri)) do
                if set.type == 'doc.class' and set.extends then
                    for _, ext in ipairs(set.extends) do
                        if  ext.type == 'doc.extends.name'
                        and (not isBasicType or guide.isBasicType(ext[1]))
                        and vm.isSubType(uri, ext[1], parent, mark) then
                            return true
                        end
                    end
                end
                if set.type == 'doc.alias'
                or set.type == 'doc.enum' then
                    return true
                end
            end
        end
        mark[childName] = nil
    end

    --[[
    ---@class A: string

    ---@type A
    local x = '' --> `string` set to `A`
    ]]
    if  guide.isBasicType(childName)
    and guide.isLiteral(child)
    and vm.isSubType(uri, parentName, childName) then
        return true
    end

    return false
end

---@param node string|vm.node|vm.object
function vm.isUnknown(node)
    if type(node) == 'string' then
        return node == 'unknown'
    end
    if node.type == 'vm.node' then
        return not node:hasKnownType()
    end
    return false
end

---@param uri uri
---@param tnode vm.node
---@param knode vm.node|string
---@param inversion? boolean
---@return vm.node?
function vm.getTableValue(uri, tnode, knode, inversion)
    local result = vm.createNode()
    for tn in tnode:eachObject() do
        if tn.type == 'doc.type.table' then
            for _, field in ipairs(tn.fields) do
                if  field.name.type ~= 'doc.field.name'
                and field.extends then
                    if inversion then
                        if vm.isSubType(uri, vm.compileNode(field.name), knode) then
                            result:merge(vm.compileNode(field.extends))
                        end
                    else
                        if vm.isSubType(uri, knode, vm.compileNode(field.name)) then
                            result:merge(vm.compileNode(field.extends))
                        end
                    end
                end
            end
        end
        if tn.type == 'doc.type.array' then
            result:merge(vm.compileNode(tn.node))
        end
        if tn.type == 'table' then
            if vm.isUnknown(knode) then
                goto CONTINUE
            end
            for _, field in ipairs(tn) do
                if  field.type == 'tableindex'
                and field.value then
                    result:merge(vm.compileNode(field.value))
                end
                if  field.type == 'tablefield'
                and field.value then
                    if inversion then
                        if vm.isSubType(uri, 'string', knode) then
                            result:merge(vm.compileNode(field.value))
                        end
                    else
                        if vm.isSubType(uri, knode, 'string') then
                            result:merge(vm.compileNode(field.value))
                        end
                    end
                end
                if  field.type == 'tableexp'
                and field.value
                and field.tindex == 1 then
                    if inversion then
                        if vm.isSubType(uri, 'integer', knode)  then
                            result:merge(vm.compileNode(field.value))
                        end
                    else
                        if vm.isSubType(uri, knode, 'integer')  then
                            result:merge(vm.compileNode(field.value))
                        end
                    end
                end
                if field.type == 'varargs' then
                    result:merge(vm.compileNode(field))
                end
            end
        end
        ::CONTINUE::
    end
    if result:isEmpty() then
        return nil
    end
    return result
end

---@param uri uri
---@param tnode vm.node
---@param vnode vm.node|string|vm.object
---@param reverse? boolean
---@return vm.node?
function vm.getTableKey(uri, tnode, vnode, reverse)
    local result = vm.createNode()
    for tn in tnode:eachObject() do
        if tn.type == 'doc.type.table' then
            for _, field in ipairs(tn.fields) do
                if  field.name.type ~= 'doc.field.name'
                and field.extends then
                    if reverse then
                        if vm.isSubType(uri, vm.compileNode(field.extends), vnode) then
                            result:merge(vm.compileNode(field.name))
                        end
                    else
                        if vm.isSubType(uri, vnode, vm.compileNode(field.extends)) then
                            result:merge(vm.compileNode(field.name))
                        end
                    end
                end
            end
        end
        if tn.type == 'doc.type.array' then
            result:merge(vm.declareGlobal('type', 'integer'))
        end
        if tn.type == 'table' then
            if vm.isUnknown(tnode) then
                goto CONTINUE
            end
            for _, field in ipairs(tn) do
                if field.type == 'tableindex' then
                    if field.index then
                        result:merge(vm.compileNode(field.index))
                    end
                end
                if field.type == 'tablefield' then
                    result:merge(vm.declareGlobal('type', 'string'))
                end
                if field.type == 'tableexp' then
                    result:merge(vm.declareGlobal('type', 'integer'))
                end
            end
        end
        ::CONTINUE::
    end
    if result:isEmpty() then
        return nil
    end
    return result
end

---@param uri uri
---@param defNode vm.node
---@param refNode vm.node
---@return boolean
function vm.canCastType(uri, defNode, refNode)
    local defInfer = vm.getInfer(defNode)
    local refInfer = vm.getInfer(refNode)

    if defInfer:hasAny(uri) then
        return true
    end
    if refInfer:hasAny(uri) then
        return true
    end
    if defInfer:view(uri) == 'unknown' then
        return true
    end
    if refInfer:view(uri) == 'unknown' then
        return true
    end

    if vm.isSubType(uri, refNode, 'nil') then
        -- allow `local x = {};x = nil`,
        -- but not allow `local x ---@type table;x = nil`
        if  defInfer:hasType(uri, 'table')
        and not defNode:hasType 'table' then
            return true
        end
    end

    if vm.isSubType(uri, refNode, 'number') then
        -- allow `local x = 0;x = 1.0`,
        -- but not allow `local x ---@type integer;x = 1.0`
        if  defInfer:hasType(uri, 'integer')
        and not defNode:hasType 'integer' then
            return true
        end
    end

    if vm.isSubType(uri, refNode, defNode) then
        return true
    end

    return false
end
