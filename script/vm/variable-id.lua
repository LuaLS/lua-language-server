local util  = require 'utility'
local guide = require 'parser.guide'
---@class vm
local vm    = require 'vm.vm'

---@class vm.variable
---@field sets parser.object[]
---@field gets parser.object[]

---@class parser.object
---@field package _variableID string|false
---@field package _variableIDs table<string, vm.variable>

local compileVariableID, getVariable

local compileSwitch = util.switch()
    : case 'local'
    : case 'self'
    : call(function (source)
        source._variableID = ('l|%d'):format(source.start)
        if not source.ref then
            return
        end
        for _, ref in ipairs(source.ref) do
            compileVariableID(ref)
        end
    end)
    : case 'setlocal'
    : case 'getlocal'
    : call(function (source)
        source._variableID = ('l|%d'):format(source.node.start)
        compileVariableID(source.next)
    end)
    : case 'getfield'
    : case 'setfield'
    : call(function (source)
        local parentID = source.node._variableID
        if not parentID then
            return
        end
        local key = guide.getKeyName(source)
        if type(key) ~= 'string' then
            return
        end
        source._variableID = parentID .. vm.ID_SPLITE .. key
        source.field._variableID = source._variableID
        if source.type == 'getfield' then
            compileVariableID(source.next)
        end
    end)
    : case 'getmethod'
    : case 'setmethod'
    : call(function (source)
        local parentID = source.node._variableID
        if not parentID then
            return
        end
        local key = guide.getKeyName(source)
        if type(key) ~= 'string' then
            return
        end
        source._variableID = parentID .. vm.ID_SPLITE .. key
        source.method._variableID = source._variableID
        if source.type == 'getmethod' then
            compileVariableID(source.next)
        end
    end)
    : case 'getindex'
    : case 'setindex'
    : call(function (source)
        local parentID = source.node._variableID
        if not parentID then
            return
        end
        local key = guide.getKeyName(source)
        if type(key) ~= 'string' then
            return
        end
        source._variableID = parentID .. vm.ID_SPLITE .. key
        source.index._variableID = source._variableID
        if source.type == 'setindex' then
            compileVariableID(source.next)
        end
    end)

local leftSwitch = util.switch()
    : case 'field'
    : case 'method'
    : call(function (source)
        return getVariable(source.parent)
    end)
    : case 'getfield'
    : case 'setfield'
    : case 'getmethod'
    : case 'setmethod'
    : case 'getindex'
    : case 'setindex'
    : call(function (source)
        return getVariable(source.node)
    end)
    : case 'getlocal'
    : call(function (source)
        return source.node
    end)
    : case 'local'
    : case 'self'
    : call(function (source)
        return source
    end)

---@param source parser.object
---@return parser.object?
function getVariable(source)
    return leftSwitch(source.type, source)
end

---@param id string
---@param source parser.object
function vm.insertVariableID(id, source)
    local root = guide.getRoot(source)
    if not root._variableIDs then
        root._variableIDs = util.multiTable(2, function ()
            return {
                sets = {},
                gets = {},
            }
        end)
    end
    local sources = root._variableIDs[id]
    if guide.isSet(source) then
        sources.sets[#sources.sets+1] = source
    else
        sources.gets[#sources.gets+1] = source
    end
end

function compileVariableID(source)
    if not source then
        return
    end
    source._variableID = false
    if not compileSwitch:has(source.type) then
        return
    end
    compileSwitch(source.type, source)
    local id = source._variableID
    if not id then
        return
    end
    vm.insertVariableID(id, source)
end

---@param source parser.object
---@return string|false
function vm.getVariableID(source)
    if source._variableID ~= nil then
        return source._variableID
    end
    source._variableID = false
    local loc = getVariable(source)
    if not loc then
        return source._variableID
    end
    compileVariableID(loc)
    return source._variableID
end

---@param source parser.object
---@param key?   string
---@return vm.variable?
function vm.getVariableInfo(source, key)
    local id = vm.getVariableID(source)
    if not id then
        return nil
    end
    local root = guide.getRoot(source)
    if not root._variableIDs then
        return nil
    end
    if key then
        if type(key) ~= 'string' then
            return nil
        end
        id = id .. vm.ID_SPLITE .. key
    end
    return root._variableIDs[id]
end

---@param source parser.object
---@param key?   string
---@return parser.object[]?
function vm.getVariableSets(source, key)
    local localInfo = vm.getVariableInfo(source, key)
    if not localInfo then
        return nil
    end
    return localInfo.sets
end

---@param source parser.object
---@param key?   string
---@return parser.object[]?
function vm.getVariableGets(source, key)
    local localInfo = vm.getVariableInfo(source, key)
    if not localInfo then
        return nil
    end
    return localInfo.gets
end

---@param source parser.object
---@param includeGets boolean
---@return parser.object[]?
function vm.getVariableFields(source, includeGets)
    local id = vm.getVariableID(source)
    if not id then
        return nil
    end
    local root = guide.getRoot(source)
    if not root._variableIDs then
        return nil
    end
    -- TODO：optimize
    local clock = os.clock()
    local fields = {}
    for lid, sources in pairs(root._variableIDs) do
        if  lid ~= id
        and util.stringStartWith(lid, id)
        and lid:sub(#id + 1, #id + 1) == vm.ID_SPLITE
        -- only one field
        and not lid:find(vm.ID_SPLITE, #id + 2) then
            for _, src in ipairs(sources.sets) do
                fields[#fields+1] = src
            end
            if includeGets then
                for _, src in ipairs(sources.gets) do
                    fields[#fields+1] = src
                end
            end
        end
    end
    local cost = os.clock() - clock
    if cost > 1.0 then
        log.warn('variable-id getFields takes %.3f seconds', cost)
    end
    return fields
end
