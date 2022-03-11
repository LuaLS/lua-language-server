local nodeMgr   = require 'vm.node'
local compiler  = require 'vm.compiler'
local globalMgr = require 'vm.global-manager'

---@class vm.type-manager
local m = {}

---@param child  vm.node
---@param parent vm.node
---@return boolean
function m.isSubType(child, parent, mark)
    if type(parent) == 'string' then
        parent = globalMgr.getGlobal('type', parent)
    end
    if type(child) == 'string' then
        child = globalMgr.getGlobal('type', child)
    end

    if parent.type == 'global' and parent.cate == 'type' and parent.name == 'any' then
        return true
    end

    if child.type == 'doc.type' then
        for _, typeUnit in ipairs(child.types) do
            if not m.isSubType(typeUnit, parent) then
                return false
            end
        end
        return true
    end

    if child.type == 'doc.type.name' then
        child = globalMgr.getGlobal('type', child[1])
    end

    if child.type == 'global' and child.cate == 'type' then
        if parent.type == 'doc.type' then
            for _, typeUnit in ipairs(parent.types) do
                if m.isSubType(child, typeUnit) then
                    return true
                end
            end
        end

        if parent.type == 'doc.type.name' then
            parent = globalMgr.getGlobal('type', parent[1])
        end

        if parent.type == 'global' and parent.cate == 'type' then
            if parent.name == child.name then
                return true
            end
            mark = mark or {}
            if mark[child.name] then
                return false
            end
            mark[child.name] = true
            for _, set in ipairs(child:getSets()) do
                if set.type == 'doc.class' and set.extends then
                    for _, ext in ipairs(set.extends) do
                        if m.isSubType(globalMgr.getGlobal('type', ext[1]), parent, mark) then
                            return true
                        end
                    end
                end
            end
        end
    end

    return false
end

---@param tnode vm.node
---@param knode vm.node
function m.getTableValue(tnode, knode)
    local result
    for tn in nodeMgr.eachNode(tnode) do
        if tn.type == 'doc.type.table' then
            for _, field in ipairs(tn.fields) do
                if m.isSubType(field.name, knode) then
                    result = nodeMgr.mergeNode(result, compiler.compileNode(field.extends))
                end
            end
        end
        if tn.type == 'doc.type.array' then
            if m.isSubType(globalMgr.getGlobal('type', 'integer'), knode) then
                result = nodeMgr.mergeNode(result, compiler.compileNode(tn.node))
            end
        end
        if tn.type == 'table' then
            for _, field in ipairs(tn) do
                if field.type == 'tableindex' then
                    result = nodeMgr.mergeNode(result, compiler.compileNode(field.value))
                end
                if field.type == 'tablefield' then
                    result = nodeMgr.mergeNode(result, compiler.compileNode(field.value))
                end
                if field.type == 'tableexp' then
                    result = nodeMgr.mergeNode(result, compiler.compileNode(field.value))
                end
            end
        end
    end
    return result
end

---@param tnode vm.node
---@param vnode vm.node
function m.getTableKey(tnode, vnode)
    local result
    for tn in nodeMgr.eachNode(tnode) do
        if tn.type == 'doc.type.table' then
            for _, field in ipairs(tn.fields) do
                if m.isSubType(field.extends, vnode) then
                    result = nodeMgr.mergeNode(result, compiler.compileNode(field.name))
                end
            end
        end
        if tn.type == 'doc.type.array' then
            if m.isSubType(tn.node, vnode) then
                result = nodeMgr.mergeNode(result, globalMgr.getGlobal('type', 'integer'))
            end
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

return m
