local util  = require 'utility'
local scope = require 'workspace.scope'
local guide = require 'parser.guide'
local files = require 'files'
local ws    = require 'workspace'
---@class vm
local vm    = require 'vm.vm'

---@class vm.global.link
---@field gets   parser.object[]
---@field sets   parser.object[]

---@class vm.global
---@field links table<uri, vm.global.link>
---@field setsCache? table<uri, parser.object[]>
---@field getsCache? table<uri, parser.object[]>
---@field cate vm.global.cate
local mt = {}
mt.__index = mt
mt.type = 'global'
mt.name = ''

---@param uri    uri
---@param source parser.object
function mt:addSet(uri, source)
    local link = self.links[uri]
    if not link.sets then
        link.sets = {}
    end
    link.sets[#link.sets+1] = source
    self.setsCache = nil
end

---@param uri    uri
---@param source parser.object
function mt:addGet(uri, source)
    local link = self.links[uri]
    if not link.gets then
        link.gets = {}
    end
    link.gets[#link.gets+1] = source
    self.getsCache = nil
end

---@param suri  uri
---@return parser.object[]
function mt:getSets(suri)
    if not self.setsCache then
        self.setsCache = {}
    end
    local scp = scope.getScope(suri)
    local cacheUri = scp.uri or '<callback>'
    if self.setsCache[cacheUri] then
        return self.setsCache[cacheUri]
    end
    self.setsCache[cacheUri] = {}
    local cache = self.setsCache[cacheUri]
    for uri, link in pairs(self.links) do
        if link.sets then
            if scp:isVisible(uri) then
                for _, source in ipairs(link.sets) do
                    cache[#cache+1] = source
                end
            end
        end
    end
    return cache
end

---@return parser.object[]
function mt:getGets(suri)
    if not self.getsCache then
        self.getsCache = {}
    end
    local scp = scope.getScope(suri)
    local cacheUri = scp.uri or '<callback>'
    if self.getsCache[cacheUri] then
        return self.getsCache[cacheUri]
    end
    self.getsCache[cacheUri] = {}
    local cache = self.getsCache[cacheUri]
    for uri, link in pairs(self.links) do
        if link.gets then
            if scp:isVisible(uri) then
                for _, source in ipairs(link.gets) do
                    cache[#cache+1] = source
                end
            end
        end
    end
    return cache
end

---@param uri uri
function mt:dropUri(uri)
    self.links[uri] = nil
    self.setsCache = nil
    self.getsCache = nil
end

---@return string
function mt:getName()
    return self.name
end

---@return string
function mt:getCodeName()
    return (self.name:gsub(vm.ID_SPLITE, '.'))
end

---@return string
function mt:asKeyName()
    return self.cate .. '|' .. self.name
end

---@return string
function mt:getKeyName()
    return self.name:match('[^' .. vm.ID_SPLITE .. ']+$')
end

---@return boolean
function mt:isAlive()
    return next(self.links) ~= nil
end

---@param cate vm.global.cate
---@return vm.global
local function createGlobal(name, cate)
    return setmetatable({
        name  = name,
        cate  = cate,
        links = util.multiTable(2),
    }, mt)
end

---@class parser.object
---@field _globalNode vm.global|false
---@field _enums?     (string|integer)[]

---@type table<string, vm.global>
local allGlobals = {}
---@type table<uri, table<string, boolean>>
local globalSubs = util.multiTable(2)

local compileObject
local compilerGlobalSwitch = util.switch()
    : case 'local'
    : call(function (source)
        if source.special ~= '_G' then
            return
        end
        if source.ref then
            for _, ref in ipairs(source.ref) do
                compileObject(ref)
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
        compileObject(source.next)
    end)
    : case 'setglobal'
    : call(function (source)
        local uri    = guide.getUri(source)
        local name   = guide.getKeyName(source)
        if not name then
            return
        end
        local global = vm.declareGlobal('variable', name, uri)
        global:addSet(uri, source)
        source._globalNode = global
    end)
    : case 'getglobal'
    : call(function (source)
        local uri    = guide.getUri(source)
        local name   = guide.getKeyName(source)
        if not name then
            return
        end
        local global = vm.declareGlobal('variable', name, uri)
        global:addGet(uri, source)
        source._globalNode = global

        local nxt = source.next
        if nxt then
            compileObject(nxt)
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
                name = ('%s%s%s'):format(parentName, vm.ID_SPLITE, keyName)
            end
        elseif source.node.special == '_G' then
            name = keyName
        end
        if not name then
            return
        end
        local uri    = guide.getUri(source)
        local global = vm.declareGlobal('variable', name, uri)
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
                name = ('%s%s%s'):format(parentName, vm.ID_SPLITE, keyName)
            end
        elseif source.node.special == '_G' then
            name = keyName
        end
        local uri    = guide.getUri(source)
        local global = vm.declareGlobal('variable', name, uri)
        global:addGet(uri, source)
        source._globalNode = global

        local nxt = source.next
        if nxt then
            compileObject(nxt)
        end
    end)
    : case 'call'
    : call(function (source)
        if source.node.special == 'rawset'
        or source.node.special == 'rawget' then
            if not source.args then
                return
            end
            local g     = source.args[1]
            local key   = source.args[2]
            if g and key and g.special == '_G' then
                local name = guide.getKeyName(key)
                if name then
                    local uri    = guide.getUri(source)
                    local global = vm.declareGlobal('variable', name, uri)
                    if source.node.special == 'rawset' then
                        global:addSet(uri, source)
                        source.value = source.args[3]
                    else
                        global:addGet(uri, source)
                    end
                    source._globalNode = global

                    local nxt = source.next
                    if nxt then
                        compileObject(nxt)
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
        if not name then
            return
        end
        local class = vm.declareGlobal('type', name, uri)
        class:addSet(uri, source)
        source._globalNode = class

        if source.signs then
            source._sign = vm.createSign()
            for _, sign in ipairs(source.signs) do
                source._sign:addSign(vm.compileNode(sign))
            end
            if source.extends then
                for _, ext in ipairs(source.extends) do
                    if ext.type == 'doc.type.table' then
                        ext._generic = vm.createGeneric(ext, source._sign)
                    end
                end
            end
        end
    end)
    : case 'doc.alias'
    : call(function (source)
        local uri  = guide.getUri(source)
        local name = guide.getKeyName(source)
        if not name then
            return
        end
        local alias = vm.declareGlobal('type', name, uri)
        alias:addSet(uri, source)
        source._globalNode = alias

        if source.signs then
            source._sign = vm.createSign()
            for _, sign in ipairs(source.signs) do
                source._sign:addSign(vm.compileNode(sign))
            end
            source.extends._generic = vm.createGeneric(source.extends, source._sign)
        end
    end)
    : case 'doc.enum'
    : call(function (source)
        local uri  = guide.getUri(source)
        local name = guide.getKeyName(source)
        if not name then
            return
        end
        local enum = vm.declareGlobal('type', name, uri)
        enum:addSet(uri, source)
        source._globalNode = enum

        local tbl = source.bindSource
        if not tbl then
            return
        end
        source._enums = {}
        for _, field in ipairs(tbl) do
            if field.type == 'tablefield'
            or field.type == 'tableindex' then
                if not field.value then
                    goto CONTINUE
                end
                local key = guide.getKeyName(field)
                if not key then
                    goto CONTINUE
                end
                if field.value.type == 'integer'
                or field.value.type == 'string' then
                    source._enums[#source._enums+1] = field.value[1]
                end
                if field.value.type == 'binary'
                or field.value.type == 'unary' then
                    source._enums[#source._enums+1] = vm.getNumber(field.value)
                end
                ::CONTINUE::
            end
        end
    end)
    : case 'doc.type.name'
    : call(function (source)
        local uri  = guide.getUri(source)
        local name = source[1]
        if name == '_' then
            return
        end
        local type = vm.declareGlobal('type', name, uri)
        type:addGet(uri, source)
        source._globalNode = type
    end)
    : case 'doc.extends.name'
    : call(function (source)
        local uri  = guide.getUri(source)
        local name = source[1]
        local class = vm.declareGlobal('type', name, uri)
        class:addGet(uri, source)
        source._globalNode = class
    end)


---@alias vm.global.cate '"variable"' | '"type"'

---@param cate vm.global.cate
---@param name string
---@param uri? uri
---@return vm.global
function vm.declareGlobal(cate, name, uri)
    local key = cate .. '|' .. name
    if uri then
        globalSubs[uri][key] = true
    end
    if not allGlobals[key] then
        allGlobals[key] = createGlobal(name, cate)
    end
    return allGlobals[key]
end

---@param cate   vm.global.cate
---@param name   string
---@param field? string
---@return vm.global?
function vm.getGlobal(cate, name, field)
    local key = cate .. '|' .. name
    if field then
        key = key .. vm.ID_SPLITE .. field
    end
    return allGlobals[key]
end

---@param cate   vm.global.cate
---@param name   string
---@return vm.global[]
function vm.getGlobalFields(cate, name)
    local globals = {}
    local key = cate .. '|' .. name

    local clock = os.clock()
    for gid, global in pairs(allGlobals) do
        if  gid ~= key
        and util.stringStartWith(gid, key)
        and gid:sub(#key + 1, #key + 1) == vm.ID_SPLITE
        and not gid:find(vm.ID_SPLITE, #key + 2) then
            globals[#globals+1] = global
        end
    end
    local cost = os.clock() - clock
    if cost > 0.1 then
        log.warn('global-manager getFields cost %.3f', cost)
    end

    return globals
end

---@param cate   vm.global.cate
---@return vm.global[]
function vm.getGlobals(cate)
    local globals = {}

    local clock = os.clock()
    for gid, global in pairs(allGlobals) do
        if  util.stringStartWith(gid, cate)
        and not gid:find(vm.ID_SPLITE) then
            globals[#globals+1] = global
        end
    end
    local cost = os.clock() - clock
    if cost > 0.1 then
        log.warn('global-manager getGlobals cost %.3f', cost)
    end

    return globals
end

---@param suri uri
---@param cate   vm.global.cate
---@return parser.object[]
function vm.getGlobalSets(suri, cate)
    local globals = vm.getGlobals(cate)
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
function vm.hasGlobalSets(suri, cate, name)
    local global = vm.getGlobal(cate, name)
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
function compileObject(source)
    if source._globalNode ~= nil then
        return
    end
    source._globalNode = false
    compilerGlobalSwitch(source.type, source)
end

---@param source parser.object
local function compileSelf(source)
    if source.parent.type ~= 'funcargs' then
        return
    end
    ---@type parser.object
    local node = source.parent.parent and source.parent.parent.parent and source.parent.parent.parent.node
    if not node then
        return
    end
    local fields = vm.getLocalFields(source, false)
    if not fields then
        return
    end
    local nodeLocalID = vm.getLocalID(node)
    local globalNode  = node._globalNode
    if not nodeLocalID and not globalNode then
        return
    end
    for _, field in ipairs(fields) do
        if field.type == 'setfield' then
            local key = guide.getKeyName(field)
            if key then
                if nodeLocalID then
                    local myID = nodeLocalID .. vm.ID_SPLITE .. key
                    vm.insertLocalID(myID, field)
                end
                if globalNode then
                    local myID = globalNode:getName() .. vm.ID_SPLITE .. key
                    local myGlobal = vm.declareGlobal('variable', myID, guide.getUri(node))
                    myGlobal:addSet(guide.getUri(node), field)
                end
            end
        end
    end
end

---@param source parser.object
local function compileAst(source)
    local env = guide.getENV(source)
    if not env then
        return
    end
    compileObject(env)
    guide.eachSpecialOf(source, 'rawset', function (src)
        compileObject(src.parent)
    end)
    guide.eachSpecialOf(source, 'rawget', function (src)
        compileObject(src.parent)
    end)
    guide.eachSourceTypes(source.docs, {
        'doc.class',
        'doc.alias',
        'doc.type.name',
        'doc.extends.name',
        'doc.enum',
    }, function (src)
        compileObject(src)
    end)

    --[[
    local mt
    function mt:xxx()
        self.a = 1
    end

    mt.a --> find this definition
    ]]
    guide.eachSourceType(source, 'self', function (src)
        compileSelf(src)
    end)
end

---@param uri uri
local function dropUri(uri)
    local globalSub = globalSubs[uri]
    globalSubs[uri] = nil
    for key in pairs(globalSub) do
        local global = allGlobals[key]
        if global then
            global:dropUri(uri)
            if not global:isAlive() then
                allGlobals[key] = nil
            end
        end
    end
end

for uri in files.eachFile() do
    local state = files.getState(uri)
    if state then
        compileAst(state.ast)
    end
end

---@async
files.watch(function (ev, uri)
    if ev == 'update' then
        dropUri(uri)
        ws.awaitReady(uri)
        local state = files.getState(uri)
        if state then
            compileAst(state.ast)
        end
    end
    if ev == 'remove' then
        dropUri(uri)
    end
end)
