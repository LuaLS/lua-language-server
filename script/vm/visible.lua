---@class vm
local vm       = require 'vm.vm'
local guide    = require 'parser.guide'
local config   = require 'config'
local glob     = require 'glob'

---@class parser.object
---@field package _visibleType? parser.visibleType

local function globMatch(patterns, fieldName)
    return glob.glob(patterns)(fieldName)
end

local function luaMatch(patterns, fieldName)
    for i = 1, #patterns do
        if string.find(fieldName, patterns[i]) then
            return true
        end
    end
    return false
end

local function getVisibleType(source)
    if guide.isLiteral(source) then
        return 'public'
    end
    if source._visibleType then
        return source._visibleType
    end
    if source.type == 'doc.field' then
        if source.visible then
            source._visibleType = source.visible
            return source.visible
        end
    end

    if source.bindDocs then
        for _, doc in ipairs(source.bindDocs) do
            if doc.type == 'doc.private' then
                source._visibleType = 'private'
                return 'private'
            end
            if doc.type == 'doc.protected' then
                source._visibleType = 'protected'
                return 'protected'
            end
            if doc.type == 'doc.package' then
                source._visibleType = 'package'
                return 'package'
            end
        end
    end

    local fieldName = guide.getKeyName(source)

    if type(fieldName) == 'string' then
        local uri = guide.getUri(source)
        local regengine = config.get(uri, 'Lua.doc.regengine')
        local match = regengine  == "glob" and globMatch or luaMatch
        local privateNames = config.get(uri, 'Lua.doc.privateName')
        if #privateNames > 0 and match(privateNames, fieldName) then
            source._visibleType = 'private'
            return 'private'
        end

        local protectedNames = config.get(uri, 'Lua.doc.protectedName')
        if #protectedNames > 0 and match(protectedNames, fieldName) then
            source._visibleType = 'protected'
            return 'protected'
        end

        local packageNames = config.get(uri, 'Lua.doc.packageName')
        if #packageNames > 0 and match(packageNames, fieldName) then
            source._visibleType = 'package'
            return 'package'
        end
    end

    source._visibleType = 'public'
    return 'public'
end

---@class vm.node
---@field package _visibleType parser.visibleType

---@param source parser.object
---@return parser.visibleType
function vm.getVisibleType(source)
    local node = vm.compileNode(source)
    if node._visibleType then
        return node._visibleType
    end
    for _, def in ipairs(vm.getDefs(source)) do
        local visible = getVisibleType(def)
        if visible ~= 'public' then
            node._visibleType = visible
            return visible
        end
    end
    node._visibleType = 'public'
    return 'public'
end

---@param source parser.object
---@return vm.global?
function vm.getParentClass(source)
    if source.type == 'doc.field' then
        return vm.getGlobalNode(source.class)
    end
    if source.type == 'setfield'
    or source.type == 'setindex'
    or source.type == 'setmethod'
    or source.type == 'tableindex' then
        return vm.getDefinedClass(guide.getUri(source), source.node)
    end

    if source.type == 'tablefield' then
        return vm.getDefinedClass(guide.getUri(source), source.node) or
                vm.getDefinedClass(guide.getUri(source), source.parent.parent)
    end
    return nil
end

---@param suri uri
---@param source parser.object
---@return vm.global?
function vm.getDefinedClass(suri, source)
    source = guide.getSelfNode(source) or source
    local sets = vm.getVariableSets(source)
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

---@param source parser.object
---@return vm.global?
local function getEnvClass(source)
    local func = guide.getParentFunction(source)
    if not func or func.type ~= 'function' then
        return nil
    end
    local parent = func.parent
    if parent.type == 'setfield'
    or parent.type == 'setmethod' then
        local node = parent.node
        return vm.getDefinedClass(guide.getUri(source), node)
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
    if visible == 'package' then
        return guide.getUri(parent) == guide.getUri(field)
    end
    local class = vm.getParentClass(field)
    if not class then
        return true
    end
    local suri = guide.getUri(parent)
    -- check     <?obj?>.x
    local myClass = vm.getDefinedClass(suri, parent)
    if not myClass then
        -- check    function <?mt?>:X() ... end
        myClass = getEnvClass(parent)
        if not myClass then
            return false
        end
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
