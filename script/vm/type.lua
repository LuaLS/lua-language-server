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

---@param uri uri
---@param child  vm.node|string|vm.object
---@param parent vm.node|string|vm.object
---@param mark?  table
---@return boolean
function vm.isSubType(uri, child, parent, mark)
    mark = mark or {}

    if type(child) == 'string' then
        child = vm.getGlobal('type', child)
        if not child then
            return false
        end
    elseif child.type == 'vm.node' then
        for n in child:eachObject() do
            if getNodeName(n) and not vm.isSubType(uri, n, parent, mark) then
                return false
            end
        end
        if child:isOptional() then
            if not vm.isSubType(uri, 'nil', parent, mark) then
                return false
            end
        end
        return true
    end

    if type(parent) == 'string' then
        parent = vm.getGlobal('type', parent)
        if not parent then
            return false
        end
    elseif parent.type == 'vm.node' then
        for n in parent:eachObject() do
            if getNodeName(n) and vm.isSubType(uri, child, n, mark) then
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

    local childName  = getNodeName(child)
    local parentName = getNodeName(parent)
    if childName  == 'any'
    or parentName == 'any' then
        return true
    end

    if childName == parentName then
        return true
    end

    if (childName == 'true' or childName == 'false')
    and parentName == 'boolean' then
        return true
    end

    -- check class parent
    if not mark[child] then
        mark[child] = true
        if child.type == 'global' and child.cate == 'type' then
            for _, set in ipairs(child:getSets(uri)) do
                if set.type == 'doc.class' and set.extends then
                    for _, ext in ipairs(set.extends) do
                        if  ext.type == 'doc.extends.name'
                        and vm.isSubType(uri, ext[1], parent, mark) then
                            return true
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
