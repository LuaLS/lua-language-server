local util  = require 'utility'
local guide = require 'parser.guide'

---@class parser.object
---@field _localID string
---@field _localIDs table<string, parser.object[]>

---@class vm.local-id
local m = {}

m.ID_SPLITE = '\x1F'

local compileSwitch = util.switch()
    : case 'local'
    : call(function (source)
        source._localID = ('%d'):format(source.start)
        if not source.ref then
            return
        end
        for _, ref in ipairs(source.ref) do
            m.compileLocalID(ref)
        end
    end)
    : case 'getlocal'
    : call(function (source)
        source._localID = ('%d'):format(source.node.start)
        m.compileLocalID(source.next)
    end)
    : case 'getfield'
    : case 'setfield'
    : call(function (source)
        local parentID = source.node._localID
        if not parentID then
            return
        end
        source._localID = parentID .. m.ID_SPLITE .. guide.getKeyName(source)
        source.field._localID = source._localID
        if source.type == 'getfield' then
            m.compileLocalID(source.next)
        end
    end)
    : case 'getmethod'
    : case 'setmethod'
    : call(function (source)
        local parentID = source.node._localID
        if not parentID then
            return
        end
        source._localID = parentID .. m.ID_SPLITE .. guide.getKeyName(source)
        source.method._localID = source._localID
        if source.type == 'getmethod' then
            m.compileLocalID(source.next)
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
        if not type(key) ~= 'string' then
            return
        end
        source._localID = parentID .. m.ID_SPLITE .. key
        source.index._localID = source._localID
        if source.type == 'setindex' then
            m.compileLocalID(source.next)
        end
    end)

local leftSwitch = util.switch()
    : case 'field'
    : case 'method'
    : call(function (source)
        return m.getLocal(source.parent)
    end)
    : case 'getfield'
    : case 'setfield'
    : case 'getmethod'
    : case 'setmethod'
    : case 'getindex'
    : case 'setindex'
    : call(function (source)
        return m.getLocal(source.node)
    end)
    : case 'getlocal'
    : call(function (source)
        return source.node
    end)
    : case 'local'
    : call(function (source)
        return source
    end)

---@param source parser.object
---@return parser.object?
function m.getLocal(source)
    return leftSwitch(source.type, source)
end

function m.compileLocalID(source)
    if not source then
        return
    end
    source._localID = false
    if not compileSwitch:has(source.type) then
        return
    end
    compileSwitch(source.type, source)
    if not source._localID then
        return
    end
    local root = guide.getRoot(source)
    if not root._localIDs then
        root._localIDs = util.multiTable(2)
    end
    local sources = root._localIDs[source._localID]
    sources[#sources+1] = source
end

---@param source parser.object
---@return string|boolean
function m.getID(source)
    if source._localID ~= nil then
        return source._localID
    end
    source._localID = false
    local loc = m.getLocal(source)
    if not loc then
        return source._localID
    end
    m.compileLocalID(loc)
    return source._localID
end

---@param source parser.object
---@param key?   string
---@return parser.object[]?
function m.getSources(source, key)
    local id = m.getID(source)
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
        id = id .. m.ID_SPLITE .. key
    end
    return root._localIDs[id]
end

---@param source parser.object
---@return parser.object[]
function m.getFields(source)
    local id = m.getID(source)
    if not id then
        return nil
    end
    local root = guide.getRoot(source)
    if not root._localIDs then
        return nil
    end
    -- TODO：optimize
    local fields = {}
    for lid, sources in pairs(root._localIDs) do
        if  lid ~= id
        and util.stringStartWith(lid, id)
        -- only one field
        and not lid:find(m.ID_SPLITE, #id + 2) then
            for _, src in ipairs(sources) do
                fields[#fields+1] = src
            end
        end
    end
    return fields
end

return m
