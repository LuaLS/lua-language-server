local util          = require 'utility'
local guide         = require 'parser.guide'
local globalBuilder = require 'vm.node.global'

---@class parser.object
---@field _globalNode vm.node.global

---@class vm.global-manager
local m = {}
---@type table<string, vm.node.global>
m.globals = util.defaultTable(globalBuilder)
---@type table<uri, table<string, boolean>>
m.globalSubs = util.defaultTable(function ()
    return {}
end)

m.ID_SPLITE = '\x1F'

local compilerGlobalMap = util.switch()
    : case 'local'
    : call(function (uri, source)
        if source.tag ~= '_ENV' then
            return
        end
        if source.ref then
            for _, ref in ipairs(source.ref) do
                m.compileNode(uri, ref)
            end
        end
    end)
    : case 'setglobal'
    : call(function (uri, source)
        local name = guide.getKeyName(source)
        source._globalNode = m.declareGlobal(name, uri, source)
    end)
    : case 'getglobal'
    : call(function (uri, source)
        local name   = guide.getKeyName(source)
        local global = m.getGlobal(name)
        global:addGet(uri, source)
        source._globalNode = global

        local nxt = source.next
        if nxt then
            m.compileNode(uri, nxt)
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
        local name = parent:getName() .. m.ID_SPLITE .. guide.getKeyName(source)
        source._globalNode = m.declareGlobal(name, uri, source)
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
        local global = m.getGlobal(name)
        global:addGet(uri, source)
        source._globalNode = global

        local nxt = source.next
        if nxt then
            m.compileNode(uri, nxt)
        end
    end)
    : getMap()


---@param name   string
---@param uri    uri
---@param source parser.object
---@return vm.node.global
function m.declareGlobal(name, uri, source)
    m.globalSubs[uri][name] = true
    local node = m.globals[name]
    node:addSet(uri, source)
    return node
end

---@param name string
---@param uri? uri
---@return vm.node.global
function m.getGlobal(name, uri)
    if uri then
        m.globalSubs[uri][name] = true
    end
    return m.globals[name]
end

---@param source parser.object
function m.compileNode(uri, source)
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
    m.compileNode(uri, env)
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
        m.globals[name]:dropUri(uri)
    end
end

return m
