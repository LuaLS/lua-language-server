---@class vm
local vm       = require 'vm.vm'
local guide    = require 'parser.guide'

---@param source parser.object
---@return 'public' | 'protected' | 'private'
function vm.getVisibleType(source)
    if source.type == 'doc.field' then
        return source.visible or 'public'
    end
    return 'public'
end

---@param source parser.object
---@return vm.global?
function vm.getParentClass(source)
    if source.type == 'doc.field' then
        return vm.getGlobalNode(source.class)
    end
    return nil
end

---@param suri uri
---@param source parser.object
---@return vm.global?
function vm.getDefinedClass(suri, source)
    local sets = vm.getLocalSourcesSets(source)
    if sets then
        for _, set in ipairs(sets) do
            if set.bindDocs then
                for _, doc in ipairs(set.bindDocs) do
                    if doc.type == 'doc.class' then
                        return vm.getGlobalNode(doc)
                    end
                end
            end
        end
    end
    local global = vm.getGlobalNode(source)
    if global then
        for _, set in ipairs(global:getSets(suri)) do
            if set.bindDocs then
                for _, doc in ipairs(set.bindDocs) do
                    if doc.type == 'doc.class' then
                        return vm.getGlobalNode(doc)
                    end
                end
            end
        end
    end
    return nil
end

---@param parent parser.object
---@param field parser.object
function vm.isVisible(parent, field)
    local visible = vm.getVisibleType(field)
    if visible == 'public' then
        return true
    end
    local class = vm.getParentClass(field)
    if not class then
        return true
    end
    local suri = guide.getUri(parent)
    local myClass = vm.getDefinedClass(suri, parent)
    if not myClass then
        return false
    end
    if myClass == class then
        return true
    end
    if visible == 'protected' then
        if vm.isSubType(suri, myClass, class) then
            return true
        end
    end
    return false
end
