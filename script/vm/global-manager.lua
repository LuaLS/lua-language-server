local util          = require 'utility'
local guide         = require 'parser.guide'
local globalBuilder = require 'vm.global'
local signMgr       = require 'vm.sign'
local genericMgr    = require 'vm.generic'
---@class vm
local vm            = require 'vm.vm'

---@class parser.object
---@field _globalNode vm.global

---@class vm.global-manager
local m = {}
---@type table<string, vm.global>
m.globals = {}
---@type table<uri, table<string, boolean>>
m.globalSubs = util.multiTable(2)

m.ID_SPLITE = '\x1F'

local compilerGlobalSwitch = util.switch()
    : case 'local'
    : call(function (source)
        if source.special ~= '_G' then
            return
        end
        if source.ref then
            for _, ref in ipairs(source.ref) do
                m.compileObject(ref)
            end
        end
    end)
    : case 'getlocal'
    : call(function (source)
        if source.special ~= '_G' then
            return
        end
        if not source.next then
            return
        end
        m.compileObject(source.next)
    end)
    : case 'setglobal'
    : call(function (source)
        local uri    = guide.getUri(source)
        local name   = guide.getKeyName(source)
        local global = m.declareGlobal('variable', name, uri)
        global:addSet(uri, source)
        source._globalNode = global
    end)
    : case 'getglobal'
    : call(function (source)
        local uri    = guide.getUri(source)
        local name   = guide.getKeyName(source)
        local global = m.declareGlobal('variable', name, uri)
        global:addGet(uri, source)
        source._globalNode = global

        local nxt = source.next
        if nxt then
            m.compileObject(nxt)
        end
    end)
    : case 'setfield'
    : case 'setmethod'
    : case 'setindex'
    ---@param source parser.object
    : call(function (source)
        local name
        local keyName = guide.getKeyName(source)
        if not keyName then
            return
        end
        if source.node._globalNode then
            local parentName = source.node._globalNode:getName()
            if parentName == '_G' then
                name = keyName
            else
                name = ('%s%s%s'):format(parentName, m.ID_SPLITE, keyName)
            end
        elseif source.node.special == '_G' then
            name = keyName
        end
        if not name then
            return
        end
        local uri    = guide.getUri(source)
        local global = m.declareGlobal('variable', name, uri)
        global:addSet(uri, source)
        source._globalNode = global
    end)
    : case 'getfield'
    : case 'getmethod'
    : case 'getindex'
    ---@param source parser.object
    : call(function (source)
        local name
        local keyName = guide.getKeyName(source)
        if not keyName then
            return
        end
        if source.node._globalNode then
            local parentName = source.node._globalNode:getName()
            if parentName == '_G' then
                name = keyName
            else
                name = ('%s%s%s'):format(parentName, m.ID_SPLITE, keyName)
            end
        elseif source.node.special == '_G' then
            name = keyName
        end
        local uri    = guide.getUri(source)
        local global = m.declareGlobal('variable', name, uri)
        global:addGet(uri, source)
        source._globalNode = global

        local nxt = source.next
        if nxt then
            m.compileObject(nxt)
        end
    end)
    : case 'call'
    : call(function (source)
        if source.node.special == 'rawset'
        or source.node.special == 'rawget' then
            local g     = source.args[1]
            local key   = source.args[2]
            if g and key and g.special == '_G' then
                local name = guide.getKeyName(key)
                if name then
                    local uri    = guide.getUri(source)
                    local global = m.declareGlobal('variable', name, uri)
                    if source.node.special == 'rawset' then
                        global:addSet(uri, source)
                        source.value = source.args[3]
                    else
                        global:addGet(uri, source)
                    end
                    source._globalNode = global

                    local nxt = source.next
                    if nxt then
                        m.compileObject(nxt)
                    end
                end
            end
        end
    end)
    : case 'doc.class'
    ---@param source parser.object
    : call(function (source)
        local uri  = guide.getUri(source)
        local name = guide.getKeyName(source)
        local class = m.declareGlobal('type', name, uri)
        class:addSet(uri, source)
        source._globalNode = class

        if source.signs then
            source._sign = signMgr()
            for _, sign in ipairs(source.signs) do
                source._sign:addSign(vm.compileNode(sign))
            end
            if source.extends then
                for _, ext in ipairs(source.extends) do
                    if ext.type == 'doc.type.table' then
                        ext._generic = genericMgr(ext, source._sign)
                    end
                end
            end
        end
    end)
    : case 'doc.alias'
    : call(function (source)
        local uri  = guide.getUri(source)
        local name = guide.getKeyName(source)
        local alias = m.declareGlobal('type', name, uri)
        alias:addSet(uri, source)
        source._globalNode = alias

        if source.signs then
            source._sign = signMgr()
            for _, sign in ipairs(source.signs) do
                source._sign:addSign(vm.compileNode(sign))
            end
            source.extends._generic = genericMgr(source.extends, source._sign)
        end
    end)
    : case 'doc.type.name'
    : call(function (source)
        local uri  = guide.getUri(source)
        local name = source[1]
        local type = m.declareGlobal('type', name, uri)
        type:addGet(uri, source)
        if not source.signs then
            source._globalNode = type
        end
    end)
    : case 'doc.extends.name'
    : call(function (source)
        local uri  = guide.getUri(source)
        local name = source[1]
        local class = m.declareGlobal('type', name, uri)
        class:addGet(uri, source)
        source._globalNode = class
    end)


---@alias vm.global.cate '"variable"' | '"type"'

---@param cate vm.global.cate
---@param name string
---@param uri  uri
---@return vm.global
function m.declareGlobal(cate, name, uri)
    local key = cate .. '|' .. name
    m.globalSubs[uri][key] = true
    if not m.globals[key] then
        m.globals[key] = globalBuilder(name, cate)
    end
    return m.globals[key]
end

---@param cate   vm.global.cate
---@param name   string
---@param field? string
---@return vm.global?
function m.getGlobal(cate, name, field)
    local key = cate .. '|' .. name
    if field then
        key = key .. m.ID_SPLITE .. field
    end
    return m.globals[key]
end

---@param cate   vm.global.cate
---@param name   string
---@return vm.global[]
function m.getFields(cate, name)
    local globals = {}
    local key = cate .. '|' .. name

    -- TODO: optimize
    for gid, global in pairs(m.globals) do
        if  gid ~= key
        and util.stringStartWith(gid, key)
        and gid:sub(#key + 1, #key + 1) == m.ID_SPLITE
        and not gid:find(m.ID_SPLITE, #key + 2) then
            globals[#globals+1] = global
        end
    end

    return globals
end

---@param cate   vm.global.cate
---@return vm.global[]
function m.getGlobals(cate)
    local globals = {}

    -- TODO: optimize
    for gid, global in pairs(m.globals) do
        if  util.stringStartWith(gid, cate)
        and not gid:find(m.ID_SPLITE) then
            globals[#globals+1] = global
        end
    end

    return globals
end

---@param suri uri
---@param cate   vm.global.cate
---@return parser.object[]
function m.getGlobalSets(suri, cate)
    local globals = m.getGlobals(cate)
    local result = {}
    for _, global in ipairs(globals) do
        local sets = global:getSets(suri)
        for _, set in ipairs(sets) do
            result[#result+1] = set
        end
    end
    return result
end

---@param suri uri
---@param cate vm.global.cate
---@param name string
---@return boolean
function m.hasGlobalSets(suri, cate, name)
    local global = m.getGlobal(cate, name)
    if not global then
        return false
    end
    local sets = global:getSets(suri)
    if #sets == 0 then
        return false
    end
    return true
end

---@param source parser.object
function m.compileObject(source)
    if source._globalNode ~= nil then
        return
    end
    source._globalNode = false
    compilerGlobalSwitch(source.type, source)
end

---@param source parser.object
function m.compileAst(source)
    local env = guide.getENV(source)
    m.compileObject(env)
    guide.eachSpecialOf(source, 'rawset', function (src)
        m.compileObject(src.parent)
    end)
    guide.eachSpecialOf(source, 'rawget', function (src)
        m.compileObject(src.parent)
    end)
    guide.eachSourceTypes(source.docs, {
        'doc.class',
        'doc.alias',
        'doc.type.name',
        'doc.extends.name',
    }, function (src)
        m.compileObject(src)
    end)
end

---@return vm.global
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
    for key in pairs(globalSub) do
        local global = m.globals[key]
        if global then
            global:dropUri(uri)
            if not global:isAlive() then
                m.globals[key] = nil
            end
        end
    end
end

return m
