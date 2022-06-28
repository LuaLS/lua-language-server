local util  = require 'utility'
local guide = require 'parser.guide'
---@class vm
local vm    = require 'vm.vm'

---@class parser.object
---@field _localID string|false
---@field _localIDs table<string, { sets: parser.object[], gets: parser.object[] }>

local compileLocalID, getLocal

local compileSwitch = util.switch()
    : case 'local'
    : case 'self'
    : call(function (source)
        source._localID = ('%d'):format(source.start)
        if not source.ref then
            return
        end
        for _, ref in ipairs(source.ref) do
            compileLocalID(ref)
        end
    end)
    : case 'setlocal'
    : case 'getlocal'
    : call(function (source)
        source._localID = ('%d'):format(source.node.start)
        compileLocalID(source.next)
    end)
    : case 'getfield'
    : case 'setfield'
    : call(function (source)
        local parentID = source.node._localID
        if not parentID then
            return
        end
        local key = guide.getKeyName(source)
        if type(key) ~= 'string' then
            return
        end
        source._localID = parentID .. vm.ID_SPLITE .. key
        source.field._localID = source._localID
        if source.type == 'getfield' then
            compileLocalID(source.next)
        end
    end)
    : case 'getmethod'
    : case 'setmethod'
    : call(function (source)
        local parentID = source.node._localID
        if not parentID then
            return
        end
        local key = guide.getKeyName(source)
        if type(key) ~= 'string' then
            return
        end
        source._localID = parentID .. vm.ID_SPLITE .. key
        source.method._localID = source._localID
        if source.type == 'getmethod' then
            compileLocalID(source.next)
        end
    end)
    : case 'getindex'
    : case 'setindex'
    : call(function (source)
        local parentID = source.node._localID
        if not parentID then
            return
        end
        local key = guide.getKeyName(source)
        if type(key) ~= 'string' then
            return
        end
        source._localID = parentID .. vm.ID_SPLITE .. key
        source.index._localID = source._localID
        if source.type == 'setindex' then
            compileLocalID(source.next)
        end
    end)

local leftSwitch = util.switch()
    : case 'field'
    : case 'method'
    : call(function (source)
        return getLocal(source.parent)
    end)
    : case 'getfield'
    : case 'setfield'
    : case 'getmethod'
    : case 'setmethod'
    : case 'getindex'
    : case 'setindex'
    : call(function (source)
        return getLocal(source.node)
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
function getLocal(source)
    return leftSwitch(source.type, source)
end

---@param id string
---@param source parser.object
function vm.insertLocalID(id, source)
    local root = guide.getRoot(source)
    if not root._localIDs then
        root._localIDs = util.multiTable(2, function ()
            return {
                sets = {},
                gets = {},
            }
        end)
    end
    local sources = root._localIDs[id]
    if guide.isSet(source) then
        sources.sets[#sources.sets+1] = source
    else
        sources.gets[#sources.gets+1] = source
    end
end

function compileLocalID(source)
    if not source then
        return
    end
    source._localID = false
    if not compileSwitch:has(source.type) then
        return
    end
    compileSwitch(source.type, source)
    local id = source._localID
    if not id then
        return
    end
    vm.insertLocalID(id, source)
end

---@param source parser.object
---@return string|false
function vm.getLocalID(source)
    if source._localID ~= nil then
        return source._localID
    end
    source._localID = false
    local loc = getLocal(source)
    if not loc then
        return source._localID
    end
    compileLocalID(loc)
    return source._localID
end

---@param source parser.object
---@param key?   string
---@return parser.object[]?
function vm.getLocalSourcesSets(source, key)
    local id = vm.getLocalID(source)
    if not id then
        return nil
    end
    local root = guide.getRoot(source)
    if not root._localIDs then
        return nil
    end
    if key then
        if type(key) ~= 'string' then
            return nil
        end
        id = id .. vm.ID_SPLITE .. key
    end
    return root._localIDs[id].sets
end

---@param source parser.object
---@param key?   string
---@return parser.object[]?
function vm.getLocalSourcesGets(source, key)
    local id = vm.getLocalID(source)
    if not id then
        return nil
    end
    local root = guide.getRoot(source)
    if not root._localIDs then
        return nil
    end
    if key then
        if type(key) ~= 'string' then
            return nil
        end
        id = id .. vm.ID_SPLITE .. key
    end
    return root._localIDs[id].gets
end

---@param source parser.object
---@param includeGets boolean
---@return parser.object[]?
function vm.getLocalFields(source, includeGets)
    local id = vm.getLocalID(source)
    if not id then
        return nil
    end
    local root = guide.getRoot(source)
    if not root._localIDs then
        return nil
    end
    -- TODO：optimize
    local clock = os.clock()
    local fields = {}
    for lid, sources in pairs(root._localIDs) do
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
        log.warn('local-id getFields takes %.3f seconds', cost)
    end
    return fields
end
