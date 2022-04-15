local globalMgr = require 'vm.global-manager'
---@class vm
local vm        = require 'vm.vm'

---@param uri uri
---@param child  vm.node|string
---@param parent vm.node|string
---@param mark?  table
---@return boolean
function vm.isSubType(uri, child, parent, mark)
    if type(parent) == 'string' then
        parent = vm.createNode(globalMgr.getGlobal('type', parent))
    end
    if type(child) == 'string' then
        child = vm.createNode(globalMgr.getGlobal('type', child))
    end

    if not child or not parent then
        return false
    end

    mark = mark or {}
    for obj in child:eachObject() do
        if obj.type ~= 'global'
        or obj.cate ~= 'type' then
            goto CONTINUE_CHILD
        end
        if mark[obj.name] then
            return false
        end
        mark[obj.name] = true
        for parentNode in parent:eachObject() do
            if parentNode.type ~= 'global'
            or parentNode.cate ~= 'type' then
                goto CONTINUE_PARENT
            end
            if parentNode.name == 'any' or obj.name == 'any' then
                return true
            end

            if parentNode.name == obj.name then
                return true
            end

            for _, set in ipairs(obj:getSets(uri)) do
                if set.type == 'doc.class' and set.extends then
                    for _, ext in ipairs(set.extends) do
                        if  ext.type == 'doc.extends.name'
                        and vm.isSubType(uri, ext[1], parentNode.name, mark) then
                            return true
                        end
                    end
                end
                if set.type == 'doc.alias' and set.extends then
                    for _, ext in ipairs(set.extends.types) do
                        if  ext.type == 'doc.type.name'
                        and vm.isSubType(uri, ext[1], parentNode.name, mark) then
                            return true
                        end
                    end
                end
            end
            ::CONTINUE_PARENT::
        end
        ::CONTINUE_CHILD::
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
            result:merge(globalMgr.getGlobal('type', 'integer'))
        end
        if tn.type == 'table' then
            for _, field in ipairs(tn) do
                if field.type == 'tableindex' then
                    if field.index then
                        result:merge(vm.compileNode(field.index))
                    end
                end
                if field.type == 'tablefield' then
                    result:merge(globalMgr.getGlobal('type', 'string'))
                end
                if field.type == 'tableexp' then
                    result:merge(globalMgr.getGlobal('type', 'integer'))
                end
            end
        end
    end
    if result:isEmpty() then
        return nil
    end
    return result
end
