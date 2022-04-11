local nodeMgr   = require 'vm.node'
local compiler  = require 'vm.compiler'
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
        parent = globalMgr.getGlobal('type', parent)
    end
    if type(child) == 'string' then
        child = globalMgr.getGlobal('type', child)
    end

    if not child or not parent then
        return false
    end

    mark = mark or {}
    for childNode in nodeMgr.eachNode(child) do
        if childNode.type ~= 'global'
        or childNode.cate ~= 'type' then
            goto CONTINUE_CHILD
        end
        if mark[childNode.name] then
            return false
        end
        mark[childNode.name] = true
        for parentNode in nodeMgr.eachNode(parent) do
            if parentNode.type ~= 'global'
            or parentNode.cate ~= 'type' then
                goto CONTINUE_PARENT
            end
            if parentNode.name == 'any' or childNode.name == 'any' then
                return true
            end

            if parentNode.name == childNode.name then
                return true
            end

            for _, set in ipairs(childNode:getSets(uri)) do
                if set.type == 'doc.class' and set.extends then
                    for _, ext in ipairs(set.extends) do
                        if  ext.type == 'doc.extends.name'
                        and vm.isSubType(uri, ext[1], parentNode, mark) then
                            return true
                        end
                    end
                end
                if set.type == 'doc.alias' and set.extends then
                    for _, ext in ipairs(set.extends.types) do
                        if  ext.type == 'doc.type.name'
                        and vm.isSubType(uri, ext[1], parentNode, mark) then
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
function vm.getTableValue(uri, tnode, knode)
    local result
    for tn in nodeMgr.eachNode(tnode) do
        if tn.type == 'doc.type.table' then
            for _, field in ipairs(tn.fields) do
                if vm.isSubType(uri, compiler.compileNode(field.name), knode) then
                    result = nodeMgr.mergeNode(result, compiler.compileNode(field.extends))
                end
            end
        end
        if tn.type == 'doc.type.array' then
            result = nodeMgr.mergeNode(result, compiler.compileNode(tn.node))
        end
        if tn.type == 'table' then
            for _, field in ipairs(tn) do
                if field.type == 'tableindex' then
                    result = nodeMgr.mergeNode(result, compiler.compileNode(field.value))
                end
                if field.type == 'tablefield' then
                    if vm.isSubType(uri, knode, 'string') then
                        result = nodeMgr.mergeNode(result, compiler.compileNode(field.value))
                    end
                end
                if field.type == 'tableexp' then
                    if vm.isSubType(uri, knode, 'integer') and field.tindex == 1 then
                        result = nodeMgr.mergeNode(result, compiler.compileNode(field.value))
                    end
                end
            end
        end
    end
    return result
end

---@param uri uri
---@param tnode vm.node
---@param vnode vm.node
function vm.getTableKey(uri, tnode, vnode)
    local result
    for tn in nodeMgr.eachNode(tnode) do
        if tn.type == 'doc.type.table' then
            for _, field in ipairs(tn.fields) do
                if vm.isSubType(uri, compiler.compileNode(field.extends), vnode) then
                    result = nodeMgr.mergeNode(result, compiler.compileNode(field.name))
                end
            end
        end
        if tn.type == 'doc.type.array' then
            result = nodeMgr.mergeNode(result, globalMgr.getGlobal('type', 'integer'))
        end
        if tn.type == 'table' then
            for _, field in ipairs(tn) do
                if field.type == 'tableindex' then
                    result = nodeMgr.mergeNode(result, compiler.compileNode(field.index))
                end
                if field.type == 'tablefield' then
                    result = nodeMgr.mergeNode(result, globalMgr.getGlobal('type', 'string'))
                end
                if field.type == 'tableexp' then
                    result = nodeMgr.mergeNode(result, globalMgr.getGlobal('type', 'integer'))
                end
            end
        end
    end
    return result
end
