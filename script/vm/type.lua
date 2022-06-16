---@class vm
local vm        = require 'vm.vm'

---@param object vm.object
---@return string?
local function getNodeName(object)
    if object.type == 'global' and object.cate == 'type' then
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
    return nil
end

---@param child  vm.object
---@param parent vm.object
---@param mark?  table
---@return boolean
function vm.isSubNode(child, parent, mark)
    mark = mark or {}
    local childName  = getNodeName(child)
    local parentName = getNodeName(parent)
    if childName  == 'any'
    or parentName == 'any' then
        return true
    end

    if childName == parentName then
        return true
    end

    return false
end

---@param uri uri
---@param child  vm.node|string
---@param parent vm.node|string
---@param mark?  table
---@return boolean
function vm.isSubType(uri, child, parent, mark)
    if type(parent) == 'string' then
        parent = vm.createNode(vm.getGlobal('type', parent))
    end
    if type(child) == 'string' then
        child = vm.createNode(vm.getGlobal('type', child))
    end

    if not child or not parent then
        return false
    end

    mark = mark or {}
    for childNode in child:eachObject() do
        if not mark[childNode] then
            mark[childNode] = true
            for parentNode in parent:eachObject() do
                if vm.isSubNode(childNode, parentNode, mark) then
                    return true
                end
            end

            if childNode.type == 'global' and childNode.cate == 'type' then
                for _, set in ipairs(childNode:getSets(uri)) do
                    if set.type == 'doc.class' and set.extends then
                        for _, ext in ipairs(set.extends) do
                            if  ext.type == 'doc.extends.name'
                            and vm.isSubType(uri, ext[1], parent, mark) then
                                return true
                            end
                        end
                    end
                    if set.type == 'doc.alias' and set.extends then
                        for _, ext in ipairs(set.extends.types) do
                            if  ext.type == 'doc.type.name'
                            and vm.isSubType(uri, ext[1], parent, mark) then
                                return true
                            end
                        end
                    end
                end
            end
        end
    end

    return false
end

---@param uri uri
---@param tnode vm.node
---@param knode vm.node
---@return vm.node?
function vm.getTableValue(uri, tnode, knode)
    local result = vm.createNode()
    for tn in tnode:eachObject() do
        if tn.type == 'doc.type.table' then
            for _, field in ipairs(tn.fields) do
                if vm.isSubType(uri, vm.compileNode(field.name), knode) then
                    if field.extends then
                        result:merge(vm.compileNode(field.extends))
                    end
                end
            end
        end
        if tn.type == 'doc.type.array' then
            result:merge(vm.compileNode(tn.node))
        end
        if tn.type == 'table' then
            for _, field in ipairs(tn) do
                if field.type == 'tableindex' then
                    if field.value then
                        result:merge(vm.compileNode(field.value))
                    end
                end
                if field.type == 'tablefield' then
                    if vm.isSubType(uri, knode, 'string') then
                        if field.value then
                            result:merge(vm.compileNode(field.value))
                        end
                    end
                end
                if field.type == 'tableexp' then
                    if vm.isSubType(uri, knode, 'integer') and field.tindex == 1 then
                        if field.value then
                            result:merge(vm.compileNode(field.value))
                        end
                    end
                end
            end
        end
    end
    if result:isEmpty() then
        return nil
    end
    return result
end

---@param uri uri
---@param tnode vm.node
---@param vnode vm.node
---@return vm.node?
function vm.getTableKey(uri, tnode, vnode)
    local result = vm.createNode()
    for tn in tnode:eachObject() do
        if tn.type == 'doc.type.table' then
            for _, field in ipairs(tn.fields) do
                if field.extends then
                    if vm.isSubType(uri, vm.compileNode(field.extends), vnode) then
                        result:merge(vm.compileNode(field.name))
                    end
                end
            end
        end
        if tn.type == 'doc.type.array' then
            result:merge(vm.declareGlobal('type', 'integer'))
        end
        if tn.type == 'table' then
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
    end
    if result:isEmpty() then
        return nil
    end
    return result
end
