local util          = require 'utility'
local guide         = require 'parser.guide'
local globalBuilder = require 'vm.node.global'

---@class parser.object
---@field _globalNode vm.node.global

---@class vm.global-manager
local m = {}
---@type table<string, vm.node.global>
m.globals = {}
---@type table<uri, table<string, boolean>>
m.globalSubs = util.multiTable(2)

m.ID_SPLITE = '\x1F'

local compilerGlobalMap = util.switch()
    : case 'local'
    : call(function (uri, source)
        if source.tag ~= '_ENV' then
            return
        end
        if source.ref then
            for _, ref in ipairs(source.ref) do
                m.compileObject(uri, ref)
            end
        end
    end)
    : case 'setglobal'
    : call(function (uri, source)
        local name   = guide.getKeyName(source)
        local global = m.declareGlobal(name, uri)
        global:addSet(uri, source)
        source._globalNode = global
    end)
    : case 'getglobal'
    : call(function (uri, source)
        local name   = guide.getKeyName(source)
        local global = m.declareGlobal(name, uri)
        global:addGet(uri, source)
        source._globalNode = global

        local nxt = source.next
        if nxt then
            m.compileObject(uri, nxt)
        end
    end)
    : case 'setfield'
    : case 'setmethod'
    : case 'setindex'
    ---@param uri    uri
    ---@param source parser.object
    : call(function (uri, source)
        local parent = source.node._globalNode
        if not parent then
            return
        end
        local name   = parent:getName() .. m.ID_SPLITE .. guide.getKeyName(source)
        local global = m.declareGlobal(name, uri)
        global:addSet(uri, source)
        source._globalNode = global
    end)
    : case 'getfield'
    : case 'getmethod'
    : case 'getindex'
    ---@param uri    uri
    ---@param source parser.object
    : call(function (uri, source)
        local parent = source.node._globalNode
        if not parent then
            return
        end
        local name = parent:getName() .. m.ID_SPLITE .. guide.getKeyName(source)
        local global = m.declareGlobal(name, uri)
        global:addGet(uri, source)
        source._globalNode = global

        local nxt = source.next
        if nxt then
            m.compileObject(uri, nxt)
        end
    end)
    : getMap()


---@param name   string
---@param uri    uri
---@return vm.node.global
function m.declareGlobal(name, uri)
    m.globalSubs[uri][name] = true
    if not m.globals[name] then
        m.globals[name] = globalBuilder(name)
    end
    return m.globals[name]
end

---@param name string
---@param field? string
---@return vm.node.global?
function m.getGlobal(name, field)
    if field then
        name = name .. m.ID_SPLITE .. field
    end
    return m.globals[name]
end

---@param source parser.object
function m.compileObject(uri, source)
    if source._globalNode ~= nil then
        return
    end
    source._globalNode = false
    local compiler = compilerGlobalMap[source.type]
    if compiler then
        compiler(uri, source)
    end
end

---@param source parser.object
function m.compileAst(source)
    local uri = guide.getUri(source)
    local env = guide.getENV(source)
    m.compileObject(uri, env)
end

---@return vm.node.global
function m.getNode(source)
    if source.type == 'field'
    or source.type == 'method' then
        source = source.parent
    end
    return source._globalNode
end

---@param uri uri
function m.dropUri(uri)
    local globalSub = m.globalSubs[uri]
    m.globalSubs[uri] = nil
    for name in pairs(globalSub) do
        local global = m.globals[name]
        global:dropUri(uri)
        if not global:isAlive() then
            m.globals[name] = nil
        end
    end
end

return m
